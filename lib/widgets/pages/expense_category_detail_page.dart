import 'package:dwarf_flutter/domain/cubit/model_cubit.dart';
import 'package:dwarf_flutter/theme/app_theme.dart';
import 'package:dwarf_flutter/widgets/components/app_scaffold.dart';
import 'package:dwarf_flutter/widgets/components/loading_indicator.dart';
import 'package:dwarf_flutter/widgets/forms/form_action_row.dart';
import 'package:dwarf_flutter/widgets/forms/form_color_picker.dart';
import 'package:dwarf_flutter/widgets/forms/generic_text_field.dart';
import 'package:dwarf_flutter/widgets/forms/model_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/expense_category.dart';
import '../../domain/expense_category/expense_category_cubit.dart';
import '../../locator.dart';

class ExpenseCategoryDetailPage extends StatefulWidget {
  static const routeName = "/expense_category_detail";

  final ExpenseCategory item;

  ExpenseCategoryDetailPage({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  _ExpenseCategoryDetailPageState createState() => _ExpenseCategoryDetailPageState(item);
}

class _ExpenseCategoryDetailPageState extends State<ExpenseCategoryDetailPage> {
  final ExpenseCategory item;
  final formKey = GlobalKey<ModelFormState>();
  final cubit = getIt<ExpenseCategoryCubit>();
  final _colorHexController = TextEditingController();

  bool isSaving = false;
  late int _id;
  late int _stx;
  late String _name;
  late String _colorHex;

  ExpenseCategory getCurrentModel({required bool deleting}) => ExpenseCategory(
        id: _id,
        stx: deleting ? _stx * -1 : _stx,
        name: _name,
        colorHex: _colorHex,
      );

  _ExpenseCategoryDetailPageState(this.item) {
    _id = item.id;
    _stx = item.stx;
    _name = item.name;
    _colorHex = item.colorHex;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseCategoryCubit, ModelState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is ModelsReady && isSaving) {
          Navigator.of(context).pop();
        } else if (state is ModelsError) {
          print(state.message);
        }
      },
      child: AppScaffold(
        title: _id > 0 ? "Expense Category" : "New Expense Category",
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
                        bloc: cubit,
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
      maxLength: 20,
      onSaved: (value) {
        _name = value;
      },
    );

    final colorHex = FormColorPicker(
      controller: _colorHexController,
      labelText: "Color Hex Code",
      initialValue: _colorHex,
      onSelectColor: (color) {
        setState(() {
          _colorHex = color.value.toRadixString(16);
          _colorHexController.text = _colorHex;
        });
      },
    );

    return [
      name,
      colorHex,
    ];
  }

  Widget _buildActionRow() {
    return Expanded(
      child: FormActionRow(
        showDelete: _id > 0,
        onSave: () async => await formKey.currentState!.submit(),
        onDelete: () => formKey.currentState!.submit(deleting: true),
        saveIcon: AppTheme.of(context).icons.save,
        deleteIcon: AppTheme.of(context).icons.delete,
      ),
    );
  }
}
