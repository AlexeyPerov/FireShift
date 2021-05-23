import { Injectable } from '@nestjs/common';
import {SupportMessage} from "./support-message.interface";

@Injectable()
export class MessagesService {
  private readonly messages: SupportMessage[] = [ new SupportMessage({authorId: "1", contents: "Hi!", time: Date.now() } ),
    new SupportMessage({authorId: "0", contents: "Whats up!", time: Date.now() } )  ];

  getUnreadMessagesCount(userId: String): number {
    return 0;
  }

  getMessages(userId: String): SupportMessage[] {
    return this.messages;
  }

  addMessage(message: SupportMessage): boolean {
    this.messages.push(message);
    return true;
  }
}