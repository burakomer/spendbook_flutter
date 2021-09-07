import 'package:dwarf_flutter/domain/cubit/model_cubit.dart';
import 'package:dwarf_flutter/widgets/components/app_scaffold.dart';
import 'package:dwarf_flutter/widgets/components/loading_indicator.dart';
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
      onSaved: (value) {
        _name = value;
      },
    );

    final colorHex = FormColorPicker(
      labelText: "Color Hex Code",
      initialValue: _colorHex,
      onSelectColor: (color) {
        setState(() {
          _colorHex = color.value.toRadixString(16);
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
