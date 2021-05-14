import 'package:fireshift/shift/bloc/dashboard/dashboard.dart';
import 'package:fireshift/shift/entities/support_thread.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterCard extends StatefulWidget {
  final Filter filter;

  const FilterCard({Key key, this.filter}) : super(key: key);

  @override
  _FilterCardState createState() => _FilterCardState();
}

class _FilterCardState extends State<FilterCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _contentsSearchController;

  @override
  void initState() {
    super.initState();
    _contentsSearchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).iconTheme.color;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: 90,
          padding: EdgeInsets.only(left: 25, right: 25, top: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Form(
                        key: _formKey,
                        child: Container(
                          width: 220,
                          child: TextFormField(
                              controller: _contentsSearchController,
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              autofocus: false),
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        children: [
                          IconButton(
                              icon: Icon(Icons.search,
                                  color: widget.filter.contents.value.isNotEmpty
                                      ? Colors.pink
                                      : defaultColor,
                                  size: 24.0),
                              onPressed: () => {
                                BlocProvider.of<DashboardBloc>(context).add(
                                    ChangeFilterEvent(widget.filter.copy(
                                        contents: FilterText.activated(
                                            _contentsSearchController.text))))
                              }),
                          SizedBox(height: 5),
                          Text("Find"),
                        ],
                      )
                    ],
                  ),
                  FilterButtons(filter: widget.filter)
                ],
              )
            ],
          ),
        ),
      ),
    );
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
                    BlocProvider.of<DashboardBloc>(context).add(
                        ChangeFilterEvent(
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
                    BlocProvider.of<DashboardBloc>(context).add(
                        ChangeFilterEvent(
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
                    BlocProvider.of<DashboardBloc>(context).add(
                        ChangeFilterEvent(
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
