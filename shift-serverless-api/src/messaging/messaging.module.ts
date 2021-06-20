import { Module } from '@nestjs/common';
import { MessagingController } from './messaging.controller';
import { MessagingService } from './messaging.service';
import {MongooseModule} from "@nestjs/mongoose";

@Module({
  imports: [
  ],
  controllers: [MessagingController],
  providers: [MessagingService],
  //exports: [MongooseModule],
})
export class MessagesModule {}
