import 'package:async_redux/async_redux.dart';
import 'package:fireshift/shift/redux/chat_state_store.dart';

import 'entities/support_thread.dart';

var dashboardStore = Store<DashboardState>(
  initialState: DashboardState.initialState(),
);

var chatStore = Store<ChatState>(
  initialState: ChatState.initialState(),
);

class DashboardState {
  final FilteredThreads threads;

  DashboardState({this.threads});

  DashboardState copy(
      {FilteredThreads threads}) =>
      DashboardState(
          threads: threads ?? this.threads);

  static DashboardState initialState() => DashboardState(
      threads: FilteredThreads(
          filter: Filter(project: ""),
          threads: List.empty(growable: false)));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DashboardState &&
              runtimeType == other.runtimeType &&
              threads == other.threads;

  @override
  int get hashCode => threads.hashCode;
}