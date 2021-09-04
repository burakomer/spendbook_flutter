import 'package:flutter/material.dart';

import 'base_model.dart';

class ExpenseCategory extends BaseModel {
  final String name;

  ExpenseCategory({required int id, required this.name}) : super(id);

  ExpenseCategory.create()
      : this.name = "",
        super.create();

  static Icon getIcon(int id) {
    switch (id) {
      case 1: // Beverages
        return Icon(Icons.coffee, color: Colors.brown,);
      default:
        return Icon(Icons.not_interested);
    }
  }
}