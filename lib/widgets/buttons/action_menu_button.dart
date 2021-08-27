
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ActionMenuButton extends StatelessWidget {
  final List<Widget> actions;
  const ActionMenuButton({
    Key? key,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: FaIcon(FontAwesomeIcons.ellipsisV),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      offset: Offset(0.0, 50.0),
      itemBuilder: (context) {
        return actions
            .map(
              (e) => PopupMenuItem(child: e),
            )
            .toList();
      },
    );
  }
}