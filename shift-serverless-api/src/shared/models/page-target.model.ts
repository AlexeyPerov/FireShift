export class PageTarget {
  public pageStart: number;
  public pageSize: number;

  public constructor(init?: Partial<PageTarget>) {
    Object.assign(this, init);
  }
}
