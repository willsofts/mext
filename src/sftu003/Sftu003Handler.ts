import { KnModel, KnOperation } from "@willsofts/will-db";
import { KnDBConnector, KnSQLInterface, KnRecordSet, KnSQL } from "@willsofts/will-sql";
import { HTTP } from "@willsofts/will-api";
import { KnValidateInfo, KnContextInfo, KnDataTable } from '@willsofts/will-core';
import { VerifyError } from '@willsofts/will-core';
import { KnPageUtility } from '@willsofts/will-core';
import { Utilities } from "@willsofts/will-util";
import { TknOperateHandler } from '@willsofts/will-serv';
import { OPERATE_HANDLERS } from "@willsofts/will-serv";
import { KnDataResult } from "@willsofts/will-serv";

export class Sftu003Handler extends TknOperateHandler {

    public progid = "sftu003";
    public model : KnModel = { 
        name: "api_config", 
        alias: { privateAlias: this.section }, 
        fields: {
            apiname: { type: "STRING", key: true, created: true },
            apiquery: { type: "STRING" },
            apiparams: { type: "STRING" },
            apisection: { type: "STRING" },
            inactive: { type: "STRING", created: true, defaultValue: "0" },
            createdate: { type: "DATE", created: true },
            createtime: { type: "TIME", created: true },
            createuser: { type: "STRING", created: true },
            editdate: { type: "DATE", selected: false, created: true, updated: true },
            edittime: { type: "TIME", selected: false, created: true, updated: true },
            edituser: { type: "STRING", selected: false, created: true, updated: true },
        },
        //prefix naming with table name when select ex. table.column1,table.column2,...
        prefixNaming: true
    };

    public handlers = OPERATE_HANDLERS.concat([{name: "run"}]);

    public async run(context: KnContextInfo) : Promise<any> {
        return this.callFunctional(context, {operate: "run", raw: false}, this.doRun);
    }

    /* try to assign individual parameters under this context */
    protected override async assignParameters(context: KnContextInfo, sql: KnSQLInterface, action?: string, mode?: string) {
        let now = Utilities.now();
        if(KnOperation.COLLECT!=action) {
            sql.set("createdate",now,"DATE");
            sql.set("createtime",now,"TIME");
            sql.set("createuser",this.userToken?.userid);        
        }
        sql.set("editdate",now,"DATE");
        sql.set("edittime",now,"TIME");
        sql.set("edituser",this.userToken?.userid);
    }

    /* try to validate fields for insert, update, delete, retrieve */
    protected override validateRequireFields(context: KnContextInfo, model: KnModel, action: string) : Promise<KnValidateInfo> {
        let vi : KnValidateInfo = {valid: true};
        let page = new KnPageUtility(this.progid, context);
        if(page.isInsertMode(action)) {
            vi = this.validateParameters(context.params,"apiname","apiquery");
        } else {
            vi = this.validateParameters(context.params,"apiname");
        }
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
            if(params.apiname && params.apiname!="") {
                knsql.append(filter).append("apiname LIKE ?apiname");
                knsql.set("apiname","%"+params.apiname+"%");
                filter = " and ";
            }
            if(params.fromdate && params.fromdate!="") {
                let fromdate = Utilities.parseDate(params.fromdate);
                if(fromdate) {
                    knsql.append(filter).append("createdate >= ?fromdate");
                    knsql.set("fromdate",fromdate);
                    filter = " and ";
                }
            }
            if(params.todate && params.todate!="") {
                let todate = Utilities.parseDate(params.todate);
                if(todate) {
                    knsql.append(filter).append("createdate <= ?todate");
                    knsql.set("todate",todate);
                    filter = " and ";
                }
            }
            if(params.inactive && params.inactive!="") {
                knsql.append(filter).append("inactive = ?inactive");
                knsql.set("inactive",params.inactive);
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
			try { if(db) db.close(); } catch(er) { console.error(er); }
        }
    }

    protected async performCategories(context: KnContextInfo, model: KnModel, db: KnDBConnector) : Promise<KnDataTable> {
        let settings = this.getCategorySetting(context, "tkactive");
        return await this.getDataCategories(context, db, settings);
    }

    protected override async doRetrieving(context: KnContextInfo, model: KnModel, action: string = KnOperation.RETRIEVE): Promise<KnDataTable> {
        let db = this.getPrivateConnector(model);
        try {
            let rs = await this.performRetrieving(context, model, db);
            if(rs.rows.length>0) {
                let row = this.transformData(rs.rows[0]);
                return this.createDataTable(KnOperation.RETRIEVE, row);
            }
            return this.recordNotFound();
        } catch(ex: any) {
            this.logger.error(this.constructor.name,ex);
            return Promise.reject(this.getDBError(ex));
		} finally {
			try { if(db) db.close(); } catch(er) { console.error(er); }
        }
    }

    protected async performRetrieving(context: KnContextInfo, model: KnModel, db: KnDBConnector): Promise<KnRecordSet> {
        let knsql = new KnSQL();
        knsql.append("select * from api_config ");
        knsql.append("where apiname = ?apiname ");
        knsql.set("apiname",context.params.apiname);
        let rs = await knsql.executeQuery(db,context);
        return this.createRecordSet(rs);
    }
    
    /**
     * Override for search action (return data collection)
     * @param context 
     * @param model 
     * @returns KnDataTable
     */
    public override async getDataSearch(context: KnContextInfo, model: KnModel) : Promise<KnDataTable> {
        let rs = await this.doCollecting(context, model);
        return this.createDataTable(KnOperation.COLLECT, this.createRecordSet(rs), {}, "sftu003/sftu003_data");
    }

    /**
     * Override for retrieval action (return record not found error if not found any record)
     * @param context 
     * @param model 
     * @returns KnDataTable
     */
    public override async getDataRetrieval(context: KnContextInfo, model: KnModel) : Promise<KnDataTable> {
        let db = this.getPrivateConnector(model);
        try {
            let rs =  await this.performRetrieving(context, model, db);
            if(rs.rows.length>0) {
                let row = this.transformData(rs.rows[0]);
                let dt = await this.performCategories(context, model, db);
                return this.createDataTable(KnOperation.RETRIEVAL, row, dt.entity, "sftu003/sftu003_dialog");
            }
            return this.recordNotFound();
        } catch(ex: any) {
            this.logger.error(this.constructor.name,ex);
            return Promise.reject(this.getDBError(ex));
		} finally {
			try { if(db) db.close(); } catch(er) { console.error(er); }
        }
    }

    /**
     * Override for add new record action (prepare screen for add)
     * @param context 
     * @param model 
     * @returns KnDataTable
     */
    public override async getDataAdd(context: KnContextInfo, model: KnModel) : Promise<KnDataTable> {
        let dt = await this.doCategories(context, model);
        dt.action = KnOperation.ADD;
        dt.renderer = "sftu003/sftu003_dialog";
        return dt;
    }

    public async doRun(context: KnContextInfo, model: KnModel) : Promise<KnDataResult> {
        let apiname = context.params.apiname;
        let apiquery = context.params.apiquery;
        if(apiname && apiname.trim().length > 0 && apiquery && apiquery.trim().length > 0) {
            let apisection = context.params.apisection;
            let db;
            if(apisection) {
                db = this.getConnector(apisection);
                delete context.params.apisection;
            } else {
                db = this.getPrivateConnector(model);
            }
            try {    
                delete context.params.apiname;
                delete context.params.apiquery;
                let knsql = new KnSQL();
                knsql.append(apiquery);
                for(let p in context.params) {
                    knsql.set(p,context.params[p]);
                }
                let rs = await knsql.executeQuery(db,context);
                return {name: apiname, result: this.createRecordSet(rs) };
            } catch(ex: any) {
                this.logger.error(this.constructor.name,ex);
                return Promise.reject(this.getDBError(ex));
            } finally {
                try { if(db) db.close(); } catch(er) { console.error(er); }
            }
        }
        return {name: apiname, result: this.createRecordSet() };
    }
    
}
