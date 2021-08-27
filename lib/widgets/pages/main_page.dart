import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kuma_app/data/models/expense.dart';
import 'package:kuma_app/widgets/pages/tab_page_scaffold.dart';
import 'package:kuma_app/widgets/pages/tab_scaffold.dart';

import 'app_scaffold.dart';
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
  @override
  Widget build(BuildContext context) {
    return TabPageScaffold(
      tabBuilder: _buildTabs,
      tabButtons: [
        BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.chartPie), label: describeEnum(MainPageTabs.Summary)),
        BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.moneyBill), label: describeEnum(MainPageTabs.Expenses)),
        BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.cog), label: describeEnum(MainPageTabs.Settings)),
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
