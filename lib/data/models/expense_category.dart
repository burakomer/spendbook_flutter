import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'base_model.dart';

class ExpenseCategory extends BaseModel {
  final String name;

  ExpenseCategory({required int id, required this.name}) : super(id);

  ExpenseCategory.create()
      : this.name = "",
        super.create();

  static FaIcon getIcon(int id) {
    switch (id) {
      case 1: // Beverages
        return FaIcon(FontAwesomeIcons.coffee, color: Colors.brown,);
      default:
        return FaIcon(FontAwesomeIcons.question);
    }
  }
}
