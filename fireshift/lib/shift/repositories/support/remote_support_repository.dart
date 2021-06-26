import 'dart:convert';

import 'package:fireshift/shift/app/app.dart';
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
      String threadOwnerId, String response) async {
    await http.post(
      Uri.parse("http://localhost:3000/dev/messages/add"),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'threadOwnerId': threadOwnerId,
        'authorId': '0',
        'contents': response
      }),
    );

    return fetchThread(threadOwnerId);
  }

  @override
  Future<SupportThread> fetchThread(String id) async {
    final queryParameters = <String, dynamic>{'id': id};

    final uri =
        Uri.http("localhost:3000", "/dev/admin/fetch_thread", queryParameters);

    final response = await http
        .get(uri, headers: {'Content-Type': 'application/json; charset=UTF-8'});

    Map<String, dynamic> map = jsonDecode(response.body);
    return SupportThread.fromJson(map);
  }

  @override
  Future<List<SupportThreadInfo>> fetchThreadsInfo(
      Filter filter, PageTarget pageTarget) async {
    final queryParameters = <String, dynamic>{
      'pageStart': pageTarget.pageStart.toString(),
      'pageSize': pageTarget.pageSize.toString(),
    };

    if (filter.contents.value.isNotEmpty)
      queryParameters['search'] = filter.contents.value;

    if (filter.starred.activated)
      queryParameters['starred'] = filter.starred.value.toString();

    if (filter.unread.activated)
      queryParameters['unread'] = filter.unread.value.toString();

    if (filter.archived.activated)
      queryParameters['archived'] = filter.archived.value.toString();

    final uri = Uri.http(
        "localhost:3000", "/dev/admin/fetch_threads_info", queryParameters);

    final response = await http
        .get(uri, headers: {'Content-Type': 'application/json; charset=UTF-8'});

    logger.d('response: ' + response.body);

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
    final queryParameters = <String, dynamic>{'id': id};

    final uri = Uri.http(
        "localhost:3000", "/dev/admin/fetch_thread_info", queryParameters);

    final response = await http
        .get(uri, headers: {'Content-Type': 'application/json; charset=UTF-8'});

    Map<String, dynamic> map = jsonDecode(response.body);
    return SupportThreadInfo.fromJson(map);
  }
}
