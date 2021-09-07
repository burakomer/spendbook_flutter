import 'package:dwarf_flutter/data/models/base_model.dart';
import 'package:dwarf_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';

class Expense extends BaseModel {
  final DateTime createTime;
  final String name;
  final int categoryId;
  final String categoryName;
  final String categoryColorHex;
  final double price;

  Color? get categoryColor => categoryColorHex.colorFromHexCode();

  Expense({
    required int id,
    required int stx,
    required this.createTime,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColorHex,
    required this.price,
  }) : super(
          id: id,
          stx: stx,
        );

  Expense.create()
      : this.createTime = DateTime.now(),
        this.name = "",
        this.categoryId = 0,
        this.categoryName = "",
        this.categoryColorHex = "",
        this.price = -1,
        super.create();

  Expense.fromMap(Map<String, dynamic> map)
      : createTime = map.getDateTime("create_time"),
        name = map.getString("name"),
        categoryId = map.getInt("category_id"),
        categoryName = map.getString("category_name"),
        categoryColorHex = map.getString("category_color_hex"),
        price = map.getDouble("price"),
        super.fromMap(map);

  static String modelName = "expense";
}
