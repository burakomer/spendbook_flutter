import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_scaffold.dart';
import 'main_page.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({Key? key}) : super(key: key);

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: describeEnum(MainPageTabs.Settings),
      body: Container(),
    );
  }
}
