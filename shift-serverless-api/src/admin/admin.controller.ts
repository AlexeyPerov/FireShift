import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { AdminService } from './admin.service';
import { Filter } from '../shared/models/filter.model';
import { PageTarget } from '../shared/models/page-target.model';
import { FilterToggle } from '../shared/models/filter-toggle.model';
import { FilterText } from '../shared/models/filter-text.model';

@Controller()
export class AdminController {
  constructor(private readonly service: AdminService) {}

  @Get('admin/fetch_threads_info?')
  fetchThreadsInfo(
    @Query('search') search,
    @Query('starred') starred,
    @Query('unread') unread,
    @Query('archived') archived,
    @Query('pageStart') pageStart,
    @Query('pageSize') pageSize,
  ) {    
    const pageTarget = new PageTarget({pageStart: parseInt(pageStart), pageSize: parseInt(pageSize)});
    const filterText = search ? new FilterText({value: search}) : null;
    const filterStarred = starred ? new FilterToggle({activated: true, value: starred}) : null;
    const filterUnread = unread ? new FilterToggle({activated: true, value: unread}) : null;
    const filterArchived = archived ? new FilterToggle({activated: true, value: archived}) : null;
    const filter = new Filter({search: filterText, starred: filterStarred, unread: filterUnread, archived: filterArchived});
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
