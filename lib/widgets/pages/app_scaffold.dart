import 'dart:ui';

import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? bottomBar;
  final List<Widget>? actions;
  final List<Widget>? bottomActions;
  final Widget? floatingActionButton;

  final bool hasScaffold;

  const AppScaffold({
    Key? key,
    this.title = "",
    required this.body,
    this.bottomBar,
    this.actions,
    this.bottomActions,
    this.floatingActionButton,
  })  : hasScaffold = false,
        super(key: key);

  const AppScaffold.tab({
    Key? key,
    this.title = "",
    required this.body,
    this.bottomBar,
    this.actions,
    this.bottomActions,
    this.floatingActionButton,
  })  : hasScaffold = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    final appBar = AppBar(
      title: Text(
        title,
        style: canPop
            ? Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                )
            : Theme.of(context).appBarTheme.titleTextStyle,
      ),
      actions: actions,
      automaticallyImplyLeading: false,
      leading: _getLeading(context),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: bottomBar ??
          (bottomActions != null
              ? Theme(
                  data: Theme.of(context).copyWith(iconTheme: IconThemeData(color: Theme.of(context).primaryColor)),
                  child: BottomAppBar(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: bottomActions!,
                      ),
                    ),
                  ),
                )
              : null),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget? _getLeading(BuildContext context) {
    return Navigator.of(context).canPop()
        ? IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(Icons.chevron_left),
          )
        : null;
  }
}
