import 'package:flutter/material.dart';
import 'package:kuma_app/data/models/base_model.dart';

import '../../dwarf/widgets/components/form_card.dart';
import '../../utils/extensions.dart';

class ModelForm<M extends BaseModel> extends StatefulWidget {
  final List<Widget> fields;
  final M item;
  final M Function() getCurrentModel;

  const ModelForm({
    GlobalKey<ModelFormState>? key,
    required this.fields,
    required this.item,
    required this.getCurrentModel,
  }) : super(key: key);

  @override
  ModelFormState createState() => ModelFormState();
}

class ModelFormState extends State<ModelForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return FormCard(
      child: Form(
        key: _formKey,
        child: Column(
          children: widget.fields
              .map<Widget>((e) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: e,
                  ))
              .toList()
              .putInBetween(Divider(height: 0)),
        ),
      ),
    );
  }

  Future<void> submit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    formState.save();

    final itemToSave = widget.getCurrentModel();

    if (itemToSave != widget.item) {
      // Save.
    }

    return await Future.delayed(Duration(seconds: 1));
  }
}
