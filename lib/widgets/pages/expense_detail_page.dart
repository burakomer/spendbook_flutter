import 'package:flutter/material.dart';

import '../../data/models/expense.dart';
import '../../data/models/expense_category.dart';
import '../input/generic_text_field.dart';
import '../input/model_selection_field.dart';
import 'base/base_detail_page.dart';
import 'expense_category_page.dart';

class ExpenseDetailPage extends BaseDetailPage {
  final Expense item;

  ExpenseDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  _ExpenseDetailPageState createState() => _ExpenseDetailPageState(item);
}

class _ExpenseDetailPageState extends BaseDetailPageState<ExpenseDetailPage> {
  final Expense item;

  late int _id;
  late int _categoryId;
  late String _categoryName;

  _ExpenseDetailPageState(this.item) {
    _id = item.id;
    _categoryId = item.categoryId;
    _categoryName = item.categoryName;
  }

  @override
  List<Widget> buildFields() {
    return [
      ModelSelectionField<ExpenseCategoryPage>(
        labelText: "Category",
        initialId: _categoryId,
        initialValue: _categoryName,
        routeName: "/expense_category",
        iconMapper: ExpenseCategory.getIcon,
        onSelected: (value) {},
      ),
      GenericTextField(
        labelText: "Info",
        initialValue: "",
        onSaved: (value) {},
      ),
    ];
  }
}
