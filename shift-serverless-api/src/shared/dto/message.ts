export class Message {
  public authorId: string;
  public contents: string;

  public constructor(init?: Partial<Message>) {
    Object.assign(this, init);
  }
}
