import { Module } from '@nestjs/common';
import {AdminModule} from "./admin/admin.module";
import {MessagesModule} from "./messaging/messaging.module";
import {MongooseModule} from "@nestjs/mongoose";

@Module({
    imports: [
        MongooseModule.forRoot(process.env.MONGO_URI, {
            useNewUrlParser: true,
            useUnifiedTopology: true,
            bufferCommands: false,
            bufferMaxEntries: 0,
        }),
        MessagesModule, AdminModule],
    controllers: [],
    providers: [],
})
export class AppModule {}
