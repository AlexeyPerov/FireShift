import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { exception } from 'console';
import { SupportThreadInfoModel } from 'src/shared/models/support-thread-info.model';
import { SupportThreadContentsModel } from 'src/shared/models/support_thread_contents.model';
import { SupportMessage } from '../shared/models/support-message.model';

@Injectable()
export class MessagingService {
  constructor(
    @InjectModel('SupportThreadInfo') private infoModel: SupportThreadInfoModel,
    @InjectModel('SupportThreadContents')
    private contentsModel: SupportThreadContentsModel,
  ) {}

  getUnreadMessagesCount(userId: string): number {
    return 0;
  }

  getMessages(userId: string): SupportMessage[] {
    return [
      /*new SupportMessage({authorId: "1", contents: "Hi!", time: Date.now() } ),
      new SupportMessage({authorId: "0", contents: "Whats up!", time: Date.now() } )*/
    ];
  }

  async addMessage(threadOwnerId: string, messageAuthorId: string, contents: string): Promise<boolean> {
    var foundThreadInfo = await this.infoModel.findOne({
      threadOwnerId: threadOwnerId,
    });

    if (!foundThreadInfo) {     
      console.log("creating new thread for owner " + threadOwnerId);

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

      try {
        const addedContents = await new this.contentsModel(newThreadContents);
        await addedContents.save();          
        contentsId = addedContents._id;        
      } catch (e) {
        console.log(e);
        return false;
      }

      const newThreadInfo = {
        project: "AoC",
        threadOwnerId: threadOwnerId,
        receiverId: "0",
        starred: false,
        archived: false,
        unread: false,
        subject: "Support Request",
        updateTime: Date.now(),
        preview: "",
        contentsId: contentsId
      };

      try {
        const addedInfo = await new this.infoModel(newThreadInfo);
        await addedInfo.save();                  
      } catch (e) {
        console.log(e);
      }

      foundThreadInfo = await this.infoModel.findOne({
        threadOwnerId: threadOwnerId,
      });

      if (!foundThreadInfo) {
        throw new Error("Error creating new thread");
      }
    }

    // var message = new SupportMessage({authorId: userId, contents: contents, time: Date.now()})
    return true;
  }
}
