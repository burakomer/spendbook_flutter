import 'base_model.dart';

class Expense extends BaseModel {
  final int categoryId;
  final String categoryName;

  Expense({
    required int id,
    required this.categoryId,
    required this.categoryName,
  }) : super(id);

  Expense.create()
      : this.categoryId = 0,
        this.categoryName = "",
        super.create();
}
