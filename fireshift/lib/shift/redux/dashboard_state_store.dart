import 'package:async_redux/async_redux.dart';

import 'entities/support_thread.dart';

var store = Store<DashboardState>(
  initialState: DashboardState.initialState(),
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