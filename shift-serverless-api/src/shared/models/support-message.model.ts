export class SupportMessage {
    public authorId: string;
    public contents: string;
    public time: number;

    public constructor(init?:Partial<SupportMessage>) {
        Object.assign(this, init);
    }
}



