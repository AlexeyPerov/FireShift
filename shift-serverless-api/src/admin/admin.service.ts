import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { PageTarget } from '../shared/models/page-target.model';
import { Filter } from '../shared/models/filter.model';
import {
  PaginateOptions,
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
  ) { }

  async fetchThreadsInfo(
    filter: Filter,
    pageTarget: PageTarget,
  ): Promise<SupportThreadInfo[]> {
    const ownerSearchQuery = filter.search?.value ? { threadOwnerId: new RegExp(filter.search.value, 'i') } : {};
    const projectSearchQuery = filter.search?.value ? { project: new RegExp(filter.search.value, 'i') } : {};
    const subjectSearchQuery = filter.search?.value ? { subject: new RegExp(filter.search.value, 'i') } : {};

    const archivedQuery = filter.archived?.activated ? {archived: filter.archived.value} : {};
    const starredQuery = filter.starred?.activated ? {starred: filter.starred.value} : {};
    const unreadQuery = filter.unread?.activated ? {unread: filter.unread.value} : {};
    
    const query = { ...ownerSearchQuery, ...projectSearchQuery, ...subjectSearchQuery, ...archivedQuery, ...starredQuery, ...unreadQuery };

    const page = pageTarget.pageStart / pageTarget.pageSize;
    const limit = pageTarget.pageSize;

    const options : PaginateOptions = {
      page: page,
      limit: limit,
      sort: 'updateTime'
    };

    const infosWithPagination = await this.infoModel.paginate(query, options);
    return infosWithPagination.all;    
  }

  async fetchThread(id: string): Promise<SupportThread> {
    const foundThreadInfo = await this.infoModel.findOne({
      threadOwnerId: id,
    });

    if (!foundThreadInfo) {
      throw new Error("Error finding thread");
    }

    const foundContents = await this.contentsModel.findOne({ _id: foundThreadInfo.contentsId });

    if (!foundContents) {
      throw new Error("Unable to find thread contents");
    }

    return new SupportThread({
      info: foundThreadInfo,
      contents: foundContents,
    });
  }

  async fetchThreadInfo(id: string): Promise<SupportThreadInfo> {
    const foundThreadInfo = await this.infoModel.findOne({
      threadOwnerId: id,
    });

    if (!foundThreadInfo) {
      throw new Error("Error finding thread");
    }

    return foundThreadInfo;
  }

  async markRead(id: string, read: boolean) {
    const foundThreadInfo = await this.infoModel.findOne({
      threadOwnerId: id,
    });

    if (!foundThreadInfo) {
      throw new Error("Error finding thread");
    }

    await this.infoModel.updateOne(
      {
        threadOwnerId: id
      },
      {
        unread: !read
      }
    );

    await this.contentsModel.updateOne(
      {
        _id: foundThreadInfo.contentsId,
        messages: {$elemMatch: {authorId: id}}
      },
      {
        $set: { 'messages.$[elem].read': true }
      },
      { "arrayFilters": [{ "elem.authorId": id }], "multi": true }
    );
  }

  async archive(id: string, archive: boolean) {
    await this.infoModel.updateOne(
      {
        threadOwnerId: id
      },
      {
        archived: archive
      }
    );
  }

  async star(id: string, star: boolean) {
    await this.infoModel.updateOne(
      {
        threadOwnerId: id
      },
      {
        starred: star
      }
    );
  }
}
