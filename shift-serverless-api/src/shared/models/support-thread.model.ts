import { SupportThreadContents } from './support_thread_contents.model';
import { SupportThreadInfo } from './support-thread-info.model';

export class SupportThread {
  public info: SupportThreadInfo;
  public contents: SupportThreadContents;

  public constructor(init?: Partial<SupportThread>) {
    Object.assign(this, init);
  }
}
