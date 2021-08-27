import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? bottomBar;
  final List<Widget>? actions;
  final List<Widget>? bottomActions;

  final bool hasScaffold;

  const AppScaffold({
    Key? key,
    this.title = "",
    required this.body,
    this.bottomBar,
    this.actions,
    this.bottomActions,
  })  : hasScaffold = false,
        super(key: key);

  const AppScaffold.tab({
    Key? key,
    this.title = "",
    required this.body,
    this.bottomBar,
    this.actions,
    this.bottomActions,
  })  : hasScaffold = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    final blurFilter = ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0);

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
      extendBody: true,
      extendBodyBehindAppBar: true,
      //resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        child: Container(
          child: ClipRRect(
            child: BackdropFilter(
              filter: blurFilter,
              child: appBar,
            ),
          ),
        ),
        preferredSize: Size.fromHeight(appBar.preferredSize.height),
      ),
      body: _getBody(context, appBar.preferredSize.height),
      bottomNavigationBar: bottomBar != null || bottomActions != null
          ? Container(
              child: ClipRRect(
                child: BackdropFilter(
                  filter: blurFilter,
                  child: bottomBar ??
                      Theme(
                        data: Theme.of(context).copyWith(iconTheme: IconThemeData(color: Theme.of(context).primaryColor)),
                        child: BottomAppBar(
                          child: Row(
                            children: bottomActions!,
                          ),
                        ),
                      ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _getBody(BuildContext context, double appBarHeight) {
    final topPadding = appBarHeight + MediaQuery.of(context).padding.top;
    return body;
    // : Container(
    //     padding: EdgeInsets.only(top: topPadding),
    //     child: body,
    //   );
  }

  Widget? _getLeading(BuildContext context) {
    return Navigator.of(context).canPop()
        ? IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: FaIcon(FontAwesomeIcons.chevronLeft),
          )
        : null;
  }
}
