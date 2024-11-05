import KnService from "@willsofts/will-db";
import { ServiceSchema } from "moleculer";
import { Sfte019Handler } from "../sfte019/Sfte019Handler";

const Sfte019Service : ServiceSchema = {
    name: "sfte019",
    mixins: [KnService],
    handler: new Sfte019Handler(), 
}
export = Sfte019Service;
