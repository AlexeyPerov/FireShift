import { Module } from '@nestjs/common';
import { MessagingController } from './messaging.controller';
import { MessagingService } from './messaging.service';

@Module({
  imports: [],
  controllers: [MessagingController],
  providers: [MessagingService],
})
export class MessagesModule {}
