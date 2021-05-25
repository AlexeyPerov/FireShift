import { Injectable } from '@nestjs/common';
import {SupportMessage} from "../shared/models/support-message.model";

@Injectable()
export class MessagingService {
  getUnreadMessagesCount(userId: string): number {
    return 0;
  }

  getMessages(userId: string): SupportMessage[] {
    return [ new SupportMessage({authorId: "1", contents: "Hi!", time: Date.now() } ),
      new SupportMessage({authorId: "0", contents: "Whats up!", time: Date.now() } )  ];
  }

  addMessage(userId: string, contents: string): boolean {
    // var message = new SupportMessage({authorId: userId, contents: contents, time: Date.now()})
    return true;
  }
}
