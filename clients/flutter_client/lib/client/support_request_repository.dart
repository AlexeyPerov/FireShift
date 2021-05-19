abstract class SupportRequestRepository {
  String getCurrentUserId();
  setUserId(String id);

  Future<List<SupportMessage>> fetchMessages();
  Future addMessage(SupportMessage message);
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
}
