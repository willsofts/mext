import { KnTrackingInfo, KnOperationInfo, KnModel } from "@willsofts/will-db";
import { HTTP } from "@willsofts/will-api";
import { KnContextInfo, KnFunctionalInfo } from '../models/KnCoreAlias';
import { TknBaseHandler } from "./TknBaseHandler";
import { KnUtility } from "../utils/KnUtility";
import { ALWAYS_DB_TRACKING } from "../utils/EnvironmentVariable";
import { VerifyError } from "../models/VerifyError";

export class TknSystemHandler extends TknBaseHandler {
    
    protected override async exposeOperation(context: any, model: KnModel, operation: KnOperationInfo) : Promise<void> {
		await this.exposeContext(context);
    }

    public async callFunctional(context: KnContextInfo, info: KnFunctionalInfo, functional: Function) : Promise<any> {
        if(this.model && this.isValidModelConfig("privateAlias",this.model)) {
			await this.exposeFunctional(context, this.model, {operate: info.operate});
            if(info.raw) {
                context.meta.$responseRaw = true; 
                context.meta.$responseType = "text/html";    
            }
            return functional.call(this, context, this.model);
        }
        return Promise.reject(new VerifyError("Invalid setting",HTTP.NOT_ACCEPTABLE,-16006));
    }

    public override track(context: KnContextInfo, info: KnTrackingInfo): Promise<void> {
        if(ALWAYS_DB_TRACKING) {
            info.info = KnUtility.scrapeTraceInfo(context);
            if(!info.tracker) info.tracker = context.meta.pid;
            this.call("logging.insert",{...context.params, info: info},{meta: context.meta}).catch(ex => this.logger.error(this.constructor.name,ex));
            /*
            let tracking = new TknTrackingHandler();
            tracking.trackInfo = info;   
            tracking.insert(context).catch(ex => this.logger.error(this.constructor.name,ex));
            */
        }
        return Promise.resolve();
    }

}
