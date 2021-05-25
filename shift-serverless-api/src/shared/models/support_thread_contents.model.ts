import {SupportMessage} from "./support-message.model";

export class SupportThreadContents {
    public id: string;
    public messages: SupportMessage[];

    public constructor(init?:Partial<SupportThreadContents>) {
        Object.assign(this, init);
    }
}
