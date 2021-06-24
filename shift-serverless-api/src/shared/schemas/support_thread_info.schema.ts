import { Schema } from 'mongoose';
import * as paginate from '../../shared/utils/paginate';

const SupportThreadInfoSchema = new Schema({
  project: String,
  threadOwnerId: String,
  receiverId: String,
  starred: Boolean,
  unread: Boolean,
  archived: Boolean,
  subject: String,
  updateTime: Number,
  preview: String,
  contentsId: String,
});

SupportThreadInfoSchema.plugin(paginate.pagination);

export default SupportThreadInfoSchema;
