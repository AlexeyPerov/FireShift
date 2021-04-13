import 'package:fireshift/platform/utilities/formatters.dart';
import 'package:fireshift/shift/redux/entities/support_thread.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SupportMessageCard extends StatelessWidget {
  final SupportMessage message;

  const SupportMessageCard(
      {Key key, this.message})
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
          onTap: () => null, // TODO implement something like copy to clipboard
          child: Container(
            height: 135,
            padding: EdgeInsets.all(25.0),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(message.contents,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyText2.apply(
                            color: colorScheme.onSurface))),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(message.authorId,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headline6.apply(
                            color: colorScheme.onSurface,
                            decoration: TextDecoration.underline)),
                    Text(dateFormatter.format(message.time),
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.headline6
                            .apply(color: colorScheme.onSurface)),
                    Text(timeFormatter.format(message.time),
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
