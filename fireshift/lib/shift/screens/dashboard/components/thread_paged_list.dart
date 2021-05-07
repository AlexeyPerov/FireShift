import 'dart:async';

import 'package:fireshift/shift/bloc/dashboard/dashboard.dart';
import 'package:fireshift/shift/bloc/entities/support_thread.dart';
import 'package:fireshift/shift/screens/chat/chat_screen.dart';
import 'package:fireshift/shift/screens/dashboard/components/thread_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ThreadPagedList extends StatefulWidget {
  const ThreadPagedList({Key key}) : super(key: key);

  @override
  _ThreadPagedListState createState() => _ThreadPagedListState();
}

class _ThreadPagedListState extends State<ThreadPagedList> {
  final DashboardBloc _bloc = DashboardBloc();
  final PagingController<int, SupportThreadInfo> _pagingController =
      PagingController(firstPageKey: 0);
  StreamSubscription _blocSubscription;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _bloc.onPageRequestSink.add(pageKey);
    });

    // We could've used StreamBuilder, but that would unnecessarily recreate
    // the entire widget every time the state changes.
    // Instead, handling the subscription ourselves and updating only the
    // _pagingController is more efficient.
    _blocSubscription =
        _bloc.onNewListingState.listen((listingState) {
          _pagingController.value = PagingState(
            nextPageKey: listingState.nextPageKey,
            error: listingState.error,
            itemList: listingState.itemList,
          );
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, SupportThreadInfo>.separated(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<SupportThreadInfo>(
          itemBuilder: (context, item, index) => SupportThreadInfoCard(
              threadInfo:
                  item,
              onNavigateToChatScreen: _navigateToChatScreen),
        ),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _blocSubscription.cancel();
    _bloc.dispose();
    super.dispose();
  }

  // TODO pass here as an arg
  void _navigateToChatScreen(BuildContext context, String threadId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatConnector(threadId: threadId),
      ),
    );
  }
}
