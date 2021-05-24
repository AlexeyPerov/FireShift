export class FilterToggle {
    public value: boolean;
    public activated: boolean;

    public constructor(init?:Partial<FilterToggle>) {
        Object.assign(this, init);
    }
}
