import {FilterToggle} from "./filter-toggle.model";
import {FilterText} from "./filter-text.model";

export class Filter {
    public contents: FilterText;
    public starred: FilterToggle;
    public unread: FilterToggle;
    public archived: FilterToggle;
}
