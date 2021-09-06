import 'package:dwarf_flutter/data/models/base_model.dart';
import 'package:dwarf_flutter/utils/extensions.dart';

class Expense extends BaseModel {
  final DateTime createTime;
  final String name;
  final int categoryId;
  final String categoryName;
  final double price;

  Expense({
    required int id,
    required int stx,
    required this.createTime,
    required this.name,
    required this.categoryId,
    required this.categoryName,
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
        this.price = 0.0,
        super.create();

  Expense.fromMap(Map<String, dynamic> map)
      : createTime = map.getDateTime("create_time"),
        name = map.getString("name"),
        categoryId = map.getInt("categoryId"),
        categoryName = map.getString("categoryName"),
        price = map.getDouble("price"),
        super.fromMap(map);

  static String modelName = "expense";
}
