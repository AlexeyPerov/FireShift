import {SupportThreadContents} from "./support_thread_contents.model";

export class SupportThread {
    public info: SupportThread;
    public contents: SupportThreadContents;

    public constructor(init?:Partial<SupportThread>) {
        Object.assign(this, init);
    }
}
