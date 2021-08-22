import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_scaffold.dart';
import 'main_page.dart';

class SummaryTab extends StatefulWidget {
  SummaryTab({Key? key}) : super(key: key);

  @override
  _SummaryTabState createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: describeEnum(MainPageTabs.Summary),
      body: Container(
         child: null,
      ),
    );
  }
}