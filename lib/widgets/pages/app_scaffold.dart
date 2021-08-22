import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const AppScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            forceElevated: innerBoxIsScrolled,
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
          ),
        ],
        body: body,
      ),
    );
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
