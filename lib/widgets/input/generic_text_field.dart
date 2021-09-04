import 'package:flutter/material.dart';

class GenericTextField extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final void Function(String) onSaved;
  final bool required;
  final TextInputType? keyboardType;

  final _controller = TextEditingController();

  GenericTextField({
    Key? key,
    required this.labelText,
    required this.initialValue,
    required this.onSaved,
    this.required = false,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _controller.text = initialValue;
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: _validateField,
      onSaved: (value) {
        onSaved(value ?? "");
      },
    );
  }

  String? _validateField(String? value) {
    if (required) {
      if (value == null || value.isEmpty) return "Required";
    }

    if (keyboardType != null && value != null && value.isNotEmpty) {
      var inputType = keyboardType.toString();
      if (inputType == TextInputType.number.toString() && (int.tryParse(value) == null || int.parse(value) < 0)) {
        return "Enter a positive integer";
      } else if (inputType == TextInputType.numberWithOptions(decimal: true).toString() && double.tryParse(value) == null) {
        return "Enter a valid number";
      } else if (inputType == TextInputType.emailAddress.toString()) {
        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
          return "Invalid email";
        }
      }
    }

    return null;
  }
}
