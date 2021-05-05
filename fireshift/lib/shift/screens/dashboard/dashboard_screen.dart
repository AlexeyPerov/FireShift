import 'dart:math';

import 'package:async_redux/async_redux.dart';
import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:fireshift/shift/redux/dashboard_state_store.dart';
import 'package:fireshift/shift/redux/viewmodels/dashboard_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'components/thread_paged_list.dart';

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
              var height = constraints.hasInfiniteHeight
                  ? MediaQuery.of(context).size.height
                  : constraints.maxHeight;

              return Container(
                width: kIsWeb ? min(kMinWebContainerWidth, width) : null,
                height: height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      // TODO put filters here
                    ),
                    SizedBox(height: 10),
                    Container(
                        height: height - 50,
                        child: ThreadPagedList(viewModel: viewModel)),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      // TODO restore
      /*floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToChatScreen(context, ""),
        backgroundColor: Color(0xFF757575),
        child: Icon(Icons.add),
      ),*/
    );
  }
}
