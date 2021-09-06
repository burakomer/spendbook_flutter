import 'package:dwarf_flutter/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';

class ExpenseCategoryPage extends StatefulWidget {
  ExpenseCategoryPage({Key? key}) : super(key: key);

  @override
  _ExpenseCategoryPageState createState() => _ExpenseCategoryPageState();
}

class _ExpenseCategoryPageState extends State<ExpenseCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Expense Categories",
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container();
    // return ListView.builder(
    //   padding: EdgeInsets.zero,
    //   itemCount: expenses.length,
    //   itemBuilder: (context, index) => buildListItem(context, index, expenses[index]),
    // );
  }
}
