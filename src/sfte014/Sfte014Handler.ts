import fs from 'fs';
import path from 'path';
import { KnModel, KnOperation } from "@willsofts/will-db";
import { KnDBConnector, KnSQLInterface, KnRecordSet, KnSQL, KnResultSet } from "@willsofts/will-sql";
import { HTTP } from "@willsofts/will-api";
import { TknOperateHandler } from '@willsofts/will-serv';
import { KnValidateInfo, KnContextInfo, KnDataTable, KnDataEntity, KnDataSet } from '@willsofts/will-core';
import { VerifyError } from "@willsofts/will-core";
import { OPERATE_HANDLERS } from "@willsofts/will-serv";
import { Request, Response } from 'express';
import { TknLabelHandler } from '@willsofts/will-core';
import ExcelJS from "exceljs";

export class Sfte014Handler extends TknOperateHandler {

    public progid = "sfte014";
    public model : KnModel = { 
        name: "tlabel", 
        alias: { privateAlias: this.section }, 
        fields: {
            labelid: { type: "STRING", key: true },
            langcode: { type: "STRING", key: true },
            labelname: { type: "STRING", key: true },
            labelvalue: { type: "STRING" },
            langname: { type: "STRING", calculated: true },
        },
    };
    public handlers = OPERATE_HANDLERS.concat({name: "categorylist"});

    public async categorylist(context: KnContextInfo) : Promise<any> {
        return this.callFunctional(context, {operate: KnOperation.GET, raw: false}, this.doCategoryList);
    }

    private default_proglists = [
        {programid: "index", progname: "Main Page", prognameth: "Main Page"},
        {programid: "default_label", progname: "Default Label", prognameth: "Default Label"},
    ];

    protected async doCategoryList(context: KnContextInfo, model: KnModel) : Promise<any> {
        let settings = this.getCategorySetting(context, "tklanguage", "tprog");
        let db = this.getPrivateConnector(model);
        try {
            let result = await this.getDataLists(context, db, settings);
            let entity = result.entity as Array<any>;
            let tprog = entity.find((item:any) => item.category=="tprog");
            if(tprog) {
                let rows = tprog.resultset?.rows;
                if(rows) {
                    let datarows : Array<any> = [];
                    this.default_proglists.forEach((item:any) => datarows.push({...item}));
                    rows = datarows.concat(rows);
                    tprog.resultset.rows = rows.map((item:any) => { item.programid = item.programid+".xml"; return item; });
                }
            }
            return result;
        } catch(ex: any) {
            this.logger.error(this.constructor.name,ex);
            return Promise.reject(this.getDBError(ex));
		} finally {
			if(db) db.close();
        }
    }

    /* try to validate fields for insert, update, delete, retrieve */
    protected override validateRequireFields(context: KnContextInfo, model: KnModel, action: string) : Promise<KnValidateInfo> {
        let vi = this.validateParameters(context.params,"labelid","langcode","labelname");
        if(!vi.valid) {
            return Promise.reject(new VerifyError("Parameter not found ("+vi.info+")",HTTP.NOT_ACCEPTABLE,-16061));
        }
        return Promise.resolve(vi);
    }

    protected override buildFilterQuery(context: KnContextInfo, model: KnModel, knsql: KnSQLInterface, selector: string, action?: string, subaction?: string): KnSQLInterface {
        if(this.isCollectMode(action)) {
            let params = context.params;
            let counting = KnOperation.COUNT==subaction;
            knsql.append(selector);
            if(!counting) {
                knsql.append(", tconstant.nameen as langname ");
            }
            knsql.append(" from ");
            knsql.append(model.name);
            if(!counting) {
                knsql.append(" left join tconstant on tconstant.typename = 'tlanguage' and tconstant.typeid = tlabel.langcode "); 
            }
            let filter = " where ";
            let labelid = params.labelid;
            if(labelid && labelid!="") {
                knsql.append(filter).append(model.name).append(".labelid = ?labelid");
                knsql.set("labelid",labelid);
                filter = " and ";
            }
            return knsql;    
        }
        return super.buildFilterQuery(context, model, knsql, selector, action, subaction);
    }

    /* override to handle launch router when invoked from menu */
    protected override async doRetrieving(context: KnContextInfo, model: KnModel, action: string = KnOperation.RETRIEVE): Promise<KnDataTable> {
        let db = this.getPrivateConnector(model);
        try {
            let rs = await this.performRetrieving(context, model, db);
            if(rs.rows.length>0) {
                let row = this.transformData(rs.rows[0]);
                let result = {action: KnOperation.RETRIEVE, entity: {}, dataset: row};
                return result;
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
        let labelid = context.params.labelid;
        let knsql = new KnSQL();
        knsql.append("select tlabel.*, tconstant.nameen as langname ");
        knsql.append("from tlabel ");
        knsql.append("left join tconstant on tconstant.typename = 'tlanguage' and tconstant.typeid = tlabel.langcode "); 
        knsql.append("where labelid = ?labelid and langcode = ?langcode and labelname = ?labelname ");
        knsql.set("labelid",labelid);
        knsql.set("langcode",context.params.langcode);
        knsql.set("labelname",context.params.labelname);
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
        return {action: "collect", entity: {}, dataset: this.createRecordSet(rs), renderer: "sfte014/sfte014_data"};
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
                return this.createDataTable(KnOperation.RETRIEVAL, row, dt.entity, "sfte014/sfte014_dialog");
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
        dt.renderer = "sfte014/sfte014_dialog";
        return dt;
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
        let settings = this.getCategorySetting(context, "tklanguage", "tprog");
        let result =  await this.getDataCategories(context, db, settings);        
        let entity = result.entity as KnDataEntity;
        let progs : KnDataSet = {};
        this.default_proglists.forEach((item:any) => { progs[item.programid] = item.progname; }); 
        let items = Object.assign(progs,entity.tprog);
        let tprogs : KnDataSet = {};
        for(let key in items) {
            tprogs[key+".xml"] = items[key];
        }
        entity.tprog = tprogs;
        return result;
    }

    /* override to handle launch router when invoked from menu */
    protected override async doExecute(context: KnContextInfo, model: KnModel) : Promise<KnDataTable> {
        let db = this.getPrivateConnector(model);
        try {
            let dt = await this.performCategories(context, model, db);
            dt.renderer = "sfte014/sfte014";
            return dt;
        } catch(ex: any) {
            this.logger.error(this.constructor.name,ex);
            return Promise.reject(this.getDBError(ex));
		} finally {
			if(db) db.close();
        }
    }

    public async importData(context: KnContextInfo) : Promise<KnRecordSet> {
        return this.callFunctional(context, {operate: KnOperation.GET, raw: false}, this.doImport);
    }

    protected async doImport(context: KnContextInfo, model: KnModel): Promise<KnRecordSet> {
        let file = context.params.file;
        let filename = path.extname(file.originalname).toLowerCase();
        const jsonfiletype = new RegExp("json","i");
        const excelfiletype = new RegExp("xls|xlsx","i");
        const isJson = jsonfiletype.test(filename);
        const isExcel = excelfiletype.test(filename);
        let existing = fs.existsSync(file.path);
        this.logger.debug(this.constructor.name+".doImport: existing="+existing,"json",isJson,"excel",isExcel);
        if(existing && (isJson || isExcel)) {
            let db = this.getPrivateConnector(model);
            try {
                let result = this.createRecordSet();
                await db.beginWork();
                if(isJson) {
                    result = await this.performImportJson(context, db);
                } else if(isExcel) {
                    result = await this.performImportExcel(context, db);
                } 
                await db.commitWork();
                return result;
            } catch(ex: any) {
                this.logger.error(this.constructor.name,ex);
                try { await db.rollbackWork(); } catch(er) { this.logger.error(er); }
                return Promise.reject(this.getDBError(ex));
            } finally {
                if(db) db.close();
            }
        }        
        return this.createRecordSet();
    }

    protected performDeleteLabel(context: KnContextInfo, db: KnDBConnector, labelid: string) : Promise<KnResultSet> {
        let knsql = new KnSQL();
        knsql.append("delete from tlabel where labelid = ?labelid ");
        knsql.set("labelid",labelid);
        return knsql.executeUpdate(db,context);
    }

    protected async performImportJson(context: KnContextInfo, db: KnDBConnector): Promise<KnRecordSet> {
        this.logger.debug(this.constructor.name+".performImportJson: params",context.params);
        let result = this.createRecordSet();
        let labelid = context.params.labelid;
        let file = context.params.file;
        let buffer = fs.readFileSync(file.path, "utf8");
        let jsonAry = JSON.parse(buffer);
        if(jsonAry) {
            await this.performDeleteLabel(context,db,labelid);
            let knsql = new KnSQL();
            knsql.append("insert into tlabel(labelid,langcode,labelname,labelvalue) values(?labelid,?langcode,?labelname,?labelvalue)");
            for(let data of jsonAry) {
                for(let item of data.label) {
                    knsql.set("labelid",labelid);
                    knsql.set("langcode",data.language);
                    knsql.set("labelname",item.name);
                    knsql.set("labelvalue",item.value);
                    let rs = await knsql.executeUpdate(db,context);
                    let rss = this.createRecordSet(rs);
                    if(rss) {
                        result.records += rss.records;
                    }
                }
            }
        }
        return result;
    }

    protected async performImportExcel(context: KnContextInfo, db: KnDBConnector): Promise<KnRecordSet> {
        this.logger.debug(this.constructor.name+".performImportExcel: params",context.params);
        let result = this.createRecordSet();
        let labelid = context.params.labelid;
        let file = context.params.file;
        let filename = file.path;
        const workbook = new ExcelJS.Workbook();
        let wb = await workbook.xlsx.readFile(filename);
        const worksheet = wb.getWorksheet(1);
        if(worksheet && worksheet.rowCount > 0) {
            await this.performDeleteLabel(context,db,labelid);
            let knsql = new KnSQL();
            knsql.append("insert into tlabel(labelid,langcode,labelname,labelvalue) values(?labelid,?langcode,?labelname,?labelvalue)");
            worksheet.eachRow({ includeEmpty: true }, async (row: ExcelJS.Row, rowNumber: number) => {
                //skip header 1 row
                if(rowNumber>=2) {
                    let langcode = row.getCell(2).value as string;
                    let labelname = row.getCell(3).value as string;
                    let labelvalue = row.getCell(4).value as string;
                    knsql.set("labelid",labelid);
                    knsql.set("langcode",langcode);
                    knsql.set("labelname",labelname);
                    knsql.set("labelvalue",labelvalue);
                    let rs = await knsql.executeUpdate(db,context);
                    let rss = this.createRecordSet(rs);
                    if(rss) {
                        result.records += rss.records;
                    }
                }
            });
        }
        return result;
    }

    public override async report(context: KnContextInfo, req: Request, res: Response) : Promise<void> {
        this.logger.debug(this.constructor.name+".report: params",context.params);
        let type = context.params.type;
        let labelid = context.params.labelid;
        let filename = path.parse(labelid).name;
        let label = new TknLabelHandler();
        label.obtain(this.broker,this.logger);
        context.params = {queryPaging: false, labelid: context.params.labelid};
        if(type=="excel") {
            let rs = await label.collect(context);
            if(rs) {
                let buffer = await this.generateExcel(filename,rs);
                if(buffer) {
                    res.attachment(filename+".xlsx");
                    res.send(buffer);
                    return;
                }
            }
        } else {
            let rs = await label.find(context);
            if(rs) {
                res.attachment(filename+".json");
                res.json(rs);
                return;
            }
        }
        res.status(HTTP.NOT_FOUND).send("Not found");
    }

    protected async generateExcel(name: string, rs: KnResultSet) : Promise<ExcelJS.Buffer | undefined> {
        let data = rs?.rows;
        if(data) {
            const workbook = new ExcelJS.Workbook();
            const worksheet = workbook.addWorksheet(name, {
                pageSetup: { paperSize: ExcelJS.PaperSize.A4, orientation: "landscape" },
            });    
            let rowIndex = 1;        
            let row = worksheet.getRow(rowIndex);
            row.values = ["Program", "Language", "Label Name", "Value"];        
            const columnWidths = [20, 10, 30, 80];            
            row.eachCell((cell: ExcelJS.Cell, colNumber: number) => {
                const columnIndex = colNumber - 1;
                const columnWidth = columnWidths[columnIndex];
                worksheet.getColumn(colNumber).width = columnWidth;
            });        
            data.forEach((data: any, index: number) => {
                const row = worksheet.getRow(rowIndex + index + 1);
                row.getCell("A").value = data.labelid;
                row.getCell("B").value = data.langcode;
                row.getCell("C").value = data.labelname;
                row.getCell("D").value = data.labelvalue;
                row.getCell("B").alignment = { horizontal: "center" };
            });
            return workbook.xlsx.writeBuffer(); 
            //workbook.xlsx.writeFile("./excel/label_data.xlsx");                      
        }
        return Promise.resolve(undefined);
    }

}
