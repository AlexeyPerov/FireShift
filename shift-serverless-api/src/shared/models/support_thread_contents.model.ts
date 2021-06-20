import {SupportMessage} from "./support-message.model";

export interface SupportThreadContents {
    _id: string;
    messages: SupportMessage[];
}

export interface SupportThreadContentsModel extends SupportThreadContents, Document {
}
