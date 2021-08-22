import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GenericTextField extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final void Function(String) onSaved;

  final _controller = TextEditingController();

  GenericTextField({
    Key? key,
    required this.labelText,
    required this.initialValue,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _controller.text = initialValue;
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: IconButton(
          icon: FaIcon(FontAwesomeIcons.times),
          onPressed: () => _controller.clear(),
        ),
      ),
      onSaved: (value) {
        onSaved(value ?? "");
      },
    );
  }
}
