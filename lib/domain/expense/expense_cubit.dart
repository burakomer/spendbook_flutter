import 'package:dwarf_flutter/data/repository/database_result.dart';
import 'package:dwarf_flutter/domain/cubit/model_cubit.dart';

import '../../data/db/app_database.dart';
import '../../data/models/expense.dart';
import '../../locator.dart';

part 'expense_state.dart';

class ExpenseCubit extends ModelCubit<Expense> {
  ExpenseCubit() : super(ExpensesNotReady());

  @override
  Future<List<Expense>> loadInternal(bool emitLoading) async {
    if (emitLoading) emit(ExpensesLoading());

    final result = await getIt<AppDatabase>().listExpense();

    if (result is LISTresult<Expense>) {
      emit(ExpensesReady(models: result.modelList));
      return result.modelList;
    } else if (result is ERRORresult) {
      emit(ExpensesError(message: result.message));
      return [];
    } else {
      emit(ExpensesError(message: "Unknown error on Expense cubit."));
      return [];
    }
  }

  @override
  Future<void> saveInternal(Expense model) async {
    final result = await getIt<AppDatabase>().saveExpense(model);

    if (result is OKresult) {
      load();
    }
  }
}
