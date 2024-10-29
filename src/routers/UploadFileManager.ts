import fs from 'fs';
import path from 'path';
import { Application, Request, Response } from 'express';
import { HTTP } from "@willsofts/will-api";
import { KnResponser } from "@willsofts/will-core";
import { TknAssureRouter } from '@willsofts/will-serv';
import { UploadImageRouter } from "./UploadImageRouter";
import { UploadDocImageRouter } from "./UploadDocImageRouter";

export class UploadFileManager extends TknAssureRouter {

	public route(app: Application, dir?: string) {
        if(dir) this.dir = dir;
        let imager = new UploadImageRouter(this.service, this.dir);
        //this is upload image for tinymce handler (need file as parameter name)
        let docimager = new UploadDocImageRouter(this.service, this.dir, undefined, "file");
        app.post("/upload/image", async (req: Request, res: Response) => { 
            let valid = await this.verifyToken(req,res); if(!valid) return; 
            imager.doUpload(req,res); 
        });
        app.post("/upload/docimage", async (req: Request, res: Response) => { 
            let valid = await this.verifyToken(req,res); if(!valid) return; 
            docimager.doUpload(req,res); 
        });
        app.post("/upload/:program/:subprog?", async (req: Request, res: Response) => { 
            let valid = await this.verifyToken(req,res); if(!valid) return; 
            this.doUpload(req,res); 
        });		
	}

    public async doUpload(req: Request, res: Response) {
        this.logger.debug(this.constructor.name+".doUpload: url",req.originalUrl);
        let ctx = await this.createContext(req, req.params.program);
        let program = ctx.params.program;
        let subprog = ctx.params.subprog;
        let info = this.getMetaInfo(ctx);
        let opername = program;
        if(subprog && subprog.trim().length>0) opername = subprog;
        let operpath = path.join(this.dir, program, opername+".js");
        let foundoper = fs.existsSync(operpath);
        if(!foundoper) {
            operpath = path.join(this.dir, program, opername+".ts");
            foundoper = fs.existsSync(operpath);
        }
        this.logger.debug(this.constructor.name+".doUpload: program="+program+", sub="+subprog+", operator="+operpath+", found="+foundoper);
        if(foundoper) {
            delete req.params.program;
            try {
                let action = "doUpload";
                if(ctx.params.action && ctx.params.action!="") action = ctx.params.action;
                let appname = path.join(this.dir, program, opername);
                this.logger.debug(this.constructor.name+".doUpload: appname="+appname+", action="+action);
                const Uploader = require(appname);
                let handler = new Uploader(this.service,this.dir);
                handler.logger = this.logger;
                await handler[action](req,res,ctx);
            } catch(ex) {
                this.logger.error(this.constructor.name+".doUpload: error",ex);
                if("true"==ctx.params.ajax) {
                    KnResponser.responseError(res,ex,"report",opername);
                    return;
                }
                res.render("pages/error",{error: ex, meta: info});
            }
        } else {
            res.status(HTTP.NOT_FOUND).send("Operator not found");
        }
    }

}
