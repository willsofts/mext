import { KnModel, KnOperation } from "@willsofts/will-db";
import { KnDBConnector, KnSQLInterface, KnRecordSet, KnResultSet, KnSQL } from "@willsofts/will-sql";
import { HTTP } from "@willsofts/will-api";
import { Utilities } from "@willsofts/will-util";
import { TknOperateHandler } from '@willsofts/will-serv';
import { KnValidateInfo, KnContextInfo, KnDataTable } from '@willsofts/will-core';
import { VerifyError } from '@willsofts/will-core';

export class Sfte008Handler extends TknOperateHandler {

    public progid = "sfte008";
    public model : KnModel = { 
        name: "tgroup", 
        alias: { privateAlias: this.section }, 
        fields: {
            groupname: { type: "STRING", key: true },
            menutext: { type: "STRING", updated: true },
            editdate: { type: "DATE", selected: false, created: true, updated: true },
            edittime: { type: "TIME", selected: false, created: true, updated: true },
            edituser: { type: "STRING", selected: false, created: true, updated: true }
        },
    };

    /* try to assign individual parameters under this context */
    protected override async assignParameters(context: KnContextInfo, sql: KnSQLInterface, action?: string, mode?: string) {
        let now = Utilities.now();
        sql.set("editdate",now,"DATE");
        sql.set("edittime",now,"TIME");
        sql.set("edituser",this.userToken?.userid);
        let menutext = context.params.menutext;
        if(typeof menutext !== "string") {
            sql.set("menutext",JSON.stringify(menutext));
        } else {
            sql.set("menutext",menutext);
        }
    }

    /* try to validate fields for insert, update, delete, retrieve */
    protected override validateRequireFields(context: KnContextInfo, model: KnModel, action: string) : Promise<KnValidateInfo> {
        let vi = this.validateParameters(context.params,"groupname");
        if(!vi.valid) {
            return Promise.reject(new VerifyError("Parameter not found ("+vi.info+")",HTTP.NOT_ACCEPTABLE,-16061));
        }
        return Promise.resolve(vi);
    }

    protected override buildFilterQuery(context: KnContextInfo, model: KnModel, knsql: KnSQLInterface, selector: string, action?: string, subaction?: string): KnSQLInterface {
        if(this.isCollectMode(action)) {
            let params = context.params;
            knsql.append(selector);
            knsql.append(" from ");
            knsql.append(model.name);
            let filter = " where ";
            if(params.groupname && params.groupname!="") {
                knsql.append(filter).append("groupname LIKE ?groupname");
                knsql.set("groupname","%"+params.groupname+"%");
                filter = " and ";
            }
            return knsql;    
        }
        return super.buildFilterQuery(context, model, knsql, selector, action, subaction);
    }

    protected override async doCategories(context: KnContextInfo, model: KnModel) : Promise<KnDataTable> {
        let db = this.getPrivateConnector(model);
        try {
            return await this.performCategories(context, model, db);
        } catch(ex: any) {
            this.logger.error(this.constructor.name,ex);
            return Promise.reject(this.getDBError(ex));
		} finally {
			if(db) db.close();
        }
    }

    protected async performCategories(context: KnContextInfo, model: KnModel, db: KnDBConnector) : Promise<KnDataTable> {
        let settings = this.getCategorySetting(context, "tgroup", "tprog", "tkpermit");
        return await this.getDataCategories(context, db, settings);
    }

    protected override async doExecute(context: KnContextInfo, model: KnModel) : Promise<KnDataTable> {
        try {
            let dt = await this.doCategories(context, model);
            dt.action = KnOperation.EXECUTE;
            dt.dataset = this.emptyDataSet();
            return dt;
        } catch(ex: any) {
            this.logger.error(this.constructor.name,ex);
            return Promise.reject(this.getDBError(ex));
        }
    }

    protected override async doRetrieving(context: KnContextInfo, model: KnModel, action: string = KnOperation.RETRIEVE): Promise<KnDataTable> {
        let db = this.getPrivateConnector(model);
        try {
            let rs = await this.performRetrieving(context, db, context.params.groupname);
            if(rs.rows.length>0) {
                let row = this.transformData(rs.rows[0]);
                return this.createDataTable(KnOperation.RETRIEVE, row);
            }
            return this.recordNotFound();
        } catch(ex: any) {
            this.logger.error(this.constructor.name,ex);
            return Promise.reject(this.getDBError(ex));
		} finally {
			if(db) db.close();
        }
    }

    protected async performRetrieving(context: KnContextInfo, db: KnDBConnector, groupname: string): Promise<KnRecordSet> {
        if(!groupname || groupname.trim().length == 0) return this.createRecordSet();
        let knsql = new KnSQL();
        knsql.append("select * from tgroup where groupname = ?groupname ");
        knsql.set("groupname",groupname);
        let rs = await knsql.executeQuery(db,context);
        return this.createRecordSet(rs);
    }
    
    protected cleanMenuItems(node: any) {
        let jsons = node?.items;
        if(jsons) {
            node.items = jsons.filter((item: any) => item != null);
            jsons = node.items;
            for(let json of jsons) {
                this.cleanMenuItems(json);
            }
        }
    }

    public cleanMenu(json: any) {
        if(json) {
            this.cleanMenuItems(json);
        }
    }

    protected initMap(jsons: any, map: Map<string,any>) {
        if(jsons) {
            for(let json of jsons) {
                if(json) {                            
                    let progid = json?.itemname;
                    if(progid && progid.trim().length>0) {
                        map.set(progid,json);                
                    }
                    this.initMap(json?.items,map);
                }
            }
        }
    }

    public getMap(json: any) : Map<string,any> {
        let map = new Map<string,any>();
        if(json) {
            this.initMap(json?.items,map);
        }
        return map;
    }

    public async updatePermits(context: KnContextInfo, model: KnModel, db: KnDBConnector) : Promise<KnRecordSet> {
        let groupname = context.params.groupname;
        let menutext = context.params.menutext;
        let result = this.createRecordSet();
        let menujson = menutext;
        if(typeof menutext === "string" && menutext.trim().length>0) {
            menujson = JSON.parse(menutext);
        }
        if((groupname && groupname.trim().length>0) && menujson) { 
            this.cleanMenu(menujson);
            context.params.menutext = JSON.stringify(menujson);
            let map = this.getMap(menujson);
            if(map.size > 0) {                                
                let delsql = new KnSQL();
                delsql.append("delete from tpperm ");
                delsql.append("where groupid = ?groupid ");
                delsql.append("and progid = ?progid ");
                let knsql = new KnSQL();
                knsql.append("insert into tpperm (groupid,progid,permname,permvalue) ");
                knsql.append("values(?groupid,?progid,?permname,?permvalue)");
                for(let [progid,item] of map) {
                    delsql.set("groupid",groupname);
                    delsql.set("progid",progid);
                    this.dump(delsql);
                    await delsql.executeUpdate(db,context);
                    let permits = item?.permits;
                    if(permits) {
                        for(let permname in permits) {
                            let permvalue = permits[permname];
                            knsql.set("groupid",groupname);
                            knsql.set("progid",progid);
                            knsql.set("permname",permname);
                            knsql.set("permvalue",String(permvalue));
                            this.dump(knsql);
                            let rs = await knsql.executeUpdate(db,context);
                            result.records += rs.rows.affectedRows?rs.rows.affectedRows:0;                                
                        }
                    }
                }
                //find out old program id list in this group name
                let prglist = new Set<string>();
                knsql.clear();
                knsql.append("select tproggrp.programid,tprog.progtype ");
                knsql.append("from tproggrp ");
                knsql.append("LEFT JOIN tprog ON tprog.programid = tproggrp.programid ");
                knsql.append("where tproggrp.groupname = ?groupname ");
                knsql.set("groupname",groupname);
                this.dump(knsql);
                let rs = await knsql.executeQuery(db,context);
                if(rs.rows.length>0) {
                    for(let i=0;i<rs.rows.length;i++) {
                        let row = rs.rows[i];
                        let progid = row.programid;
                        let progtype = row.progtype;
                        //ignore program plugin (I) or Internal (N)
                        let ignoreProg = "I"==progtype || "N"==progtype;
                        if(!ignoreProg) {
                            prglist.add(progid);
                        }
                    }    
                }
                //update program group if not found then insert the new one
                let updsql = new KnSQL();
                updsql.append("update tproggrp set parameters = ?parameters, seqno = ?seqno ");
                updsql.append("where groupname = ?groupname and programid = ?programid ");
                knsql.clear();
                knsql.append("insert into tproggrp(groupname,programid,parameters,seqno) ");
                knsql.append("values(?groupname,?programid,?parameters,?seqno) ");
                let seqno = 0;
                for(let [progid,item] of map) {
                    seqno++;
                    let parameters = item?.parameters;
                    updsql.set("groupname", groupname);
                    updsql.set("programid", progid);
                    updsql.set("parameters", parameters);
                    updsql.set("seqno", seqno);
                    this.dump(updsql);
                    let reply = await updsql.executeUpdate(db,context);
                    let rss = this.createRecordSet(reply);
                    if(rss.records==0) {
                        knsql.set("groupname", groupname);
                        knsql.set("programid", progid);
                        knsql.set("parameters", parameters);
                        knsql.set("seqno", seqno);
                        this.dump(knsql);
                        await knsql.executeUpdate(db,context);                            
                    }
                }
			    //try to delete program id out of this group name if not found in current menu tree
			    knsql.clear();
			    knsql.append("delete from tproggrp where groupname = ?groupname ");
                knsql.append("and programid = ?programid ");
                for(let progid of prglist) {
                    if(!map.get(progid)) {
                        delsql.set("groupid", groupname);
                        delsql.set("progid", progid);
                        this.dump(delsql);
                        await delsql.executeUpdate(db,context);                        
                        knsql.set("groupname", groupname);
                        knsql.set("programid", progid);
                        this.dump(knsql);
                        await knsql.executeUpdate(db,context);    
                    }
                }
            }
        }
        return result;
    }

    public async deletePermitGroup(context: KnContextInfo, model: KnModel, db: KnDBConnector) : Promise<KnRecordSet> {
        let knsql = new KnSQL();
        knsql.append("delete from tpperm ");
        knsql.append("where groupid = ?groupid ");
        knsql.set("groupid",context.params.groupname);
        let rs = await knsql.executeUpdate(db,context);
        return this.createRecordSet(rs);
    }

    public async deleteProgramGroup(context: KnContextInfo, model: KnModel, db: KnDBConnector) : Promise<KnRecordSet> {
        let knsql = new KnSQL();
        knsql.append("delete from tproggrp where groupname = ?groupname ");
        knsql.set("groupname",context.params.groupname);
        let rs = await knsql.executeUpdate(db,context);
        return this.createRecordSet(rs);
    }

    protected override async performClearing(context: any, model: KnModel, db: KnDBConnector): Promise<KnResultSet> {
        await this.deletePermitGroup(context, model, db);
        await this.deleteProgramGroup(context, model, db);
        return await super.performClearing(context, model, db);
    }

    protected override async performUpdating(context: any, model: KnModel, db: KnDBConnector): Promise<KnResultSet> {
        let rs = await this.updatePermits(context, model, db);
        if(rs.records==0) {
            await this.deletePermitGroup(context, model, db);
            await this.deleteProgramGroup(context, model, db);
        }
        return await super.performUpdating(context, model, db);
    }

    protected override async doClear(context: KnContextInfo, model: KnModel) : Promise<KnResultSet> {
        await this.validateRequireFields(context, model, KnOperation.CLEAR);
        let db = this.getPrivateConnector(model);
        try {
            await db.beginWork();
            context.params.menutext = undefined;
            await this.deletePermitGroup(context, model, db);
            await this.deleteProgramGroup(context, model, db);
            let result = await super.performUpdating(context, model, db);
            await db.commitWork();
            return result;
        } catch(ex: any) {
            this.logger.error(ex);
            db.rollbackWork().catch(ex => this.logger.error(ex));
            return Promise.reject(this.getDBError(ex));
        } finally {
            if(db) db.close();
        }
    }

}

/*
update: this will update menutext and permissions
curl -v -X POST -H "Content-Type: application/json" "http://localhost:8080/api/sfte008/update" -d @D:\Projects\Node\json\TESTER.json
curl -v -X POST -H "Content-Type: application/json" "http://localhost:8080/api/sfte008/update" -d @D:\Projects\Node\json\TESTING.json

remove: this will delete all records
curl -v -X POST http://localhost:8080/api/sfte008/remove -d groupname=TSOGRP

clear: this will update menutext = null and delete all permissions
curl -v -X POST http://localhost:8080/api/sfte008/clear -d groupname=TSOGRP
*/
