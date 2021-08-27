import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kuma_app/widgets/pages/tab_scaffold.dart';

import '../../data/models/expense.dart';
import 'app_scaffold.dart';
import 'main_page.dart';

class ExpenseTab extends StatefulWidget {
  ExpenseTab({Key? key}) : super(key: key);

  @override
  _ExpenseTabState createState() => _ExpenseTabState();

  static TabScaffold getTabScaffold(BuildContext context) {
    return TabScaffold(
      title: describeEnum(MainPageTabs.Expenses),
      body: ExpenseTab(),
      actions: [
        IconButton(
          icon: FaIcon(FontAwesomeIcons.filter),
          onPressed: () {},
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.plusCircle),
          onPressed: () => Navigator.of(context).pushNamed(
            "/expense_detail",
            arguments: Expense.create(),
          ),
        ),
      ],
    );
  }
}

class _ExpenseTabState extends State<ExpenseTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) => ListTile(
        title: Text("$index. Item"),
      ),
    );
  }
}
