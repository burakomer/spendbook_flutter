import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kuma_app/widgets/pages/tab_scaffold.dart';

import 'app_scaffold.dart';
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
    return Container();
  }
}
