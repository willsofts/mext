import KnService from "@willsofts/will-db";
import { ServiceSchema } from "moleculer";
import { Sfte004Handler } from "../sfte004/Sfte004Handler";

const Sfte004Service : ServiceSchema = {
    name: "sfte004",
    mixins: [KnService],
    handler: new Sfte004Handler(), 
}
export = Sfte004Service;
