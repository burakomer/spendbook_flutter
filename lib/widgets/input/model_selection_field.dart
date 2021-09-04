import 'package:flutter/material.dart';

class ModelSelectionField<M> extends StatelessWidget {
  final String labelText;
  final int initialId;
  final String initialValue;
  final String routeName;
  final void Function(M) onSelected;
  final Icon Function(int)? iconMapper;

  final _controller = TextEditingController();

  ModelSelectionField({
    Key? key,
    required this.labelText,
    required this.initialId,
    required this.initialValue,
    required this.routeName,
    required this.onSelected,
    this.iconMapper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onTap() async {
      final model = await Navigator.of(context).pushNamed(
        routeName,
        arguments: true,
      );
      if (model == null || !(model is M)) return;
      onSelected(model as M);
    }

    _controller.text = initialValue;
    return TextFormField(
      readOnly: true,
      controller: _controller,
      decoration: InputDecoration(
        prefixIcon: iconMapper == null
            ? null
            : initialId < 0
                ? null
                : IconButton(
                    icon: iconMapper!.call(initialId),
                    onPressed: null,
                  ),
        labelText: labelText,
        suffixIcon: Icon(Icons.chevron_right),
      ),
      onTap: onTap,
    );
  }
}
