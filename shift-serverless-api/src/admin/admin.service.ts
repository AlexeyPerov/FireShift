import { Injectable } from '@nestjs/common';
import {PageTarget} from "../shared/models/page-target.model";
import {Filter} from "../shared/models/filter.model";
import {SupportThreadInfo} from "../shared/models/support-thread-info.model";
import {SupportThread} from "../shared/models/support-thread.model";

@Injectable()
export class AdminService {
    fetchThreadsInfo(filter: Filter, pageTarget: PageTarget): [SupportThreadInfo] {
        return null;
    }

    fetchThread(id: String): SupportThread {
        return null;
    }

    markRead(id: string, read: boolean) {

    }

    archive(id: string, archive: boolean) {

    }

    star(id: string, star: boolean) {

    }
}
