import 'package:flutter/material.dart';

class ModelForm extends StatefulWidget {
  final List<Widget> fields;

  const ModelForm({
    GlobalKey<ModelFormState>? key,
    required this.fields,
  }) : super(key: key);

  @override
  ModelFormState createState() => ModelFormState();
}

class ModelFormState extends State<ModelForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: widget.fields
            .map((e) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: e,
                ))
            .toList(),
      ),
    );
  }

  Future<void> submit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) return;

    formState.save();

    return await Future.delayed(Duration(seconds: 1));
  }
}
