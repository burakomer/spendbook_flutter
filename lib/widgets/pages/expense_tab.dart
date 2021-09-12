import 'package:dwarf_flutter/domain/cubit/model_cubit.dart';
import 'package:dwarf_flutter/theme/app_theme.dart';
import 'package:dwarf_flutter/utils/extensions.dart';
import 'package:dwarf_flutter/widgets/components/generic_badge.dart';
import 'package:dwarf_flutter/widgets/components/loading_indicator.dart';
import 'package:dwarf_flutter/widgets/components/refreshable.dart';
import 'package:dwarf_flutter/widgets/pages/tab_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../data/models/expense.dart';
import '../../domain/expense/expense_cubit.dart';
import '../../locator.dart';
import 'expense_detail_page.dart';
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
        // IconButton(
        //   icon: Icon(Icons.filter_alt),
        //   onPressed: () => showTallBottomSheet(
        //     context: context,
        //     content: Column(),
        //   ),
        // ),
      ],
      floatingActionButton: FloatingActionButton(
        child: Icon(CupertinoIcons.add), //Icon(Icons.add_rounded),
        onPressed: () => Navigator.of(context).pushNamed(
          ExpenseDetailPage.routeName,
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
          return _buildList(context, state);
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

  Widget _buildList(BuildContext context, ExpensesReady state) {
    final groupByDay = true;
    pulledDownToRefresh = false;

    return Refreshable(
      onRefresh: () async {
        await expenseCubit.load(emitLoading: false);
        pulledDownToRefresh = true;
      },
      // child: ListView.builder(
      //   physics: AlwaysScrollableScrollPhysics(),
      //   padding: EdgeInsets.zero,
      //   itemCount: state.models.length,
      //   itemBuilder: (context, index) => _buildListItem(context, index, state.models[index]),
      // ),
      child: GroupedListView<Expense, DateTime>(
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        elements: state.models,
        groupBy: (element) => element.createTime.getDatePart(day: groupByDay),
        sort: false,
        groupSeparatorBuilder: (date) => Material(
          color: Colors.transparent,
          // color: Theme.of(context).scaffoldBackgroundColor,
          // elevation: 0.5,
          shape: Theme.of(context).appBarTheme.shape,
          child: Material(
            color: AppTheme.getCurrentModeColor(context, darkAccent: true),
            elevation: Theme.of(context).appBarTheme.elevation ?? 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // GenericBadge(elevation: 1, outlined: false, backgroundColor: Theme.of(context).scaffoldBackgroundColor, text: "${date.mediumDateFormat}"),
                  // SizedBox(width: 8.0),
                  // GenericBadge(elevation: 1, outlined: false, backgroundColor: Theme.of(context).scaffoldBackgroundColor, text: "${state.models.where((element) => element.createTime.getDatePart(day: groupByDay) == date).map((e) => e.price).reduce((value, e) => value + e).toStringWithOptions(leading: "₺ ")}"),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          //date.longMonthFormat,
                          date.mediumDateFormat,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          state.models.where((element) => element.createTime.getDatePart(day: groupByDay) == date).map((e) => e.price).reduce((value, e) => value + e).toStringWithOptions(leading: "₺ "),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        stickyHeaderBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // stickyHeaderBackgroundColor: Colors.transparent,
        indexedItemBuilder: (context, item, index) => _buildListItem(context, index, item),
        useStickyGroupSeparators: true,
        // floatingHeader: true,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index, Expense item) {
    final categoryText = Text(item.categoryName, style: TextStyle(color: item.categoryColor));
    final category = GenericBadge(
      color: item.categoryColor ?? Theme.of(context).cardTheme.color!,
      // text: item.categoryName,
      // textStyle: TextStyle(color: item.categoryColor.contrastingTextColor()),
      child: categoryText,
    );

    final priceText = Text("${item.price.toStringWithOptions(leading: "₺ ")}");

    return ListTile(
      visualDensity: VisualDensity.compact,
      horizontalTitleGap: 8.0,
      // trailing: Icon(AppTheme.of(context).icons.chevronRight),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${item.name}"),
          priceText,
          // categoryText,
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${item.createTime.longDateFormatWithTime}"),
          // category,
          categoryText,
          // priceText,
        ],
      ),
      onTap: () => Navigator.of(context).pushNamed(
        ExpenseDetailPage.routeName,
        arguments: item,
      ),
    );
  }
}
