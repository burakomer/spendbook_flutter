import 'package:collection/collection.dart';
import 'package:dwarf_flutter/config/localization.dart';
import 'package:dwarf_flutter/domain/cubit/model_cubit.dart';
import 'package:dwarf_flutter/theme/app_theme.dart';
import 'package:dwarf_flutter/utils/extensions.dart';
import 'package:dwarf_flutter/widgets/components/generic_badge.dart';
import 'package:dwarf_flutter/widgets/components/loading_indicator.dart';
import 'package:dwarf_flutter/widgets/components/refreshable.dart';
import 'package:dwarf_flutter/widgets/pages/tab_scaffold.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/expense.dart';
import '../../domain/expense/expense_cubit.dart';
import '../../locator.dart';
import 'main_page.dart';

class SummaryTab extends StatefulWidget {
  final DateTime month;

  SummaryTab({
    Key? key,
    required this.month,
  }) : super(key: key);

  @override
  _SummaryTabState createState() => _SummaryTabState();

  static TabScaffold getTabScaffold(
    BuildContext context, {
    required void Function(DateTime) onSelectMonth,
    required DateTime initialMonth,
  }) {
    final expenseCubit = getIt<ExpenseCubit>();

    return TabScaffold(
      title: "${getStr(context, "summary")} - ${initialMonth.mediumMonthFormat}",
      body: SummaryTab(month: initialMonth),
      actions: [
        IconButton(
          icon: Icon(AppTheme.of(context).icons.calendar),
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: initialMonth,
              firstDate: DateTime(2021),
              lastDate: DateTime.now(),
            );
            if (date != null) onSelectMonth(date);
          },
        ),
      ],
      floatingActionButton: !initialMonth.isSameDate(DateTime.now(), day: false)
          ? FloatingActionButton(
              // label: Text("This Month"),
              child: Icon(AppTheme.of(context).icons.calendarToday),
              onPressed: () async {
                onSelectMonth(DateTime.now());
              },
            )
          : null,
      refreshable: true,
      onRefresh: () async {
        await expenseCubit.load(emitLoading: false);
      },
    );
  }
}

class _SummaryTabState extends State<SummaryTab> {
  final expenseCubit = getIt<ExpenseCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ModelState>(
      bloc: expenseCubit,
      builder: (context, state) {
        if (state is ExpensesReady) {
          return _buildList(context, state);
        } else if (state is ExpensesError) {
          return Center(child: Text(state.message));
        } 
        // else if (state is ExpensesLoading) {
        //   return pulledDownToRefresh ? SizedBox() : LoadingIndicator(center: true);
        // } 
        else {
          expenseCubit.load(); // TODO: Filter the month only.
          return LoadingIndicator(center: true);
        }
      },
    );
  }

  Widget _buildList(BuildContext context, ExpensesReady state) {
    final models = state.models.where((element) => element.createTime.mediumMonthFormat == widget.month.mediumMonthFormat).toList();
    if (models.isEmpty) {
      final height = MediaQuery.of(context).size.height / 3;
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(top: height),
          child: Column(
            children: [
              Icon(Icons.money_off_rounded, size: 32.0),
              SizedBox(height: 4.0),
              Text("No Data", style: Theme.of(context).textTheme.headline6),
            ],
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: models
                  .groupListsBy(
                    (element) => element.categoryId,
                  )
                  .values
                  .map(
                (byCategory) {
                  return Row(
                    children: [
                      GenericBadge(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                        text: byCategory[0].categoryName,
                        color: byCategory[0].categoryColor,
                      ),
                      SizedBox(width: 8.0),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
          _buildPieChart(context, models),
        ],
      ),
    );
    // return ListView(
    //   primary: false,
    //   physics: AlwaysScrollableScrollPhysics(),
    //   children: [],
    // );
  }

  Widget _buildPieChart(BuildContext context, List<Expense> expenses) {
    final fontSize = 16.0;
    final radius = 80.0;

    final totalMonthExpense = expenses.map((e) => e.price).reduce((value, element) => value + element);

    return Container(
      height: 400.0,
      child: Stack(
        children: [
          Center(
            child: Text(
              totalMonthExpense.toStringWithOptions(leading: "₺ "),
              style: TextStyle(fontSize: fontSize + 8.0, fontWeight: FontWeight.bold),
            ),
          ),
          PieChart(
            PieChartData(
              // startDegreeOffset: 180,
              borderData: FlBorderData(show: false),
              sectionsSpace: 8.0,
              centerSpaceRadius: 80.0, //double.infinity,
              sections: expenses
                  .groupListsBy(
                    (element) => element.categoryId,
                  )
                  .values
                  .map(
                (byCategory) {
                  final totalCategoryExpense = byCategory.map((e) => e.price).reduce((value, element) => value + element);
                  final categoryColor = byCategory[0].categoryColor;
                  final categoryName = byCategory[0].categoryName;
                  return PieChartSectionData(
                    badgeWidget: GenericBadge(
                      color: AppTheme.getCurrentModeColor(context, darkAccent: true),
                      outlined: false,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      text: totalCategoryExpense.toStringWithOptions(leading: "₺ "),
                      textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
                    ),
                    // badgeWidget: GenericBadge(text: categoryName),
                    // badgePositionPercentageOffset: -0.3,
                    badgePositionPercentageOffset: 1,
                    title: "",
                    // borderSide: BorderSide(width: 10.0, color: categoryColor ?? Colors.transparent),
                    value: totalCategoryExpense,
                    // title: totalExpense.toStringWithOptions(leading: "₺ "),
                    color: categoryColor,
                    radius: radius,
                    titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
                  );
                },
              ).toList(),
            ),
            swapAnimationDuration: Duration(milliseconds: 150), // Optional
            swapAnimationCurve: Curves.bounceOut, // Optional
          ),
        ],
      ),
    );
  }
}
