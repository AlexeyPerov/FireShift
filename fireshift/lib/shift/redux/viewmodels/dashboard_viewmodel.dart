import 'package:async_redux/async_redux.dart';
import 'package:fireshift/shift/redux/actions/all_actions.dart';
import 'package:fireshift/shift/redux/entities/support_thread.dart';
import 'package:flutter/widgets.dart';

import '../dashboard_state_store.dart';

class DashboardViewModel extends BaseModel<DashboardState> {
  DashboardViewModel();

  FilteredThreads threads;

  VoidCallback onLoad;
  Function(Filter) onFilter;

  DashboardViewModel.build(
      {@required this.threads, @required this.onLoad, @required this.onFilter})
      : super(equals: [threads]);

  @override
  DashboardViewModel fromStore() => DashboardViewModel.build(
      threads: state.threads,
      onLoad: () => dispatch(LoadFilterAction()),
      onFilter: (filter) => dispatch(FilterAction(filter: filter)));
}
