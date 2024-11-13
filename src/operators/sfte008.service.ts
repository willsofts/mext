import KnService from "@willsofts/will-db";
import { ServiceSchema } from "moleculer";
import { Sfte008Handler } from "../sfte008/Sfte008Handler";

const Sfte008Service : ServiceSchema = {
    name: "sfte008",
    mixins: [KnService],
    handler: new Sfte008Handler(), 
}
export = Sfte008Service;
