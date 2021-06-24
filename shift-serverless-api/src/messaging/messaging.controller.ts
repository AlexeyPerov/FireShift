import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { MessagingService } from './messaging.service';
import { Message } from '../shared/dto/message';

@Controller()
export class MessagingController {
  constructor(private readonly service: MessagingService) {}

  @Get('messages/unread_count?')
  getUnreadCount(@Query('id') id: string) {
    return this.service.getUnreadMessagesCount(id);
  }

  // TODO fix naming
  @Get('messages/fetch?')
  getMessages(@Query('id') id: string) {
    return this.service.readMessages(id);
  }

  @Post('messages/add')
  addMessage(@Body() message: Message) {
    console.log(message);
    return this.service.addMessage(
      message.threadOwnerId,
      message.authorId,
      message.contents,
    );
  }
}
