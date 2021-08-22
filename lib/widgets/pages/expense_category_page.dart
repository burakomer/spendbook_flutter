import 'package:flutter/material.dart';

import 'app_scaffold.dart';

class ExpenseCategoryPage extends StatefulWidget {
  ExpenseCategoryPage({Key? key}) : super(key: key);

  @override
  _ExpenseCategoryPageState createState() => _ExpenseCategoryPageState();
}

class _ExpenseCategoryPageState extends State<ExpenseCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: "Expense Categories", body: Container());
  }
}
