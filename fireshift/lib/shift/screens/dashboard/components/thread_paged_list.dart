import 'package:fireshift/shift/app/app.dart';
import 'package:fireshift/shift/bloc/entities/support_thread.dart';
import 'package:fireshift/shift/repositories/support_repository.dart';
import 'package:fireshift/shift/screens/chat/chat_screen.dart';
import 'package:fireshift/shift/screens/dashboard/components/thread_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ThreadPagedList extends StatefulWidget {
  final DashboardViewModel viewModel;

  const ThreadPagedList({Key key, this.viewModel}) : super(key: key);

  @override
  _ThreadPagedListState createState() => _ThreadPagedListState();
}

class _ThreadPagedListState extends State<ThreadPagedList> {
  static const _pageSize = 10;

  final PagingController<int, SupportThreadInfo> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var repository = getIt<SupportRepository>();
      final newItems = await repository.fetchThreadsInfo(Filter(
          pageStart: pageKey,
          pageSize: _pageSize,
          project:
              ""));
      // await widget.viewModel.onFilter

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
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
