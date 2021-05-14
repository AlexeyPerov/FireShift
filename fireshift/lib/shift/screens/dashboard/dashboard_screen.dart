import 'dart:math';

import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:fireshift/shift/bloc/dashboard/dashboard.dart';
import 'package:fireshift/shift/entities/support_thread.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/thread_paged_list.dart';

class DashboardConnector extends StatelessWidget {
  DashboardConnector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(create: (context) {
      return DashboardBloc();
    }, child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, DashboardState state) {
      return DashboardScreen(state.filter);
    }));
  }
}

class DashboardScreen extends StatelessWidget {
  final Filter filter;

  const DashboardScreen(this.filter, {Key key}) : super(key: key);

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
                      FilterButtons(filter: filter),
                      SizedBox(height: 10),
                      Container(
                          height: height - 75, child: ThreadPagedList(filter)),
                    ],
                  ),
                );
              }),
            ),
          ],
        ));
  }
}

class FilterButtons extends StatelessWidget {
  final Filter filter;

  const FilterButtons({Key key, this.filter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).iconTheme.color;

    return Row(children: [
      Column(
        children: [
          IconButton(
              icon: Icon(Icons.archive,
                  color: getColor(filter.archived, defaultColor), size: 24.0),
              onPressed: () => {
                    BlocProvider.of<DashboardBloc>(context).add(ChangeFilterEvent(
                        filter.copy(archived: filter.archived.next())))
                  }),
          SizedBox(height: 5),
          Text("Archived")
        ],
      ),
      SizedBox(width: 10),
      Column(
        children: [
          IconButton(
              icon: Icon(Icons.chat,
                  color: getColor(filter.unread, defaultColor), size: 24.0),
              onPressed: () => {
                    BlocProvider.of<DashboardBloc>(context).add(ChangeFilterEvent(
                        filter.copy(unread: filter.unread.next())))
                  }),
          SizedBox(height: 5),
          Text("Unread")
        ],
      ),
      SizedBox(width: 10),
      Column(
        children: [
          IconButton(
              icon: Icon(Icons.favorite,
                  color: getColor(filter.starred, defaultColor), size: 24.0),
              onPressed: () => {
                    BlocProvider.of<DashboardBloc>(context).add(ChangeFilterEvent(
                        filter.copy(starred: filter.starred.next())))
                  }),
          SizedBox(height: 5),
          Text("Favorite")
        ],
      )
    ]);
  }

  Color getColor(FilterToggle toggle, Color defaultColor) => toggle.activated
      ? (toggle.value ? Colors.pink : defaultColor)
      : defaultColor.withAlpha(128);
}
