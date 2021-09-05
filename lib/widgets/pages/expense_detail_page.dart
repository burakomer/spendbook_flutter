import 'package:dwarf_flutter/widgets/forms/generic_text_field.dart';
import 'package:dwarf_flutter/widgets/forms/model_form.dart';
import 'package:dwarf_flutter/widgets/forms/model_selection_field.dart';
import 'package:dwarf_flutter/widgets/pages/simple_detail_page.dart';
import 'package:flutter/material.dart';

import '../../data/models/expense.dart';
import '../../data/models/expense_category.dart';

class ExpenseDetailPage extends StatefulWidget {
  final Expense item;

  ExpenseDetailPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _ExpenseDetailPageState createState() => _ExpenseDetailPageState(item);
}

class _ExpenseDetailPageState extends State<ExpenseDetailPage> {
  final Expense item;
  final formKey = GlobalKey<ModelFormState>();

  late int _id;
  late String _name;
  late int _categoryId;
  late String _categoryName;
  late double _price;

  Expense get currentModel => Expense(
        id: _id,
        name: _name,
        categoryId: _categoryId,
        categoryName: _categoryName,
        price: _price,
      );

  _ExpenseDetailPageState(this.item) {
    _id = item.id;
    _name = item.name;
    _categoryId = item.categoryId;
    _categoryName = item.categoryName;
    _price = item.price;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDetailPage(
      formKey: formKey,
      item: item,
      fields: _buildFields(),
      actionRow: _buildActionRow(),
      getCurrentModel: () => currentModel,
    );
  }

  List<Widget> _buildFields() {
    final name = GenericTextField(
      labelText: "Name",
      initialValue: _name,
      required: true,
      onSaved: (value) {
        _name = value;
      },
    );

    final category = ModelSelectionField<ExpenseCategory>(
      labelText: "Category",
      initialId: _categoryId,
      initialValue: _categoryName,
      routeName: "/expense_category",
      //iconMapper: ExpenseCategory.getIcon,
      onSelected: (value) {
        setState(() {
          _categoryId = value.id;
          _categoryName = value.name;
        });
      },
    );

    final price = GenericTextField(
      labelText: "Price",
      initialValue: _price.toString(),
      required: true,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onSaved: (value) {
        _name = value;
      },
    );

    return [
      name,
      category,
      price,
    ];
  }

  Widget _buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton.icon(
          icon: Icon(Icons.save),
          label: Text("Save"),
          onPressed: () => formKey.currentState!.submit(),
        ),
      ],
    );
  }
}
