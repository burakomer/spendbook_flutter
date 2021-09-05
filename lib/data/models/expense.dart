
import 'package:dwarf_flutter/data/models/base_model.dart';

class Expense extends BaseModel {
  final String name;
  final int categoryId;
  final String categoryName;
  final double price;

  Expense({
    required int id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.price,
  }) : super(id);

  Expense.create()
      : this.name = "",
        this.categoryId = 0,
        this.categoryName = "",
        this.price = 0.0,
        super.create();
}
