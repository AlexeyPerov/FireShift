import { Injectable } from '@nestjs/common';
import {SupportMessage} from "../shared/models/support-message.model";

@Injectable()
export class MessagingService {
  getUnreadMessagesCount(userId: String): number {
    return 0;
  }

  getMessages(userId: String): SupportMessage[] {
    return [ new SupportMessage({authorId: "1", contents: "Hi!", time: Date.now() } ),
      new SupportMessage({authorId: "0", contents: "Whats up!", time: Date.now() } )  ];
  }

  addMessage(message: SupportMessage): boolean {
    return true;
  }
}
