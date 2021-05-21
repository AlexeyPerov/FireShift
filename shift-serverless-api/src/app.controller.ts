import {Controller, Get, Query} from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('messages/fetch?')
  getMessages(@Query('id') id : string) {
    return this.appService.getMessages(id);
  }
}
