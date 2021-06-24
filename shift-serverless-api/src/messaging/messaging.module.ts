import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { MessagingController } from './messaging.controller';
import { MessagingService } from './messaging.service';
import SupportThreadInfoSchema from '../shared/schemas/support_thread_info.schema';
import SupportThreadContentsSchema from '../shared/schemas/support_thread_contents.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: 'SupportThreadInfo', schema: SupportThreadInfoSchema },
      { name: 'SupportThreadContents', schema: SupportThreadContentsSchema },
    ]),
  ],
  controllers: [MessagingController],
  providers: [MessagingService],
  exports: [MongooseModule]
})
export class MessagesModule {}
