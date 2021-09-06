import 'package:dwarf_flutter/domain/cubit/model_cubit.dart';
import 'package:dwarf_flutter/utils/extensions.dart';
import 'package:dwarf_flutter/utils/helpers.dart';
import 'package:dwarf_flutter/widgets/components/loading_indicator.dart';
import 'package:dwarf_flutter/widgets/pages/tab_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/expense.dart';
import '../../domain/expense/expense_cubit.dart';
import '../../locator.dart';
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
  final expenseCubit = getIt<ExpenseCubit>();

  bool pulledDownToRefresh = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ModelState>(
      bloc: expenseCubit,
      builder: (context, state) {
        if (state is ExpensesReady) {
          pulledDownToRefresh = false;
          return RefreshIndicator(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: state.models.length,
              itemBuilder: (context, index) => buildListItem(context, index, state.models[index]),
            ),
            onRefresh: () async {
              await expenseCubit.load(emitLoading: false);
              pulledDownToRefresh = true;
            },
          );
        } else if (state is ExpensesError) {
          return Center(child: Text(state.message));
        } else if (state is ExpensesLoading) {
          return pulledDownToRefresh ? SizedBox() : LoadingIndicator(center: true);
        } else {
          expenseCubit.load();
          return LoadingIndicator(center: true);
        }
      },
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
          Text("${item.price.toStringWithOptions(leading: "₺ ")}"), // TODO: Make leading configurable.
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text("${item.categoryName}"), Text("${item.createTime.longDateFormat}")],
      ),
      onTap: () => Navigator.of(context).pushNamed(
        "/expense_detail",
        arguments: item,
      ),
    );
  }
}
