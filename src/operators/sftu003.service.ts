import KnService from "@willsofts/will-db";
import { ServiceSchema } from "moleculer";
import { Sftu003Handler } from "../sftu003/Sftu003Handler";

const Sftu003Service : ServiceSchema = {
    name: "sftu003",
    mixins: [KnService],
    handler: new Sftu003Handler(), 
}
export = Sftu003Service;
