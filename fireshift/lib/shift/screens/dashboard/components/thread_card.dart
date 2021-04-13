import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:fireshift/shift/redux/entities/support_thread.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SupportThreadInfoCard extends StatelessWidget {
  final SupportThreadInfo threadInfo;
  final Function(BuildContext, String) onNavigateToChatScreen;

  const SupportThreadInfoCard(
      {Key key, this.threadInfo, this.onNavigateToChatScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        background: Card(
          elevation: 8.0,
          child: Container(
            color: kPrimaryColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 15.0),
                  child: Text(
                    'REMOVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ),
        key: Key(UniqueKey().toString()),
        onDismissed:
            (direction) => /*onRemove(note.id)*/ null, // TODO implement
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            onTap: () => onNavigateToChatScreen(context, threadInfo.id),
            child: Container(
              height: 120,
              padding: EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(threadInfo.subject,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.headline6.apply(
                                color: colorScheme.onSurface,
                                decoration: threadInfo.archived
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none)),
                      ),
                      Checkbox(
                        value: threadInfo.archived,
                        onChanged: (value) =>
                            /*onArchive(note.id, !note.archived)*/ null, // TODO implement
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(threadInfo.preview,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyText2.apply(
                              color: colorScheme.onSurface,
                              decoration: threadInfo.archived
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none)))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
