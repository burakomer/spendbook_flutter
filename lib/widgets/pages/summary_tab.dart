import 'package:dwarf_flutter/widgets/pages/tab_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'main_page.dart';

class SummaryTab extends StatefulWidget {
  SummaryTab({Key? key}) : super(key: key);

  @override
  _SummaryTabState createState() => _SummaryTabState();

  static TabScaffold getTabScaffold(BuildContext context) {
    return TabScaffold(
      title: describeEnum(MainPageTabs.Summary),
      body: SummaryTab(),
    );
  }
}

class _SummaryTabState extends State<SummaryTab> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
