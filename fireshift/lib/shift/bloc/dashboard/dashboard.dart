import 'dart:async';

import 'package:fireshift/shift/app/app.dart';
import 'package:fireshift/shift/bloc/entities/support_thread.dart';
import 'package:fireshift/shift/repositories/support_repository.dart';
import 'package:rxdart/rxdart.dart';

class DashboardState {
  DashboardState({
    this.itemList,
    this.error,
    this.nextPageKey = 0,
  });

  final List<SupportThreadInfo> itemList;
  final dynamic error;
  final int nextPageKey;
}

// TODO rename to smth like threads list?
class DashboardBloc {
  DashboardBloc() {
    _onPageRequest.stream
        .flatMap(_fetchThreadInfos)
        .listen(_onNewListingStateController.add)
        .addTo(_subscriptions);

    _onSearchInputChangedSubject.stream
        .flatMap((_) => _resetSearch())
        .listen(_onNewListingStateController.add)
        .addTo(_subscriptions);
  }

  static const _pageSize = 10;

  final _subscriptions = CompositeSubscription();

  final _onNewListingStateController =
  BehaviorSubject<DashboardState>.seeded(
    DashboardState(),
  );

  Stream<DashboardState> get onNewListingState =>
      _onNewListingStateController.stream;

  final _onPageRequest = StreamController<int>();

  Sink<int> get onPageRequestSink => _onPageRequest.sink;

  final _onSearchInputChangedSubject = BehaviorSubject<String>();

  Sink<String> get onSearchInputChangedSink =>
      _onSearchInputChangedSubject.sink;

  String get searchInputValue => _onSearchInputChangedSubject.value;

  Stream<DashboardState> _resetSearch() async* {
    yield DashboardState();
    yield* _fetchThreadInfos(0);
  }

  Stream<DashboardState> _fetchThreadInfos(int pageKey) async* {
    final lastListingState = _onNewListingStateController.value;
    try {
      final repository = getIt<SupportRepository>();
      // TODO use searchTerm: searchInputValue as project
      final newItems = await repository.fetchThreadsInfo(Filter(project: ""), PageTarget(pageStart: pageKey, pageSize: _pageSize));
      final isLastPage = newItems.length < _pageSize;
      final nextPageKey = isLastPage ? null : pageKey + newItems.length;
      yield DashboardState(
        error: null,
        nextPageKey: nextPageKey,
        itemList: [...lastListingState?.itemList ?? [], ...newItems],
      );
    } catch (e) {
      yield DashboardState(
        error: e,
        nextPageKey: lastListingState?.nextPageKey,
        itemList: lastListingState?.itemList,
      );
    }
  }

  void dispose() {
    _onSearchInputChangedSubject.close();
    _onNewListingStateController.close();
    _subscriptions.dispose();
    _onPageRequest.close();
  }
}