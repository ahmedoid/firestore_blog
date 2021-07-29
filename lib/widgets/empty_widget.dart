import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.view_list_outlined,
            color: Colors.red,
            size: 120,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              t!.empty,
              textAlign: TextAlign.center,
            ),
          ),
        ]);
  }
}
