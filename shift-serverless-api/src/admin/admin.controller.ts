import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { AdminService } from './admin.service';
import { Filter } from '../shared/models/filter.model';
import { PageTarget } from '../shared/models/page-target.model';
import { SupportThread } from '../shared/models/support-thread.model';

@Controller()
export class AdminController {
  constructor(private readonly service: AdminService) {}

  @Get('admin/fetch_threads_info?')
  fetchThreadsInfo(
    @Query('filter') filter: Filter,
    @Query('pageStart') pageStart: number,
    @Query('pageSize') pageSize: number,
  ) {
    console.log('filter: ' + filter);
    const pageTarget = new PageTarget({pageStart: pageStart, pageSize: pageSize});
    console.log('pageTarget: ' + pageTarget);
    return this.service.fetchThreadsInfo(filter, pageTarget);
  }

  @Get('admin/fetch_thread_info?')
  fetchThreadInfo(@Query('id') id: string) {
    return this.service.fetchThreadInfo(id);
  }

  @Get('admin/fetch_thread?')
  fetchThread(@Query('id') id: string) {
    return this.service.fetchThread(id);
  }

  @Post('admin/mark_read')
  markRead(@Body() body) {
    return this.service.markRead(body.id, body.read);
  }

  @Post('admin/archive')
  archive(@Body() body) {
    return this.service.archive(body.id, body.archive);
  }

  @Post('admin/star')
  star(@Body() body) {
    return this.service.star(body.id, body.star);
  }
}
