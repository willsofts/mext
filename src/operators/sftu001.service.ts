import KnService from "@willsofts/will-db";
import { ServiceSchema } from "moleculer";
import { Sftu001Handler } from "../sftu001/Sftu001Handler";

const Sftu001Service : ServiceSchema = {
    name: "sftu001",
    mixins: [KnService],
    handler: new Sftu001Handler(), 
}
export = Sftu001Service;
