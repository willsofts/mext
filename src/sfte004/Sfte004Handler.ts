import { v4 as uuid } from 'uuid';
import { KnModel, KnOperation } from "@willsofts/will-db";
import { KnDBConnector, KnSQLInterface, KnRecordSet, KnSQL, KnResultSet } from "@willsofts/will-sql";
import { HTTP } from "@willsofts/will-api";
import { KnValidateInfo, KnContextInfo, KnDataTable } from '@willsofts/will-core';
import { VerifyError } from '@willsofts/will-core';
import { KnPageUtility } from '@willsofts/will-core';
import { Utilities } from "@willsofts/will-util";
import { TknOperateHandler } from '@willsofts/will-serv';

export class Sfte004Handler extends TknOperateHandler {

    public progid = "sfte004";
    public model : KnModel = { 
        name: "trole", 
        alias: { privateAlias: this.section }, 
        fields: {                
            site: { type: "STRING", created: true },
            roleid: { type: "STRING", created: true, key: true },
            nameen: { type: "STRING", created: true },
            nameth: { type: "STRING", created: true },
            headroleid: { type: "STRING" },
            inactive: { type: "STRING", created: true, defaultValue: "0" },
            actionflag: { type: "STRING" },
            approveflag: { type: "STRING" },
            effectdate: { type: "DATE" },
            editdate: { type: "DATE", selected: false, created: true, updated: true },
            edittime: { type: "TIME", selected: false, created: true, updated: true },
            edituser: { type: "STRING", selected: false, created: true, updated: true },
        },
        //prefix naming with table name when select ex. table.column1,table.column2,...
        prefixNaming: true
    };

    /* try to assign individual parameters under this context */
    protected override async assignParameters(context: KnContextInfo, sql: KnSQLInterface, action?: string, mode?: string) {
        let now = Utilities.now();
        sql.set("editdate",now,"DATE");
        sql.set("edittime",now,"TIME");
        sql.set("edituser",this.userToken?.userid);
    }

    /* try to validate fields for insert, update, delete, retrieve */
    protected override validateRequireFields(context: KnContextInfo, model: KnModel, action: string) : Promise<KnValidateInfo> {
        let vi : KnValidateInfo = {valid: true};
        let page = new KnPageUtility(this.progid, context);
        if(page.isInsertMode(action)) {
            vi = this.validateParameters(context.params,"nameen","nameth");
        } else {
            vi = this.validateParameters(context.params,"roleid");
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
            let site = context.params.site || this.userToken?.site;
            knsql.append(filter).append("site = ?site");
            knsql.set("site",site);
            filter = " and ";
            if(params.nameen && params.nameen!="") {
                knsql.append(filter).append("nameen LIKE ?nameen");
                knsql.set("nameen","%"+params.nameen+"%");
                filter = " and ";
            }
            if(params.nameth && params.nameth!="") {
                knsql.append(filter).append("nameth LIKE ?nameth");
                knsql.set("nameth","%"+params.nameth+"%");
                filter = " and ";
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
			if(db) db.close();
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
			if(db) db.close();
        }
    }

    protected async performRetrieving(context: KnContextInfo, model: KnModel, db: KnDBConnector): Promise<KnRecordSet> {
        let knsql = new KnSQL();
        knsql.append("select * from trole ");
        knsql.append("where roleid = ?roleid ");
        knsql.set("roleid",context.params.roleid);
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
        return this.createDataTable(KnOperation.COLLECT, this.createRecordSet(rs), {}, "sfte004/sfte004_data");
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
                return this.createDataTable(KnOperation.RETRIEVAL, row, dt.entity, "sfte004/sfte004_dialog");
            }
            return this.recordNotFound();
        } catch(ex: any) {
            this.logger.error(this.constructor.name,ex);
            return Promise.reject(this.getDBError(ex));
		} finally {
			if(db) db.close();
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
        dt.renderer = "sfte004/sfte004_dialog";
        dt.dataset["roleid"] = uuid();
        return dt;
    }
    
    /* override doExecute to handle launch router when invoked from menu */
    protected override async doExecute(context: KnContextInfo, model: KnModel) : Promise<KnDataTable> {
        let dt = await this.doCategories(context, model);
        let ds = this.emptyDataSet();
        dt.action = KnOperation.EXECUTE;
        dt.dataset = ds;
        return dt;
    }

    protected override async doCreating(context: KnContextInfo, model: KnModel): Promise<KnResultSet> {
        let site = context.params.site;
        if(!site || site.trim().length ==0) {
            context.params.site = this.userToken?.site;
        }
        let roleid = context.params.roleid;
        if(!roleid || roleid.trim().length==0) {
            context.params.roleid = uuid();
        }
        return await super.doCreating(context,model);
    }
    
}
