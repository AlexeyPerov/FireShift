import { Module } from '@nestjs/common';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';
import { MongooseModule } from '@nestjs/mongoose';
import SupportThreadInfoSchema from '../shared/schemas/support_thread_info.schema';
import SupportThreadContentsSchema from '../shared/schemas/support_thread_contents.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: 'SupportThreadInfo', schema: SupportThreadInfoSchema },
      { name: 'SupportThreadContents', schema: SupportThreadContentsSchema },
    ]),
  ],
  controllers: [AdminController],
  providers: [AdminService],
  exports: [MongooseModule]
})
export class AdminModule {}
