import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { SupportThreadInfoModel } from 'src/shared/models/support-thread-info.model';
import { SupportThreadContents, SupportThreadContentsModel } from 'src/shared/models/support_thread_contents.model';
import { SupportMessage } from '../shared/models/support-message.model';

@Injectable()
export class MessagingService {
  constructor(
    @InjectModel('SupportThreadInfo') private infoModel: SupportThreadInfoModel,
    @InjectModel('SupportThreadContents')
    private contentsModel: SupportThreadContentsModel,
  ) { }

  async getUnreadMessagesCount(userId: string): Promise<number> {
    const contents = await this.findThreadContents(userId);
    const count = contents.messages.filter((obj) => obj.read === false && obj.authorId === "0").length;
    return count;
  }

  async readMessages(userId: string): Promise<SupportMessage[]> {
    const foundThreadInfo = await this.infoModel.findOne({
      threadOwnerId: userId,
    });

    if (!foundThreadInfo) {
      throw new Error("Error finding thread");
    }

    const foundContents = await this.contentsModel.findOne({ _id: foundThreadInfo.contentsId });

    if (!foundContents) {
      throw new Error("Unable to find thread contents");
    }

    await this.contentsModel.updateOne(
      {
        _id: foundThreadInfo.contentsId,
        messages: {$elemMatch: {authorId: "0"}}
      },
      {
        $set: { 'messages.$[elem].read': true }
      },
      { "arrayFilters": [{ "elem.authorId": "0" }], "multi": true }
    );

    return foundContents.messages;
  }

  async addMessage(threadOwnerId: string, messageAuthorId: string, contents: string): Promise<boolean> {
    var foundThreadInfo = await this.infoModel.findOne({
      threadOwnerId: threadOwnerId,
    });

    if (!foundThreadInfo) {
      console.log("creating new thread for owner " + threadOwnerId);
      this.createNewThread(threadOwnerId, messageAuthorId, contents);
    } else {
      console.log("existing thread has been found");
      await this.updateThread(foundThreadInfo.contentsId, threadOwnerId, messageAuthorId, contents);
    }

    return true;
  }

  private async createNewThread(threadOwnerId: string, messageAuthorId: string, contents: string) {
    const newThreadContents = {
      messages: [
        {
          authorId: messageAuthorId,
          contents: contents,
          time: Date.now(),
          read: false
        }
      ]
    };

    var contentsId = "";

    const addedContents = await new this.contentsModel(newThreadContents);
    await addedContents.save();
    contentsId = addedContents._id;

    const newThreadInfo = {
      project: "AoC",
      threadOwnerId: threadOwnerId,
      receiverId: "0",
      starred: false,
      archived: false,
      subject: "Support Request",
      updateTime: Date.now(),
      preview: contents.length >= 24 ? contents.substr(0, 24) : contents,
      contentsId: contentsId
    };

    const addedInfo = await new this.infoModel(newThreadInfo);
    await addedInfo.save();
  }

  private async updateThread(contentsId: string, threadOwnerId: string, messageAuthorId: string, contents: string) {
    await this.contentsModel.updateOne(
      {
        _id: contentsId
      },
      {
        $push: {
          messages: [{
            authorId: messageAuthorId,
            contents: contents,
            time: Date.now(),
            read: false
          }]
        }
      },
    );

    await this.infoModel.updateOne(
      {
        threadOwnerId: threadOwnerId
      },
      {
        unread: true,
        preview: contents.length >= 24 ? contents.substr(0, 24) : contents,
        updateTime: Date.now()
      }
    );
  }

  private async findThreadContents(userId: string): Promise<SupportThreadContents> {
    const foundThreadInfo = await this.infoModel.findOne({
      threadOwnerId: userId,
    });

    if (!foundThreadInfo) {
      throw new Error("Error finding thread");
    }

    const foundContents = await this.contentsModel.findOne({ _id: foundThreadInfo.contentsId });

    if (!foundContents) {
      throw new Error("Unable to find thread contents");
    }

    return foundContents;
  }
}
