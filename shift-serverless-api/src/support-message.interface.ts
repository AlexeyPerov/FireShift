export class SupportMessage {
    public readonly authorId: string;
    public readonly contents: string;
    public readonly time: number;

    public constructor(init?:Partial<SupportMessage>) {
        Object.assign(this, init);
    }
}