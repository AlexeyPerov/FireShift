import 'dart:async';

import 'package:fireshift/shift/entities/support_thread.dart';

abstract class SupportRepository {
  Future initialize();

  Future<List<SupportThreadInfo>> fetchThreadsInfo(Filter filter, PageTarget pageTarget);
  Future<SupportThread> fetchThread(String id);
  Future<SupportThread> addThreadMessage(String id, String threadOwnerId, String response);
  Future<SupportThreadInfo> markRead(String id, bool read);
  Future<SupportThreadInfo> archive(String id, bool archive);
  Future<SupportThreadInfo> star(String id, bool star);
}