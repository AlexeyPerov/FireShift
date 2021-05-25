import { Module } from '@nestjs/common';
import {AdminModule} from "./admin/admin.module";
import {MessagesModule} from "./messaging/messaging.module";

@Module({
    imports: [MessagesModule, AdminModule],
    controllers: [],
    providers: [],
})
export class AppModule {}
