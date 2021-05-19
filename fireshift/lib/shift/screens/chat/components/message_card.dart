import 'package:fireshift/platform/utilities/formatters.dart';
import 'package:fireshift/platform/widgets/conditional_widget.dart';
import 'package:fireshift/shift/entities/support_thread.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SupportMessageCard extends StatelessWidget {
  final SupportMessage message;

  const SupportMessageCard({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final isAdmin = message.authorId == kAdminUserId;

    return Padding(
      padding: EdgeInsets.only(
          bottom: 18, left: isAdmin ? 0 : 40, right: isAdmin ? 40 : 0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          splashColor: Colors.blue,
          onTap: () => null,
          child: Container(
            padding: EdgeInsets.all(25.0),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(message.contents,
                          style: textTheme.bodyText2
                              .apply(color: colorScheme.onSurface)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ConditionalWidget(
                          condition: message.authorId != kAdminUserId,
                          child: Text("User " + message.authorId,
                              style: textTheme.subtitle1
                                  .apply(color: colorScheme.onSurface)),
                        ),
                      ),
                      Text(dateFormatter.format(message.time),
                          style: textTheme.subtitle1
                              .apply(color: colorScheme.onSurface)),
                      SizedBox(width: 10),
                      Text(timeFormatter.format(message.time),
                          style: textTheme.subtitle1
                              .apply(color: colorScheme.onSurface)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
