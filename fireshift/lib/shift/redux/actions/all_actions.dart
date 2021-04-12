import 'package:async_redux/async_redux.dart';
import 'package:fireshift/shift/redux/chat_state_store.dart';
import 'package:fireshift/shift/repositories/support_repository.dart';
import 'package:flutter/material.dart';

import '../dashboard_state_store.dart';

class LoadFilterAction extends ReduxAction<DashboardState> {
  LoadFilterAction();

  @override
  Future<DashboardState> reduce() async {
    var repository = getIt<SupportRepository>();
    var projects = await repository.fetchProjects();
    var selectedProject = projects[0];
    var tickets = await repository.fetchAllTickets(selectedProject.id);

    var filter = TicketFilter(
        project: selectedProject,
        filter: TicketFilterType.all,
        tickets: tickets);
    return state.copy(projects: projects, ticketFilter: filter);
  }
}

class FilterAction extends ReduxAction<DashboardState> {
  final String projectId;
  final TicketFilterType filterType;

  FilterAction({@required this.projectId, @required this.filterType});

  @override
  Future<AppState> reduce() async {
    var repository = getIt<SupportRepository>();
    List<TicketInfo> tickets;

    if (filterType == TicketFilterType.unread)
      tickets = await repository.fetchUnreadTickets(projectId);
    else if (filterType == TicketFilterType.trash)
      tickets = await repository.fetchArchivedTickets(projectId);
    else
      tickets = await repository.fetchAllTickets(projectId);

    var filter = TicketFilter(
        project: state.projects.firstWhere((x) => x.id == projectId),
        filter: filterType,
        tickets: tickets);
    return state.copy(ticketFilter: filter);
  }
}

class LoadContentsAction extends ReduxAction<ChatState> {
  LoadContentsAction();

  @override
  Future<DashboardState> reduce() async {
    var repository = getIt<SupportRepository>();
    var projects = await repository.fetchProjects();
    var selectedProject = projects[0];
    var tickets = await repository.fetchAllTickets(selectedProject.id);

    var filter = TicketFilter(
        project: selectedProject,
        filter: TicketFilterType.all,
        tickets: tickets);
    return state.copy(projects: projects, ticketFilter: filter);
  }
}

class AddMessageAction extends ReduxAction<ChatState> {
  final String ticketId;
  final TicketMessage message;

  AddMessageAction({@required this.ticketId, @required this.message});

  @override
  Future<AppState> reduce() async {
    var repository = getIt<SupportRepository>();

    var ticket = await repository.addMessageToTicket(
        ticketId, message.authorId, message.contents);

    return state.copy(selectedTicket: ticket);
  }
}

class ArchiveAction extends ReduxAction<ChatState> {
  final String ticketId;
  final bool archive;

  ArchiveAction({@required this.ticketId, @required this.archive});

  @override
  Future<AppState> reduce() async {
    var repository = getIt<SupportRepository>();

    var newTicketInfo = await repository.archiveTicket(ticketId, archive);

    return updateStateWith(ticketId, state, newTicketInfo);
  }
}

class StarAction extends ReduxAction<ChatState> {
  final String ticketId;
  final bool star;

  StarAction({@required this.ticketId, @required this.star});

  @override
  Future<AppState> reduce() async {
    var repository = getIt<SupportRepository>();

    var newTicketInfo = await repository.starTicket(ticketId, star);

    return updateStateWith(ticketId, state, newTicketInfo);
  }
}

class MarkReadAction extends ReduxAction<ChatState> {
  final String ticketId;
  final bool read;

  MarkReadAction({@required this.ticketId, @required this.read});

  @override
  Future<AppState> reduce() async {
    var repository = getIt<SupportRepository>();

    var newTicketInfo = await repository.markTicketRead(ticketId, read);

    return updateStateWith(ticketId, state, newTicketInfo);
  }
}

AppState updateStateWith(
    String ticketId, AppState state, TicketInfo newTicketInfo) {
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
}