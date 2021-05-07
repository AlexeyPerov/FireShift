/*
import 'package:async_redux/async_redux.dart';
import 'package:fireshift/shift/app/app.dart';
import 'package:fireshift/shift/redux/chat_state_store.dart';
import 'package:fireshift/shift/redux/entities/support_thread.dart';
import 'package:fireshift/shift/repositories/support_repository.dart';
import 'package:flutter/material.dart';

import '../dashboard_state_store.dart';

class LoadFilterAction extends ReduxAction<DashboardState> {
  LoadFilterAction();

  @override
  Future<DashboardState> reduce() async {
    //var repository = getIt<SupportRepository>();
    var filter = Filter(project: "");
    var threads = List<SupportThreadInfo>.empty(); // TODO await repository.fetchThreadsInfo(filter);
    return state.copy(
        threads: FilteredThreads(filter: filter, threads: threads));
  }
}

class FilterAction extends ReduxAction<DashboardState> {
  final Filter filter;

  FilterAction({@required this.filter});

  @override
  Future<DashboardState> reduce() async {
    var repository = getIt<SupportRepository>();
    var threads = await repository.fetchThreadsInfo(filter);
    return state.copy(
        threads: FilteredThreads(filter: filter, threads: threads));
  }
}

class LoadContentsAction extends ReduxAction<ChatState> {
  final String threadId;

  LoadContentsAction({@required this.threadId});

  @override
  Future<ChatState> reduce() async {
    var repository = getIt<SupportRepository>();
    var thread = await repository.fetchThread(threadId);
    return state.copy(thread: thread);
  }
}

class AddMessageAction extends ReduxAction<ChatState> {
  final String threadId;
  final SupportMessage message;

  AddMessageAction({@required this.threadId, @required this.message});

  @override
  Future<ChatState> reduce() async {
    var repository = getIt<SupportRepository>();

    var thread = await repository.addThreadMessage(
        threadId, message.authorId, message.contents);

    return state.copy(thread: thread);
  }
}

class ArchiveAction extends ReduxAction<ChatState> {
  final String threadId;
  final bool archive;

  ArchiveAction({@required this.threadId, @required this.archive});

  @override
  Future<ChatState> reduce() async {
    var repository = getIt<SupportRepository>();
    var newThreadInfo = await repository.archive(threadId, archive);
    return state.copy(thread: state.thread.copy(info: newThreadInfo));
  }
}

class StarAction extends ReduxAction<ChatState> {
  final String threadId;
  final bool star;

  StarAction({@required this.threadId, @required this.star});

  @override
  Future<ChatState> reduce() async {
    var repository = getIt<SupportRepository>();
    var newThreadInfo = await repository.star(threadId, star);
    return state.copy(thread: state.thread.copy(info: newThreadInfo));
  }
}

class MarkReadAction extends ReduxAction<ChatState> {
  final String threadId;
  final bool read;

  MarkReadAction({@required this.threadId, @required this.read});

  @override
  Future<ChatState> reduce() async {
    var repository = getIt<SupportRepository>();
    var newThreadInfo = await repository.markRead(threadId, read);
    return state.copy(thread: state.thread.copy(info: newThreadInfo));
  }
}
*/

/*ChatState updateStateWith(
    String threadId, ChatState state, SupportThreadInfo newThreadInfo) {
  var listIndex =
  state.ticketFilter.tickets.indexWhere((ticket) => ticket.id == ticketId);

  List<TicketInfo> newTickets;
  Ticket newSelectedTicket;

  if (listIndex != -1) {
    newTickets = state.ticketFilter.tickets.toList();
    newTickets[listIndex] = newTicketInfo;
  }

  if (state.selectedTicket != null &&
      state.selectedTicket.info.id == ticketId) {
    newSelectedTicket =
        Ticket(info: newTicketInfo, contents: state.selectedTicket.contents);
  }

  var newFilter =
  newTickets != null ? state.ticketFilter.copy(tickets: newTickets) : null;

  return state.copy(ticketFilter: newFilter, selectedTicket: newSelectedTicket);
}*/
