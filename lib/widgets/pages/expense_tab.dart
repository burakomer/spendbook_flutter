import 'package:dwarf_flutter/utils/extensions.dart';
import 'package:dwarf_flutter/utils/helpers.dart';
import 'package:dwarf_flutter/widgets/pages/tab_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../data/models/expense.dart';
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
          icon: Icon(Icons.filter_alt),
          onPressed: () => showTallBottomSheet(
            context: context,
            content: Column(),
          ),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_rounded),
        onPressed: () => Navigator.of(context).pushNamed(
          "/expense_detail",
          arguments: Expense.create(),
        ),
      ),
    );
  }
}

class _ExpenseTabState extends State<ExpenseTab> {
  final expenses = [
    Expense(id: 1, name: "Starbucks Latte", categoryId: 0, categoryName: "Icecek", price: 15.0),
    Expense(id: 2, name: "Otobus", categoryId: 0, categoryName: "Ulasim", price: 4.0),
    Expense(id: 3, name: "Gomlek", categoryId: 0, categoryName: "Giyim", price: 79.90),
    Expense(id: 4, name: "Market Alisverisi", categoryId: 0, categoryName: "Temel Ihtiyac", price: 127.25),
    Expense(id: 5, name: "Eczane", categoryId: 0, categoryName: "Temel Ihtiyac", price: 29.5),
    Expense(id: 6, name: "Kargo", categoryId: 0, categoryName: "Diger", price: 16.9),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: expenses.length,
      itemBuilder: (context, index) => Slidable(
        child: buildListItem(context, index, expenses[index]),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
        secondaryActions: <Widget>[
          IconSlideAction(
            //caption: 'Delete',
            color: Colors.red,
            foregroundColor: Colors.white,
            //icon: Icons.delete,
            iconWidget: Icon(Icons.delete, color: Colors.white),
            onTap: () {},
          ),
        ],
      ),
      // separatorBuilder: (context, index) => Container(
      //   height: 1.0,
      //   color: Theme.of(context).dividerColor,
      // ),
    );
  }

  Widget buildListItem(BuildContext context, int index, Expense item) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      horizontalTitleGap: 8.0,
      trailing: Icon(Icons.chevron_right_rounded),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${index + 1}. ${item.name}"),
          Text("${item.price.toStringWithOptions(trailing: " ₺")}"),
        ],
      ),
      subtitle: Text("${item.categoryName}"),
      onTap: () => Navigator.of(context).pushNamed(
        "/expense_detail",
        arguments: expenses[index],
      ),
    );
  }
}
