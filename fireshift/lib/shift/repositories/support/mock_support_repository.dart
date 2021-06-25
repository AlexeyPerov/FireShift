import 'package:fireshift/platform/utilities/future_extensions.dart';
import 'package:fireshift/platform/utilities/random.dart';
import 'package:fireshift/shift/entities/support_thread.dart';
import 'package:fireshift/shift/repositories/support/support_repository.dart';

class MockSupportRepository extends SupportRepository {
  List<SupportThread> threads = List<SupportThread>.empty(growable: true);

  @override
  Future initialize() async {
    await fakeDelay();

    const int threadsCount = 55;
    for (var i = 0; i < threadsCount; i++) {
      threads.add(SupportThread(
          info:
              createMockSupportThreadInfo(RandomUtilities.hit(0.1) ? "Dev" : "AoC", i),
          contents: createMockSupportThreadContents(i)));
    }
  }

  @override
  Future<SupportThread> addThreadMessage(
      String id, String threadOwnerId, String response) async {
    await fakeDelay();

    var thread = threads.firstWhere((x) => x.info.id == id);

    if (thread == null) {
      throw ('Unable to find thread with id $id');
    }

    var newThread = SupportThread.clone(thread);
    newThread.contents.messages.add(SupportMessage(
        authorId: threadOwnerId, contents: response, time: DateTime.now(), read: true));

    var index = threads.indexOf(thread);
    threads[index] = newThread;

    return Future.value(newThread);
  }

  @override
  Future<SupportThreadInfo> archive(String id, bool archive) async {
    await fakeDelay();

    var thread = threads.firstWhere((x) => x.info.id == id);

    var info = thread.info.copy(archived: archive);

    var newThread = thread.copy(info: info);

    var index = threads.indexOf(thread);
    threads[index] = newThread;

    return Future.value(newThread.info);
  }

  @override
  Future<List<SupportThreadInfo>> fetchThreadsInfo(
      Filter filter, PageTarget pageTarget) async {
    await fakeDelay();

    var filteredThreads = threads
        .where((thread) =>
            thread.info.subject.contains(filter.contents.value) ||
            thread.info.threadOwnerId.contains(filter.contents.value) ||
            thread.info.project.contains(filter.contents.value) ||
            thread.contents.messages.any(
                (message) => message.contents.contains(filter.contents.value)))
        .where((thread) =>
            !filter.archived.activated ||
            thread.info.archived == filter.archived.value)
        .where((thread) =>
            !filter.starred.activated ||
            thread.info.starred == filter.starred.value)
        .where((thread) =>
            !filter.unread.activated ||
            thread.info.unread == filter.unread.value)
        .map((e) => e.info)
        .toList(growable: false);

    var start = pageTarget.pageStart.clamp(0, filteredThreads.length);
    var end = (start + pageTarget.pageSize).clamp(0, filteredThreads.length);

    var result = filteredThreads.getRange(start, end).toList(growable: false);

    return Future.value(result);
  }

  @override
  Future<SupportThread> fetchThread(String ticketId) async {
    await fakeDelay();

    var ticket = threads.firstWhere((x) => x.info.id == ticketId);
    return Future.value(ticket);
  }

  @override
  Future<SupportThreadInfo> markRead(String id, bool read) async {
    await fakeDelay();

    var thread = threads.firstWhere((x) => x.info.id == id);

    var info = thread.info.copy(unread: !read);

    var newThread = thread.copy(info: info);

    var index = threads.indexOf(thread);
    threads[index] = newThread;

    return Future.value(newThread.info);
  }

  @override
  Future<SupportThreadInfo> star(String id, bool star) async {
    await fakeDelay();

    var thread = threads.firstWhere((x) => x.info.id == id);

    var info = thread.info.copy(starred: star);

    var newThread = thread.copy(info: info);

    var index = threads.indexOf(thread);
    threads[index] = newThread;

    return Future.value(newThread.info);
  }

  Future fakeDelay() async {
    await milliseconds(RandomUtilities.get(300, 600));
  }
}

SupportThreadInfo createMockSupportThreadInfo(String projectId, int id) {
  return SupportThreadInfo(
      id: id.toString(),
      project: projectId,
      threadOwnerId: 'User ' + id.toString(),
      receiverId: 'Support',
      starred: RandomUtilities.hit(0.5),
      unread: RandomUtilities.hit(0.85),
      archived: RandomUtilities.hit(0.1),
      subject: 'Support request ' + id.toString(),
      updateTime: DateTime.now(),
      contentsId: "contents_" + id.toString(),
      preview: 'Excepteur sint occaecat cupidatat $id non proident');
}

SupportThreadContents createMockSupportThreadContents(int id) {
  return SupportThreadContents(id: "contents_" + id.toString(), messages: [
    SupportMessage(authorId: "0", contents: "hello", time: DateTime.now()),
    SupportMessage(
        authorId: "1",
        contents: 'Excepteur sint occaecat cupidatat $id non proident.\n'
            'sunt in culpa qui officia deserunt mollit anim id est laborum'
            'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
        time: DateTime.now()),
    SupportMessage(authorId: "0", contents: "thanks", time: DateTime.now())
  ]);
}
