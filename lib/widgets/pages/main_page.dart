import 'package:dwarf_flutter/config/localization.dart';
import 'package:dwarf_flutter/theme/app_theme.dart';
import 'package:dwarf_flutter/widgets/pages/tab_page_scaffold.dart';
import 'package:dwarf_flutter/widgets/pages/tab_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'expense_tab.dart';
import 'settings_tab.dart';
import 'summary_tab.dart';

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
  var _summaryMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TabPageScaffold(
      initialTab: 1,
      tabBuilder: _buildTabs,
      tabButtons: [
        BottomNavigationBarItem(icon: Icon(AppTheme.of(context).icons.pieChart), label: getStr(context, "summary")),
        BottomNavigationBarItem(icon: Icon(AppTheme.of(context).icons.receiptLong), label: getStr(context, "expenses")),
        BottomNavigationBarItem(icon: Icon(AppTheme.of(context).icons.settings), label: getStr(context, "settings")),
      ],
    );
  }

  List<TabScaffold> _buildTabs(BuildContext context) {
    return [
      SummaryTab.getTabScaffold(
        context,
        initialMonth: _summaryMonth,
        onSelectMonth: (date) {
          setState(() {
            _summaryMonth = date;
          });
        },
      ),
      ExpenseTab.getTabScaffold(context),
      SettingsTab.getTabScaffold(context),
    ];
  }
}
