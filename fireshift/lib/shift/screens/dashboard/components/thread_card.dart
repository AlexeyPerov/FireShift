import 'package:fireshift/platform/utilities/formatters.dart';
import 'package:fireshift/platform/widgets/conditional_widget.dart';
import 'package:fireshift/shift/entities/support_thread.dart';
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
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 8.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () => onNavigateToChatScreen(context, threadInfo.id),
          child: Container(
            height: 135,
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
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(threadInfo.project, style: textTheme.headline6),
                    ),
                    ConditionalWidget(
                      condition: threadInfo.starred,
                      child: Icon(
                        Icons.favorite,
                        size: 24.0
                      ),
                    ),
                    ConditionalWidget(
                      condition: threadInfo.unread,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                            Icons.chat,
                            // color: Colors.pink,
                            size: 24.0
                        ),
                      ),
                    ),
                    ConditionalWidget(
                      condition: threadInfo.archived,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.archive,
                          // color: Colors.pink,
                          size: 24.0
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Expanded(
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(threadInfo.preview,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyText2.apply(
                              color: colorScheme.onSurface,
                              decoration: threadInfo.archived
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none))),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(child: Text(threadInfo.threadOwnerId)),
                    Text(dateFormatter.format(threadInfo.updateTime),
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headline6
                            .apply(color: colorScheme.onSurface)),
                    SizedBox(width: 10),
                    Text(timeFormatter.format(threadInfo.updateTime),
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headline6
                            .apply(color: colorScheme.onSurface)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
