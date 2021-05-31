import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fireshift/shift/entities/support_thread.dart';
import 'package:fireshift/shift/repositories/support/support_repository.dart';

class RemoteSupportRepository extends SupportRepository {
  @override
  Future initialize() {
    return Future<void>(() {});
  }

  @override
  Future<SupportThread> addThreadMessage(
      String id, String senderId, String response) async {
    var message = SupportMessage(
        authorId: senderId, contents: response, time: DateTime.now());
    var messageString = json.encode(message.toJson());
    await http.post(
      Uri.parse("http://localhost:3000/dev/messages/add"),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'message': messageString}),
    );

    return fetchThread(id);
  }

  @override
  Future<SupportThread> fetchThread(String id) async {
    final response = await http.post(
      Uri.parse("http://localhost:3000/dev/admin/fetch_thread"),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'id': id}),
    );

    Map<String, dynamic> map = jsonDecode(response.body);
    return SupportThread.fromJson(map);
  }

  @override
  Future<List<SupportThreadInfo>> fetchThreadsInfo(
      Filter filter, PageTarget pageTarget) async {
    final response = await http.post(
      Uri.parse("http://localhost:3000/dev/admin/fetch_threads_info"),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(
          {'filter': filter.toJson(), 'pageTarget': pageTarget.toJson()}),
    );

    Iterable l = json.decode(response.body);
    List<SupportThreadInfo> infos = List<SupportThreadInfo>.from(
        l.map((model) => SupportThreadInfo.fromJson(model)));

    return Future.value(infos);
  }

  @override
  Future<SupportThreadInfo> archive(String id, bool archive) async {
    await http.post(Uri.parse("http://localhost:3000/dev/admin/archive"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'id': id, 'archive': archive.toString()}));

    return _fetchThreadInfo(id);
  }

  @override
  Future<SupportThreadInfo> markRead(String id, bool read) async {
    await http.post(Uri.parse("http://localhost:3000/dev/admin/mark_read"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'id': id, 'read': read.toString()}));

    return _fetchThreadInfo(id);
  }

  @override
  Future<SupportThreadInfo> star(String id, bool star) async {
    await http.post(Uri.parse("http://localhost:3000/dev/admin/star"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'id': id, 'star': star.toString()}));

    return _fetchThreadInfo(id);
  }

  Future<SupportThreadInfo> _fetchThreadInfo(String id) async {
    final response = await http.post(
      Uri.parse("http://localhost:3000/dev/admin/fetch_thread_info"),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{'id': id}),
    );

    Map<String, dynamic> map = jsonDecode(response.body);
    return SupportThreadInfo.fromJson(map);
  }
}
