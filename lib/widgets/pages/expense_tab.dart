import 'package:animations/animations.dart';
import 'package:dwarf_flutter/config/localization.dart';
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
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:collection/collection.dart';
import 'package:sliver_tools/sliver_tools.dart';

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
    final expenseCubit = getIt<ExpenseCubit>();

    return TabScaffold(
      title: getStr(context, "expenses"),
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
      floatingActionButton: OpenContainer(
        transitionDuration: Duration(milliseconds: 350),
        closedShape: CircleBorder(),
        closedColor: Theme.of(context).colorScheme.primary,
        closedElevation: 6,
        closedBuilder: (context, openContainer) {
          return FloatingActionButton(
            // mini: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Icon(CupertinoIcons.add), //Icon(Icons.add_rounded),
            onPressed: openContainer,
          );
        },
        openBuilder: (context, closedContainer) {
          return ExpenseDetailPage(item: Expense.create());
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(CupertinoIcons.add), //Icon(Icons.add_rounded),
      //   onPressed: () => Navigator.of(context).pushNamed(
      //     ExpenseDetailPage.routeName,
      //     arguments: Expense.create(),
      //   ),
      // ),
      refreshable: true,
      onRefresh: () async {
        await expenseCubit.load(emitLoading: false);
        // pulledDownToRefresh = true;
      },
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
          return _buildSliverList(context, state);
          // return _buildList(context, state);
        } else if (state is ExpensesError) {
          return Center(child: Text(state.message));
        }
        // else if (state is ExpensesLoading) {
        //   return pulledDownToRefresh ? SizedBox() : LoadingIndicator(center: true);
        // }
        else {
          expenseCubit.load();
          return SliverToBoxAdapter(child: LoadingIndicator());
          // return LoadingIndicator(center: true);
        }
      },
    );
  }

  Widget _buildSliverList(BuildContext context, ExpensesReady state) {
    final groupByDay = true;
    pulledDownToRefresh = false;

    final groupedList = state.models.groupListsBy((e) => e.createTime.getDatePart(day: groupByDay));

    // return SliverList(
    //   delegate: SliverChildBuilderDelegate(
    //     (context, index) => _buildListItem(context, index, state.models[index]),
    //     childCount: state.models.length,
    //   ),
    // );

    return MultiSliver(
      children: groupedList.entries.map(
        (e) {
          final date = e.key;
          final items = e.value;
          return SliverStickyHeader(
            header: Container(
              height: 60.0,
              // color: (headerState.isPinned ? Colors.pink : Colors.lightBlue).withOpacity(1.0 - headerState.scrollPercentage),
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              alignment: Alignment.centerLeft,
              child: Card(
                elevation: 1.5,
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => _buildListItem(context, i, items[i]),
                childCount: items.length,
              ),
            ),
          );
        },
      ).toList(),
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
        // primary: false,
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // GenericBadge(elevation: 1, outlined: false, backgroundColor: Theme.of(context).scaffoldBackgroundColor, text: "${date.mediumDateFormat}"),
                // SizedBox(width: 8.0),
                // GenericBadge(elevation: 1, outlined: false, backgroundColor: Theme.of(context).scaffoldBackgroundColor, text: "${state.models.where((element) => element.createTime.getDatePart(day: groupByDay) == date).map((e) => e.price).reduce((value, e) => value + e).toStringWithOptions(leading: "₺ ")}"),
                Expanded(
                  child: Card(
                    elevation: 1.5,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                  ),
                ),
              ],
            ),
          ),
        ),
        // stickyHeaderBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        stickyHeaderBackgroundColor: Colors.transparent,
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

    return OpenContainer(
      transitionDuration: Duration(milliseconds: 350),
      closedColor: AppTheme.getCurrentModeColor(context),
      openColor: AppTheme.getCurrentModeColor(context),
      closedElevation: 0.0,
      openElevation: 0.0,
      closedBuilder: (context, openContainer) {
        return ListTile(
          // visualDensity: VisualDensity.compact,
          // horizontalTitleGap: 8.0,
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
          onTap: () => openContainer(),
        );
      },
      openBuilder: (context, closedContainer) {
        return ExpenseDetailPage(item: item);
      },
    );

    // return ListTile(
    //   visualDensity: VisualDensity.compact,
    //   horizontalTitleGap: 8.0,
    //   // trailing: Icon(AppTheme.of(context).icons.chevronRight),
    //   title: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Text("${item.name}"),
    //       priceText,
    //       // categoryText,
    //     ],
    //   ),
    //   subtitle: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Text("${item.createTime.longDateFormatWithTime}"),
    //       // category,
    //       categoryText,
    //       // priceText,
    //     ],
    //   ),
    //   onTap: () => Navigator.of(context).pushNamed(
    //     ExpenseDetailPage.routeName,
    //     arguments: item,
    //   ),
    // );
  }
}
