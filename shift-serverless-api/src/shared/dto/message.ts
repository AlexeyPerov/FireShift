export class Message {
  public threadOwnerId: string;
  public authorId: string;
  public contents: string;

  public constructor(init?: Partial<Message>) {
    Object.assign(this, init);
  }
}
