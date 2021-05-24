export class SupportThreadInfo {
    public id: string;
    public project: string;
    public senderId: string;
    public receiverId: string;
    public starred: string;
    public unread: string;
    public archived: string;
    public subject: string;
    public updateTime: number;
    public preview: string;
    public contentsId: string;

    public constructor(init?:Partial<SupportThreadInfo>) {
        Object.assign(this, init);
    }
}
