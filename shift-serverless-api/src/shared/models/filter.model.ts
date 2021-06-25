import { FilterToggle } from './filter-toggle.model';
import { FilterText } from './filter-text.model';

export class Filter {
  public search: FilterText;
  public starred: FilterToggle;
  public unread: FilterToggle;
  public archived: FilterToggle;

  public constructor(init?: Partial<Filter>) {
    Object.assign(this, init);
  }
}
