import 'package:dwarf_flutter/data/models/base_model.dart';
import 'package:dwarf_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';

class ExpenseCategory extends BaseModel {
  final String name;

  ExpenseCategory({
    required int id,
    required int stx,
    required this.name,
  }) : super(
          id: id,
          stx: stx,
        );

  ExpenseCategory.create()
      : this.name = "",
        super.create();

  ExpenseCategory.fromMap(Map<String, dynamic> map)
      : name = map.getString("name"),
        super.fromMap(map);

  static Icon getIcon(int id) {
    switch (id) {
      case 1: // Beverages
        return Icon(
          Icons.coffee,
          color: Colors.brown,
        );
      default:
        return Icon(Icons.not_interested);
    }
  }
}
