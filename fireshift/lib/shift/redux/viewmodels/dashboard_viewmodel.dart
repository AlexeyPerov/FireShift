import 'package:async_redux/async_redux.dart';
import 'package:fireshift/shift/redux/actions/all_actions.dart';
import 'package:fireshift/shift/redux/entities/support_thread.dart';
import 'package:flutter/widgets.dart';

import '../dashboard_state_store.dart';

class DashboardViewModel extends BaseModel<DashboardState> {
  DashboardViewModel();

  FilteredThreads filteredThreads;

  VoidCallback onLoad;
  Function(Filter) onFilter;

  DashboardViewModel.build(
      {@required this.filteredThreads, @required this.onLoad, @required this.onFilter})
      : super(equals: [filteredThreads]);

  @override
  DashboardViewModel fromStore() => DashboardViewModel.build(
      filteredThreads: state.threads,
      onLoad: () => dispatch(LoadFilterAction()),
      onFilter: (filter) => dispatch(FilterAction(filter: filter)));
}
