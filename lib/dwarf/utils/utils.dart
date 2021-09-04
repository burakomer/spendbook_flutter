import 'package:flutter/material.dart';

Future<T?> showTallBottomSheet<T>({
  required BuildContext context,
  required Widget content,
}) async {
  final theme = Theme.of(context).bottomSheetTheme;
  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.6,
        builder: (context, controller) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.backgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(21.0),
              ),
            ),
            child: SingleChildScrollView(
              controller: controller,
              child: content,
            ),
          );
        },
      );
    },
  );
}
