import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'expense_page.dart';
import 'settings_page.dart';
import 'summary_page.dart';

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
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tabIndex,
        children: _buildTabs(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (value) => setState(() => _tabIndex = value),
        items: [
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.chartPie), label: describeEnum(MainPageTabs.Summary)),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.moneyBill), label: describeEnum(MainPageTabs.Expenses)),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.cog), label: describeEnum(MainPageTabs.Settings)),
        ],
      ),
    );
  }

  List<Widget> _buildTabs() {
    return [
      SummaryTab(),
      ExpenseTab(),
      SettingsTab(),
    ];
  }
}
