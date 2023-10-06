import { KnModel, KnTrackingInfo } from "@willsofts/will-db";
import { KnRecordSet, KnResultSet, KnSQL } from '@willsofts/will-sql';
import { Utilities } from "@willsofts/will-util";
import { TknBaseHandler } from "./TknBaseHandler";
import { DB_TRACKER } from "../utils/EnvironmentVariable";

export class TknTrackingHandler extends TknBaseHandler {
    public model : KnModel = { name: "tul", alias: { privateAlias: DB_TRACKER } };
    public trackInfo? : KnTrackingInfo;

    public override insert(context: any) : Promise<KnResultSet> {
        if(this.model && this.isValidModelConfig("privateAlias",this.model)) {
            //do not call exposeFunctional or track otherwise it circular tracking
            return this.doInsert(context, this.model);
        }
        return Promise.resolve({rows: null, columns: null});
    }
        
    protected override async doInsert(context: any, model: KnModel) : Promise<KnRecordSet> {
        let db = this.getPrivateConnector(model);
        try {
            let user = await this.getUserTokenInfo(context,true);
            let token = this.getTokenKey(context);
            let headers = context.meta.headers;
            let params = { ...context.params };
            delete params.req;
            delete params.res;
            let req = context.meta.req;
            if(!req && context.options && context.options.parentCtx && context.options.parentCtx.params && context.options.parentCtx.params.req) req = context.options.parentCtx.params.req;
            let ip = null;
            if(req) ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress
            let sql = new KnSQL("insert into tul (seqno,curtime,useralias,userid,site,progid,handler,action,remark,token,address,paths,headers,requests) ");
            sql.append("values(?seqno,?curtime,?useralias,?userid,?site,?progid,?handler,?action,?remark,?token,?address,?paths,?headers,?requests)");
            sql.set("seqno",Utilities.currentTimeMillis());
            sql.set("curtime",Utilities.now());
            sql.set("useralias",user?.useruuid);
            sql.set("userid",user?.userid);
            sql.set("site",user?.site);
            sql.set("progid",this.trackInfo?.tracker);
            sql.set("handler",this.trackInfo?.model);
            sql.set("action",this.trackInfo?.method);
            sql.set("remark",this.trackInfo?.info?JSON.stringify(this.trackInfo?.info):null);
            sql.set("token",token);
            sql.set("address",ip);
            sql.set("paths",req?req.originalUrl:null);
            sql.set("headers",headers?JSON.stringify(headers):null);
            sql.set("requests",params?JSON.stringify(params):null);
            let rs = await sql.executeUpdate(db,context);
            return this.createRecordSet(rs);
        } catch(ex: any) {
            this.logger.error(this.constructor.name,ex);
            return Promise.reject(this.getDBError(ex));
        } finally {
            db.close();
        }
    }

}