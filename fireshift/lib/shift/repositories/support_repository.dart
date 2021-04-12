import 'dart:async';

import 'package:fireshift/shift/redux/entities/support_thread.dart';

abstract class SupportRepository {
  Future initialize();

  Future<List<SupportThreadInfo>> fetchThreadsInfo(Filter filter);

  Future<SupportThreadContents> fetchThreadContents(String ticketId);

  Future<SupportThread> addThreadMessage(String id, String senderId, String response);

  Future<SupportThreadInfo> markRead(String id, bool read);
  Future<SupportThreadInfo> archive(String id, bool archive);
  Future<SupportThreadInfo> star(String id, bool star);
}