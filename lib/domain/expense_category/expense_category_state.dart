part of 'expense_category_cubit.dart';

class ExpenseCategorysNotReady extends ModelsNotReady {}

class ExpenseCategorysLoading extends ModelsLoading {}

class ExpenseCategorysError extends ModelsError {
  ExpenseCategorysError({
    required String message,
  }) : super(message: message);
}

class ExpenseCategorysReady extends ModelsReady<ExpenseCategory> {
  ExpenseCategorysReady({
    required List<ExpenseCategory> models,
  }) : super(models: models);
}
