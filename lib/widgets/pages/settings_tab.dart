import 'package:dwarf_flutter/config/localization.dart';
import 'package:dwarf_flutter/theme/app_theme.dart';
import 'package:dwarf_flutter/widgets/pages/tab_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../data/db/app_database.dart';
import 'expense_category_page.dart';
import 'main_page.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({Key? key}) : super(key: key);

  @override
  _SettingsTabState createState() => _SettingsTabState();

  static TabScaffold getTabScaffold(BuildContext context) {
    return TabScaffold(
      title: getStr(context, "settings"),
      body: SettingsTab(),
    );
  }
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      horizontalTitleGap: 0,
      child: MultiSliver(
        children: [
          ListTile(title: Text(getStr(context, "definitions"), style: Theme.of(context).textTheme.headline6), visualDensity: VisualDensity.compact),
          ListTile(
            leading: Icon(AppTheme.of(context).icons.category),
            title: Text(getStr(context, "expense_categories")),
            onTap: () => Navigator.of(context).pushNamed(ExpenseCategoryPage.routeName),
          ),
          ListTile(title: Text(getStr(context, "general"), style: Theme.of(context).textTheme.headline6), visualDensity: VisualDensity.compact),
          ListTile(
            leading: Icon(AppTheme.of(context).icons.share),
            title: Text(getStr(context, "save_database")),
            onTap: () async => await AppDatabase.shareDatabase(),
          ),
    
          // ListTile(
          //   leading: Icon(Icons.download_rounded),
          //   title: Text("Import Database"),
          //   onTap: () async => await AppDatabase.importDatabase(context),
          // ),
        ],
      ),
    );
  }
}
