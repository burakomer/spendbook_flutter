import 'package:flutter/material.dart';
import 'package:kuma_app/widgets/pages/app_scaffold.dart';
import 'package:kuma_app/widgets/pages/tab_scaffold.dart';

class TabPageScaffold extends StatefulWidget {
  final List<TabScaffold> Function(BuildContext) tabBuilder;
  final List<BottomNavigationBarItem> tabButtons;

  TabPageScaffold({
    Key? key,
    required this.tabBuilder,
    required this.tabButtons,
  }) : super(key: key);

  @override
  _TabPageScaffoldState createState() => _TabPageScaffoldState();
}

class _TabPageScaffoldState extends State<TabPageScaffold> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = widget.tabBuilder(context);
    final currentTab = tabs[_tabIndex];
    return AppScaffold(
      title: currentTab.title,
      body: IndexedStack(
        index: _tabIndex,
        children: tabs.map((e) => e.body).toList(),
      ),
      actions: currentTab.actions,
      bottomBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (value) => setState(() => _tabIndex = value),
        items: widget.tabButtons,
      ),
    );
  }
}
