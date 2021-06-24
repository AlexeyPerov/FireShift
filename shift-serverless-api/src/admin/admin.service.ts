import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { PageTarget } from '../shared/models/page-target.model';
import { Filter } from '../shared/models/filter.model';
import {
  SupportThreadInfo,
  SupportThreadInfoModel,
} from '../shared/models/support-thread-info.model';
import { SupportThread } from '../shared/models/support-thread.model';
import {
  SupportThreadContents,
  SupportThreadContentsModel,
} from '../shared/models/support_thread_contents.model';

@Injectable()
export class AdminService {
  constructor(
    @InjectModel('SupportThreadInfo') private infoModel: SupportThreadInfoModel,
    @InjectModel('SupportThreadContents')
    private contentsModel: SupportThreadContentsModel,
  ) {}

  fetchThreadsInfo(
    filter: Filter,
    pageTarget: PageTarget,
  ): SupportThreadInfo[] {
    return [
      this.createMockSupportThreadInfo('0'),
      this.createMockSupportThreadInfo('1'),
      this.createMockSupportThreadInfo('2'),
      this.createMockSupportThreadInfo('3'),
      this.createMockSupportThreadInfo('4'),
    ];
  }

  fetchThread(id: string): SupportThread {
    return new SupportThread({
      info: this.createMockSupportThreadInfo('1'),
      contents: this.createMockSupportThreadsContents('1'),
    });
  }

  fetchThreadInfo(id: string): SupportThreadInfo {
    return this.createMockSupportThreadInfo(id);
  }

  markRead(id: string, read: boolean) {
    return true;
  }

  archive(id: string, archive: boolean) {
    return true;
  }

  star(id: string, star: boolean) {
    return true;
  }

  private createMockSupportThreadInfo(id: string): SupportThreadInfo {
    return null; /*new SupportThreadInfo({
            id: id.toString(),
            project: "AoC",
            senderId: "0",
            receiverId: "Support",
            subject: `User ${id}`,
            preview: `Excepteur sint occaecat cupidatat ${id} non proident`,
            updateTime: Date.now(),
            archived: Math.random() > 0.5,
            starred: Math.random() > 0.5,
            unread: Math.random() > 0.5,
            contentsId: "contents_" + id
        });*/
  }

  private createMockSupportThreadsContents(id: string): SupportThreadContents {
    return null; /* new SupportThreadContents({
            id: "contents_" + id, messages: [
                new SupportMessage({authorId: "0", contents: "hello", time: Date.now()}),
                new SupportMessage({
                    authorId: "1",
                    contents: 'Excepteur sint occaecat cupidatat $id non proident.\n' +
                        'sunt in culpa qui officia deserunt mollit anim id est laborum' +
                        'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                    time: Date.now()
                }),
                new SupportMessage({authorId: "0", contents: "thanks", time: Date.now()})
            ]
        });*/
  }
}
