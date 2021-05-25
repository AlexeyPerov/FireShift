import {Body, Controller, Get, Post, Query} from '@nestjs/common';
import { MessagingService } from './messaging.service';

@Controller()
export class MessagingController {
  constructor(private readonly service: MessagingService) {}

  @Get('messages/unread_count?')
  getUnreadCount(@Query('id') id : string) {
    return this.service.getUnreadMessagesCount(id);
  }

  @Get('messages/fetch?')
  getMessages(@Query('id') id : string) {
    return this.service.getMessages(id);
  }

  @Post('messages/add')
  addMessage(@Body() id: string, contents: string){
    console.log(`${id}: ${contents}`);
    return this.service.addMessage(id, contents);
  }
}
