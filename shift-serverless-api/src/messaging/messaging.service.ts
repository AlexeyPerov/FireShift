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

  getUnreadMessagesCount(userId: string): number {
    return 0;
  }

  async getMessages(userId: string): Promise<SupportMessage[]> {
    const contents = await this.findThreadContents(userId);
    return contents.messages;
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
      await this.updateThread(threadOwnerId, messageAuthorId, contents);
    }

    return true;
  }

  private async createNewThread(threadOwnerId: string, messageAuthorId: string, contents: string) {
    const newThreadContents = {
      messages: [
        {
          authorId: messageAuthorId,
          contents: contents,
          time: Date.now()
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
      unread: false,
      subject: "Support Request",
      updateTime: Date.now(),
      preview: contents.length >= 24 ? contents.substr(0, 24) : contents,
      contentsId: contentsId
    };

    const addedInfo = await new this.infoModel(newThreadInfo);
    await addedInfo.save();
  }

  private async updateThread(threadOwnerId: string, messageAuthorId: string, contents: string) {
    await this.contentsModel.updateOne(
      {
        $push: {
          messages: [{
            authorId: messageAuthorId,
            contents: contents,
            time: Date.now()
          }]
        }
      },
    );

    await this.infoModel.updateOne(
      {
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
