import 'package:collection/collection.dart';
import 'package:dwarf_flutter/domain/cubit/model_cubit.dart';
import 'package:dwarf_flutter/utils/extensions.dart';
import 'package:dwarf_flutter/widgets/components/generic_badge.dart';
import 'package:dwarf_flutter/widgets/components/loading_indicator.dart';
import 'package:dwarf_flutter/widgets/pages/tab_scaffold.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/expense.dart';
import '../../domain/expense/expense_cubit.dart';
import '../../locator.dart';
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
    return RefreshIndicator(
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: state.models
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
                        elevation: Theme.of(context).cardTheme.elevation ?? 8.0,
                      ),
                      SizedBox(width: 8.0),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
          _buildPieChart(context, state.models),
        ],
      ),
      onRefresh: () async {
        await expenseCubit.load(emitLoading: false);
        pulledDownToRefresh = true;
      },
    );
  }

  Widget _buildPieChart(BuildContext context, List<Expense> expenses) {
    pulledDownToRefresh = false;

    final fontSize = 16.0;
    final radius = 80.0;
    final widgetSize = 40.0;

    return Container(
      height: 400.0,
      child: PieChart(
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
              final totalExpense = byCategory.map((e) => e.price).reduce((value, element) => value + element);
              final categoryColor = byCategory[0].categoryColor;
              final categoryName = byCategory[0].categoryName;
              return PieChartSectionData(
                badgeWidget: GenericBadge(
                  text: totalExpense.toStringWithOptions(leading: "₺ "),
                  textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
                ),
                // badgeWidget: GenericBadge(text: categoryName),
                // badgePositionPercentageOffset: -0.3,
                badgePositionPercentageOffset: 1,
                title: "",
                borderSide: BorderSide(width: 10.0, color: categoryColor ?? Colors.transparent),
                value: totalExpense,
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
    );
  }
}
