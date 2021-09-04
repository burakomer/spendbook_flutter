import 'package:flutter/material.dart';
import 'package:kuma_app/data/models/base_model.dart';

import '../../crud/model_form.dart';
import '../app_scaffold.dart';

class SimpleDetailPage<M extends BaseModel> extends StatelessWidget {
  final GlobalKey<ModelFormState> formKey;
  final M item;
  final List<Widget> fields;
  final Widget actionRow;
  final M Function() getCurrentModel;

  SimpleDetailPage({
    required this.formKey,
    required this.item,
    required this.fields,
    required this.actionRow,
    required this.getCurrentModel,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Expense Detail",
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ModelForm<M>(
                key: formKey,
                fields: fields,
                item: item,
                getCurrentModel: getCurrentModel,
              ),
            ],
          ),
        ),
      ),
      bottomActions: [
        actionRow,
      ],
    );
  }
}
