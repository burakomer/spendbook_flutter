import 'package:dwarf_flutter/widgets/pages/tab_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../data/db/app_database.dart';
import 'expense_category_page.dart';
import 'main_page.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({Key? key}) : super(key: key);

  @override
  _SettingsTabState createState() => _SettingsTabState();

  static TabScaffold getTabScaffold(BuildContext context) {
    return TabScaffold(
      title: describeEnum(MainPageTabs.Settings),
      body: SettingsTab(),
    );
  }
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(title: Text("Definitions", style: Theme.of(context).textTheme.headline6), visualDensity: VisualDensity.compact),
        ListTile(
          leading: Icon(Icons.category),
          title: Text("Expense Categories"),
          onTap: () => Navigator.of(context).pushNamed(ExpenseCategoryPage.routeName),
        ),
        ListTile(title: Text("General", style: Theme.of(context).textTheme.headline6), visualDensity: VisualDensity.compact),
        ListTile(
          leading: Icon(Icons.ios_share),
          title: Text("Save Database"),
          onTap: () async => await AppDatabase.shareDatabase(),
        ),

        // ListTile(
        //   leading: Icon(Icons.download_rounded),
        //   title: Text("Import Database"),
        //   onTap: () async => await AppDatabase.importDatabase(context),
        // ),
      ],
    );
  }
}
