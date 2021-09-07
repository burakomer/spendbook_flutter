import 'package:dwarf_flutter/domain/cubit/model_cubit.dart';
import 'package:dwarf_flutter/widgets/components/app_scaffold.dart';
import 'package:dwarf_flutter/widgets/components/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/expense_category.dart';
import '../../domain/expense_category/expense_category_cubit.dart';
import '../../locator.dart';
import 'expense_category_detail_page.dart';

class ExpenseCategoryPage extends StatefulWidget {
  static const routeName = "/expense_category";

  final bool pickerMode;

  ExpenseCategoryPage({
    Key? key,
    this.pickerMode = false,
  }) : super(key: key);

  @override
  _ExpenseCategoryPageState createState() => _ExpenseCategoryPageState();
}

class _ExpenseCategoryPageState extends State<ExpenseCategoryPage> {
  final expenseCategoryCubit = getIt<ExpenseCategoryCubit>();

  bool pulledDownToRefresh = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Expense Categories",
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_rounded),
        onPressed: () => Navigator.of(context).pushNamed(
          ExpenseCategoryDetailPage.routeName,
          arguments: ExpenseCategory.create(),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<ExpenseCategoryCubit, ModelState>(
      bloc: expenseCategoryCubit,
      builder: (context, state) {
        if (state is ExpenseCategorysReady) {
          pulledDownToRefresh = false;
          return RefreshIndicator(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: state.models.length,
              itemBuilder: (context, index) => buildListItem(context, index, state.models[index]),
            ),
            onRefresh: () async {
              await expenseCategoryCubit.load(emitLoading: false);
              pulledDownToRefresh = true;
            },
          );
        } else if (state is ExpenseCategorysError) {
          return Center(child: Text(state.message));
        } else if (state is ExpenseCategorysLoading) {
          return pulledDownToRefresh ? SizedBox() : LoadingIndicator(center: true);
        } else {
          expenseCategoryCubit.load();
          return LoadingIndicator(center: true);
        }
      },
    );
  }

  Widget buildListItem(BuildContext context, int index, ExpenseCategory item) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      horizontalTitleGap: 8.0,
      trailing: Icon(Icons.chevron_right_rounded),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${index + 1}. ${item.name}"),
        ],
      ),
      // subtitle: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [],
      // ),
      onTap: () => widget.pickerMode
          ? Navigator.of(context).pop(item)
          : Navigator.of(context).pushNamed(
              ExpenseCategoryDetailPage.routeName,
              arguments: item,
            ),
    );
  }
}
