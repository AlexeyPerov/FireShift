import 'package:fireshift/platform/utilities/future_extensions.dart';
import 'package:fireshift/shift/redux/entities/support_thread.dart';
import 'package:fireshift/shift/repositories/support_repository.dart';

class MockSupportRepository extends SupportRepository {
  List<SupportThread> threads = List<SupportThread>.empty(growable: true);

  @override
  Future initialize() async {
    await milliseconds(400);

    const int threadsCount = 55;
    for (var i = 0; i < threadsCount; i++) {
      threads.add(
          SupportThread(
              info: createMockTicketInfo(i.toString(), i),
              contents: createMockTicketContents(i))
      );
    }
  }

  @override
  Future<SupportThread> addThreadMessage(
      String id, String senderId, String response) {
    var thread = threads.firstWhere((x) => x.info.id == id);

    if (thread == null) {
      throw ('Unable to find thread with id $id');
    }

    var newThread = SupportThread.clone(thread);
    newThread.contents.messages.add(SupportMessage(
        authorId: senderId, contents: response, time: DateTime.now()));

    var index = threads.indexOf(thread);
    threads[index] = newThread;

    return Future.value(newThread);
  }

  @override
  Future<SupportThreadInfo> archive(String id, bool archive) {
    var thread = threads.firstWhere((x) => x.info.id == id);

    var info = thread.info.copy(archived: archive);

    var newThread = thread.copy(info: info);

    var index = threads.indexOf(thread);
    threads[index] = newThread;

    return Future.value(newThread.info);
  }

  @override
  Future<List<SupportThreadInfo>> fetchThreadsInfo(Filter filter) {
    var projectTickets = threads
        .where((ticket) => ticket.info.project.contains(filter.project))
        .map((e) => e.info)
        .toList(growable: false);

    var start = filter.pageStart.clamp(0, projectTickets.length);
    var end = (start + filter.pageSize).clamp(0, projectTickets.length);

    var tickets = projectTickets.getRange(start, end).toList(growable: false);

    return Future.value(tickets);
  }

  @override
  Future<SupportThread> fetchThread(String ticketId) {
    var ticket = threads.firstWhere((x) => x.info.id == ticketId);
    return Future.value(ticket);
  }

  @override
  Future<SupportThreadInfo> markRead(String id, bool read) {
    var ticket = threads.firstWhere((x) => x.info.id == id);

    var info = ticket.info.copy(unread: !read);

    var newTicket = ticket.copy(info: info);

    threads.remove(ticket);
    threads.add(newTicket);

    return Future.value(newTicket.info);
  }

  @override
  Future<SupportThreadInfo> star(String id, bool star) {
    var ticket = threads.firstWhere((x) => x.info.id == id);

    var info = ticket.info.copy(starred: star);

    var newTicket = ticket.copy(info: info);

    threads.remove(ticket);
    threads.add(newTicket);

    return Future.value(newTicket.info);
  }
}

SupportThreadInfo createMockTicketInfo(String projectId, int id) {
  return SupportThreadInfo(
      id: id.toString(),
      project: projectId,
      senderId: 'User ' + id.toString(),
      receiverId: 'Support',
      starred: false,
      unread: true,
      archived: false,
      subject: 'Support request ' + id.toString(),
      updateTime: DateTime.now(),
      contentsId: "contents_" + id.toString(),
      preview: 'Excepteur sint occaecat cupidatat non proident');
}

SupportThreadContents createMockTicketContents(int id) {
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
