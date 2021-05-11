import 'package:equatable/equatable.dart';
import 'package:fireshift/shift/entities/support_thread.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardState extends Equatable {
  final Filter filter;

  DashboardState(this.filter);

  @override
  List<Object> get props => [ filter ];
}

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState(Filter.deactivated()));

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is ChangeFilterEvent) {
      yield* _mapChangeFilterToState(event);
    }
  }

  Stream<DashboardState> _mapChangeFilterToState(ChangeFilterEvent event) async* {
    yield DashboardState(event.filter);
  }
}

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class ChangeFilterEvent extends DashboardEvent {
  final Filter filter;

  ChangeFilterEvent(this.filter);

  @override
  List<Object> get props => [filter];
}

