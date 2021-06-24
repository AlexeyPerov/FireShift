import * as mongoose from 'mongoose';
const { Schema } = mongoose;

const SupportThreadContentsSchema = new Schema({
  messages: [],
});

export default SupportThreadContentsSchema;
