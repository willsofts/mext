import os from "os";
import path from 'path';
import { Request, Response } from 'express';
import { JSONReply } from "@willsofts/will-api";
import { TknUploadRouter } from "@willsofts/will-core";
import { KnValidateInfo } from '@willsofts/will-core';
import { KnResponser } from "@willsofts/will-core";
import { Sfte014Handler } from "./Sfte014Handler";

export class Sfte014Uploader extends TknUploadRouter {

	public getUploadPath() : string {
		return path.join(os.tmpdir(),"uploaded","sfte014");;
	}

	protected override verifyFile(file: any, fileTypes: RegExp) : KnValidateInfo {
		this.logger.debug("fileFilter:",file);
		const filetypes = new RegExp("json|xls|xlsx|sheet|msexcel","i");
		const extname =  filetypes.test(path.extname(file.originalname).toLowerCase());
		const mimetype = filetypes.test(file.mimetype);
		this.logger.debug("verifyFile: extname",extname+", mimetype",mimetype);	  
		return {valid: extname && mimetype, info: "Invalid file type" };
	}

	protected override async doUploadFile(req: Request, res: Response) : Promise<void> {
		res.contentType('application/json');
		if(req.file) {
			req.file.originalname = Buffer.from(req.file.originalname, 'latin1').toString('utf8');
		}
		console.log(this.constructor.name+".doUploadFile: body",JSON.stringify(req.body));
		console.log(this.constructor.name+".doUploadFile: file",req.file);
		let response: JSONReply = new JSONReply();
		response.head.modeling("sfte014","upload");
		response.head.composeNoError();
		try {
            let ctx = await this.createContext(req);
			ctx.params.file = req.file;
			let handler = new Sfte014Handler();
			handler.obtain(this.service?.broker,this.logger);
			let rs = await handler.importData(ctx);
			response.body = rs;
			res.end(JSON.stringify(response));
		} catch(ex) {
			KnResponser.responseError(res,ex,"sfte014","upload");
		}
	}

}

/*
curl -X POST http://localhost:8080/upload/sfte014 -F filename=@D:\label\index.json -F labelid=index.json -F type=json
curl -X POST http://localhost:8080/upload/sfte014/uploader -F filename=@D:\label\index.json -F labelid=index.json -F type=json
*/
