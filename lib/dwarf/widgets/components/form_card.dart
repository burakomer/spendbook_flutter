
import 'package:flutter/material.dart';

class FormCard extends StatelessWidget {
  final Widget? child;

  const FormCard({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.only(left: 12.0),
        child: child,
      ),
    );
  }
}