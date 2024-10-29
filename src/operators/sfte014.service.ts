import KnService from "@willsofts/will-db";
import { ServiceSchema } from "moleculer";
import { Sfte014Handler } from "../sfte014/Sfte014Handler";

const Sfte014Service : ServiceSchema = {
    name: "sfte014",
    mixins: [KnService],
    handler: new Sfte014Handler(), 
}
export = Sfte014Service;
