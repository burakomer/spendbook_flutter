import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'expense_tab.dart';
import 'settings_tab.dart';
import 'summary_tab.dart';
import 'tab_page_scaffold.dart';
import 'tab_scaffold.dart';

enum MainPageTabs {
  Summary,
  Expenses,
  Settings,
}

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return TabPageScaffold(
      tabBuilder: _buildTabs,
      tabButtons: [
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: describeEnum(MainPageTabs.Summary)),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: describeEnum(MainPageTabs.Expenses)),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: describeEnum(MainPageTabs.Settings)),
      ],
    );
  }

  List<TabScaffold> _buildTabs(BuildContext context) {
    return [
      SummaryTab.getTabScaffold(context),
      ExpenseTab.getTabScaffold(context),
      SettingsTab.getTabScaffold(context),
    ];
  }
}