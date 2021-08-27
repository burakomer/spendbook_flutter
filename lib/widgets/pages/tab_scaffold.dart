import 'package:flutter/material.dart';

class TabScaffold {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  TabScaffold({
    required this.title,
    required this.body,
    this.actions,
  });
}
