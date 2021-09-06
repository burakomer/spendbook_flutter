part of 'expense_cubit.dart';

class ExpensesNotReady extends ModelsNotReady {}

class ExpensesLoading extends ModelsLoading {}

class ExpensesError extends ModelsError {
  ExpensesError({
    required String message,
  }) : super(message: message);
}

class ExpensesReady extends ModelsReady<Expense> {
  ExpensesReady({
    required List<Expense> models,
  }) : super(models: models);
}
