import 'package:dwarf_flutter/domain/cubit/model_cubit.dart';
import 'package:dwarf_flutter/utils/extensions.dart';
import 'package:dwarf_flutter/widgets/components/app_scaffold.dart';
import 'package:dwarf_flutter/widgets/components/loading_indicator.dart';
import 'package:dwarf_flutter/widgets/forms/generic_text_field.dart';
import 'package:dwarf_flutter/widgets/forms/model_form.dart';
import 'package:dwarf_flutter/widgets/forms/model_selection_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/expense.dart';
import '../../data/models/expense_category.dart';
import '../../domain/expense/expense_cubit.dart';
import '../../locator.dart';
import 'expense_category_page.dart';

class ExpenseDetailPage extends StatefulWidget {
  static const routeName = "/expense_detail";

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
  final expenseCubit = getIt<ExpenseCubit>();

  final _categoryController = TextEditingController();

  bool isSaving = false;
  late int _id;
  late int _stx;
  late String _name;
  late int _categoryId;
  late String _categoryName;
  late String _categoryColorHex;
  late double _price;

  Expense getCurrentModel({required bool deleting}) => Expense(
        id: _id,
        stx: deleting ? _stx * -1 : _stx,
        createTime: item.createTime,
        name: _name,
        categoryId: _categoryId,
        categoryName: _categoryName,
        categoryColorHex: _categoryColorHex,
        price: _price,
      );

  _ExpenseDetailPageState(this.item) {
    _id = item.id;
    _stx = item.stx;
    _name = item.name;
    _categoryId = item.categoryId;
    _categoryName = item.categoryName;
    _categoryColorHex = item.categoryColorHex;
    _price = item.price;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseCubit, ModelState>(
      bloc: expenseCubit,
      listener: (context, state) {
        if (state is ModelsReady && isSaving) {
          Navigator.of(context).pop();
        } else if (state is ModelsError) {
          print(state.message);
        }
      },
      child: AppScaffold(
        title: _id > 0 ? "Expense" : "New Expense",
        bottomActions: [
          _buildActionRow(),
        ],
        body: isSaving
            ? LoadingIndicator(center: true)
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      ModelForm(
                        bloc: expenseCubit,
                        key: formKey,
                        fields: _buildFields(),
                        item: item,
                        getCurrentModel: getCurrentModel,
                        setSavingState: () => setState(() => isSaving = true),
                      ),
                    ],
                  ),
                ),
              ),
      ),
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
      controller: _categoryController,
      labelText: "Category",
      initialId: _categoryId,
      initialValue: _categoryName,
      routeName: ExpenseCategoryPage.routeName,
      //iconMapper: ExpenseCategory.getIcon,
      required: true,
      onSelected: (value) {
        setState(() {
          _categoryId = value.id;
          _categoryName = value.name;
          _categoryController.text = _categoryName;
        });
      },
      onClear: () {
        setState(() {
          _categoryId = 0;
          _categoryName = "";
          _categoryController.text = _categoryName;
        });
      },
    );

    final price = GenericTextField(
      labelText: "Price",
      initialValue: _price.toStringWithOptions(formatted: false, emptyIfNegative: true),
      required: true,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onSaved: (value) {
        _price = double.parse(value);
      },
      prefixText: "₺ ",
    );

    return [
      name,
      category,
      price,
    ];
  }

  Widget _buildActionRow() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _id > 0
              ? TextButton.icon(
                  style: TextButton.styleFrom(primary: Colors.red),
                  icon: Icon(Icons.delete),
                  label: Text("Delete"),
                  onPressed: () => formKey.currentState!.submit(deleting: true),
                )
              : SizedBox(),
          TextButton.icon(
            icon: Icon(Icons.save),
            label: Text("Save"),
            onPressed: () async => await formKey.currentState!.submit(),
          ),
        ],
      ),
    );
  }
}
