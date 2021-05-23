import {Body, Controller, Get, Post, Query} from '@nestjs/common';
import { MessagesService } from './messages.service';
import {SupportMessage} from "./support-message.interface";

@Controller()
export class MessagesController {
  constructor(private readonly appService: MessagesService) {}

  @Get('messages/unread_count?')
  getUnreadCount(@Query('id') id : string) {
    return this.appService.getUnreadMessagesCount(id);
  }

  @Get('messages/fetch?')
  getMessages(@Query('id') id : string) {
    return this.appService.getMessages(id);
  }

  @Post('messages/add')
  addMessage(@Body() message: SupportMessage){
    console.log(message);
    return this.appService.addMessage(message);
  }
}
