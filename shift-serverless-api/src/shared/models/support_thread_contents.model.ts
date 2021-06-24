import { Model } from 'mongoose';
import { SupportMessage } from './support-message.model';

export interface SupportThreadContents extends Document {
  messages: SupportMessage[];
}

export interface SupportThreadContentsModel
  extends Model<SupportThreadContents> {
    
  }