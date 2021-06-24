export class FilterText {
  public value: string;

  public constructor(init?: Partial<FilterText>) {
    Object.assign(this, init);
  }
}
