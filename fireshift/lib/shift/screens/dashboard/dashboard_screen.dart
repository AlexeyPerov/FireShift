import 'dart:math';

import 'package:async_redux/async_redux.dart';
import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:fireshift/shift/redux/dashboard_state_store.dart';
import 'package:fireshift/shift/redux/viewmodels/dashboard_viewmodel.dart';
import 'package:fireshift/shift/screens/chat/chat_screen.dart';
import 'package:fireshift/shift/screens/dashboard/components/thread_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DashboardConnector extends StatelessWidget {
  DashboardConnector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<DashboardState>(
      store: dashboardStore,
      child: StoreConnector<DashboardState, DashboardViewModel>(
        model: DashboardViewModel(),
        onInitialBuild: (viewModel) => viewModel.onLoad(),
        builder: (BuildContext context, DashboardViewModel viewModel) =>
            DashboardScreen(viewModel: viewModel),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  final DashboardViewModel viewModel;

  const DashboardScreen({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: new LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              if (viewModel.filteredThreads == null ||
                  viewModel.filteredThreads.threads.isEmpty) {
                return Container();
              }

              var height = constraints.hasInfiniteHeight
                  ? MediaQuery.of(context).size.height
                  : constraints.maxHeight;

              return Container(
                width: kIsWeb ? min(kMinWebContainerWidth, width) : null,
                height: height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 140,
                      // TODO put filters here
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: height - 150,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          itemCount: viewModel.filteredThreads.threads.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SupportThreadInfoCard(
                                threadInfo:
                                    viewModel.filteredThreads.threads[index],
                                onNavigateToChatScreen: _navigateToChatScreen);
                          }),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToChatScreen(context, ""),
        backgroundColor: Color(0xFF757575),
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToChatScreen(BuildContext context, String threadId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatConnector(threadId: threadId),
      ),
    );
  }
}
