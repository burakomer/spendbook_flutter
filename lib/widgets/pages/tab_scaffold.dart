import 'package:flutter/material.dart';

class TabScaffold {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  TabScaffold({
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });
}
