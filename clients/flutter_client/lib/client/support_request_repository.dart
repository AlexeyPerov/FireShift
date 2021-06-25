import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class SupportRequestRepository {
  String getCurrentUserId();
  setUserId(String id);

  Future<List<SupportMessage>> fetchMessages();
  Future addMessage(SupportMessage message);
  Future<int> getUnreadCount();
}

class MockSupportRequestRepository extends SupportRequestRepository {
  List<SupportMessage> messages = List.empty(growable: true);
  String _currentId;

  @override
  setUserId(String id) {
    _currentId = id;
    messages.clear();

    messages.add(SupportMessage(
        authorId: "0", contents: "Hello " + _currentId, time: DateTime.now()));
    messages.add(
        SupportMessage(authorId: "0", contents: "Test", time: DateTime.now()));
  }

  @override
  String getCurrentUserId() {
    return _currentId;
  }

  @override
  Future<List<SupportMessage>> fetchMessages() async {
    await Future.delayed(new Duration(milliseconds: 500));
    return Future.value(messages.toList());
  }

  @override
  Future addMessage(SupportMessage message) async {
    await Future.delayed(new Duration(milliseconds: 500));
    messages.add(message);
  }

  @override
  Future<int> getUnreadCount() async {
    await Future.delayed(new Duration(milliseconds: 2000));
    return 42;
  }
}

class RemoteSupportRequestRepository extends SupportRequestRepository {
  String _currentId;

  @override
  setUserId(String id) {
    _currentId = id;
  }

  @override
  String getCurrentUserId() {
    return _currentId;
  }

  @override
  Future<List<SupportMessage>> fetchMessages() async {
    final response = await http.get(
        Uri.parse('http://localhost:3000/dev/messages/fetch?id=' + _currentId));

    Iterable l = json.decode(response.body);
    List<SupportMessage> messages = List<SupportMessage>.from(
        l.map((model) => SupportMessage.fromJson(model)));

    return Future.value(messages);
  }

  @override
  Future addMessage(SupportMessage message) async {
    return http.post(
      Uri.parse("http://localhost:3000/dev/messages/add"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'threadOwnerId': _currentId,
        'authorId': message.authorId,
        'contents': message.contents
      }),
    );
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await http.get(Uri.parse(
        'http://localhost:3000/dev/messages/unread_count?id=' + _currentId));
    return int.parse(response.body);
  }
}

class SupportMessage {
  SupportMessage({this.authorId, this.contents, this.time});

  SupportMessage.clone(SupportMessage message)
      : this(
            authorId: message.authorId,
            contents: message.contents,
            time: message.time);

  final String authorId;
  final String contents;
  final DateTime time;

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    return SupportMessage(
      authorId: json['authorId'],
      contents: json['contents'],
      time: DateTime.fromMicrosecondsSinceEpoch(json['time']),
    );
  }

  Map<String, dynamic> toJson() => {
        'authorId': authorId,
        'contents': contents,
        'time': time.microsecondsSinceEpoch
      };
}
