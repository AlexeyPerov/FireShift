import { Document, DocumentQuery, Model } from 'mongoose';

export interface SupportThreadInfo extends Document {
  _id: string;
  project: string;
  threadOwnerId: string;
  receiverId: string;
  starred: boolean;
  unread: boolean;
  archived: boolean;
  subject: string;
  updateTime: number;
  preview: string;
  contentsId: string;
}

export interface PaginateOptions {
  sort: string;
  page: number;
  limit: number;
}

export interface SupportThreadInfoModel extends Model<SupportThreadInfo> {
  paginate(
    query: any,
    options: PaginateOptions,
  ): DocumentQuery<SupportThreadInfosWithPagination, SupportThreadInfo>;
}

export interface SupportThreadInfosWithPagination {
  all: SupportThreadInfo[];
  total: number;
  limit: number;
  page: number;
  pages: number;
}
