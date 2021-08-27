import 'package:flutter/material.dart';

extension WidgetListExtensions on List<Widget> {
  List<Widget> topPadding(BuildContext context) {
    this.insert(0, SizedBox(height: MediaQuery.of(context).padding.top));
    return this;
  }
}