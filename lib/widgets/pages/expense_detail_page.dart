import 'dart:math' as math;

import 'package:dwarf_flutter/domain/cubit/model_cubit.dart';
import 'package:dwarf_flutter/theme/app_theme.dart';
import 'package:dwarf_flutter/utils/extensions.dart';
import 'package:dwarf_flutter/widgets/components/app_scaffold.dart';
import 'package:dwarf_flutter/widgets/components/loading_indicator.dart';
import 'package:dwarf_flutter/widgets/forms/autocomplete_text_field.dart';
import 'package:dwarf_flutter/widgets/forms/date_time_field.dart';
import 'package:dwarf_flutter/widgets/forms/form_action_row.dart';
import 'package:dwarf_flutter/widgets/forms/generic_text_field.dart';
import 'package:dwarf_flutter/widgets/forms/model_form.dart';
import 'package:dwarf_flutter/widgets/forms/model_selection_field.dart';
import 'package:flutter/foundation.dart';
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
  final autocompleteCubit = ExpenseCubit();

  final _nameController = TextEditingController();
  final _nameNode = FocusNode();
  final _categoryController = TextEditingController();
  final _createTimeController = TextEditingController();

  bool isSaving = false;
  late int _id;
  late int _stx;
  late DateTime _createTime;
  late String _name;
  late int _categoryId;
  late String _categoryName;
  late String _categoryColorHex;
  late double _price;

  Expense getCurrentModel({required bool deleting}) => Expense(
        id: _id,
        stx: deleting ? _stx * -1 : _stx,
        createTime: _createTime,
        name: _name,
        categoryId: _categoryId,
        categoryName: _categoryName,
        categoryColorHex: _categoryColorHex,
        price: _price,
      );

  _ExpenseDetailPageState(this.item) {
    _id = item.id;
    _stx = item.stx;
    _createTime = item.createTime;
    _name = item.name;
    _categoryId = item.categoryId;
    _categoryName = item.categoryName;
    _categoryColorHex = item.categoryColorHex;
    _price = item.price;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => autocompleteCubit.load());
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
          Expanded(child: _buildActionRow()),
        ],
        body: isSaving
            ? LoadingIndicator(center: true)
            : SingleChildScrollView(
              // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                physics: AlwaysScrollableScrollPhysics(),
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
    );
  }

  List<Widget> _buildFields() {
    final name = AutocompleteTextField<Expense>(
      controller: _nameController,
      focusNode: _nameNode,
      borderRadius: AppTheme.of(context).borderRadius,
      labelText: "Name",
      initialValue: _name,
      required: true,
      onSaved: (value) {
        _name = value;
      },
      textSelector: (option) => option.name,
      onSelected: (model) {
        setState(() {
          _name = model.name;
          _categoryId = model.categoryId;
          _categoryName = model.categoryName;
          _categoryColorHex = model.categoryColorHex;
          _price = model.price;
          _nameController.text = _name;
        });
      },
      optionsBuilder: (editingValue) {
        if (!(autocompleteCubit.state is ExpensesReady)) return [];
        final models = (autocompleteCubit.state as ExpensesReady).models.toList();
        return editingValue.text.isNotEmpty
            ? models.where(
                (model) => model.name.toLowerCase().contains(editingValue.text.toLowerCase()),
              )
            : models.take(5);
      },
      itemBuilder: (option) => ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(option.name),
            Text(option.price.toStringWithOptions(leading: "₺ ")),
          ],
        ),
      ),
    );

    // final name = GenericTextField(
    //   labelText: "Name",
    //   initialValue: _name,
    //   required: true,
    //   onSaved: (value) {
    //     _name = value;
    //   },
    // );

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
      key: Key(_price.toString()),
      labelText: "Price",
      initialValue: _price.toStringWithOptions(formatted: false, emptyIfNegative: true),
      required: true,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onSaved: (value) {
        _price = double.parse(value);
      },
      prefixText: "₺ ",
    );

    final date = DateTimeField(
      controller: _createTimeController,
      labelText: "Date",
      initialDate: _createTime,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      timePicker: true,
      onSelectDateTime: (dateTime) {
        setState(() {
          _createTime = dateTime;
        });
      },
    );

    final expenseType = DropdownButton<ExpenseTypes>(
      isExpanded: true,
      borderRadius: BorderRadius.circular(8.0),
      underline: SizedBox(),
      value: val,
      icon: Transform.rotate(angle: math.pi * 0.5, child: Icon(Icons.chevron_right)),
      items: ExpenseTypes.values
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(
                describeEnum(e),
              ),
            ),
          )
          .toList(),
      onChanged: (ExpenseTypes? value) => setState(() => val = value!),
    );

    return [
      name,
      category,
      price,
      date,
      // expenseType,
    ];
  }

  var val = ExpenseTypes.OneTime;

  Widget _buildActionRow() {
    return FormActionRow(
      showDelete: _id > 0,
      onSave: () async => await formKey.currentState!.submit(),
      onDelete: () => formKey.currentState!.submit(deleting: true),
      saveIcon: AppTheme.of(context).icons.save,
      deleteIcon: AppTheme.of(context).icons.delete,
    );
  }
}
