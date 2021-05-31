import {Body, Controller, Get, Post, Query} from '@nestjs/common';
import {AdminService} from "./admin.service";
import {Filter} from "../shared/models/filter.model";
import {PageTarget} from "../shared/models/page-target.model";

@Controller()
export class AdminController {
    constructor(private readonly service: AdminService) {}

    @Get('admin/fetch_threads_info?')
    fetchThreadsInfo(
        @Query('filter') filter : Filter,
        @Query('pageTarget') pageTarget : PageTarget)  {
        console.log(filter);
        console.log(pageTarget);
        return this.service.fetchThreadsInfo(filter, pageTarget);
    }

    @Get('admin/fetch_thread_info?')
    fetchThreadInfo(@Query('id') id : string) {
        return this.service.fetchThreadInfo(id);
    }

    @Get('admin/fetch_thread?')
    getMessages(@Query('id') id : string) {
        return this.service.fetchThread(id);
    }

    @Post('admin/mark_read')
    markRead(@Body() id: string, read: boolean) {
        return this.service.markRead(id, read);
    }

    @Post('admin/archive')
    archive(@Body() id: string, archive: boolean) {
        return this.service.archive(id, archive);
    }

    @Post('admin/star')
    star(@Body() id: string, star: boolean) {
        return this.service.star(id, star);
    }
}
