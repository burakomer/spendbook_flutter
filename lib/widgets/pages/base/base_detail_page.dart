import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../crud/model_form.dart';
import '../app_scaffold.dart';

abstract class BaseDetailPage extends StatefulWidget {
  const BaseDetailPage({Key? key}) : super(key: key);
}

abstract class BaseDetailPageState<S extends BaseDetailPage> extends State<S> {
  GlobalKey<ModelFormState> _formKey = GlobalKey<ModelFormState>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Expense Detail",
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ModelForm(
          key: _formKey,
          fields: buildFields(),
        ),
      ),
      actions: [
        ActionMenuButton(
          actions: [
            TextButton.icon(
              onPressed: () {},
              icon: FaIcon(FontAwesomeIcons.save),
              label: Text("Save"),
            )
          ],
        ),
      ],
    );
  }

  List<Widget> buildFields();
}

class ActionMenuButton extends StatelessWidget {
  final List<Widget> actions;
  const ActionMenuButton({
    Key? key,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: FaIcon(FontAwesomeIcons.ellipsisV),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      offset: Offset(0.0, 50.0),
      itemBuilder: (context) {
        return actions
            .map(
              (e) => PopupMenuItem(child: e),
            )
            .toList();
      },
    );
  }
}
