import { Injectable } from '@nestjs/common';
import {SupportMessage} from "./support-message.interface";

@Injectable()
export class AppService {
  private readonly messages: SupportMessage[] = [ new SupportMessage({authorId: "1", contents: "Hi!", time: Date.now() } ),
    new SupportMessage({authorId: "0", contents: "Whats up!", time: Date.now() } )  ];

  getMessages(userId: String): SupportMessage[] {
    return this.messages;
  }

  addMessage(message: SupportMessage) {
    this.messages.push(message);
  }
}

