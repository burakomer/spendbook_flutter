import 'package:dwarf_flutter/data/repository/database_result.dart';
import 'package:dwarf_flutter/domain/cubit/model_cubit.dart';

import '../../data/db/app_database.dart';
import '../../data/models/expense_category.dart';
import '../../locator.dart';

part 'expense_category_state.dart';

class ExpenseCategoryCubit extends ModelCubit<ExpenseCategory> {
  ExpenseCategoryCubit() : super(ExpenseCategorysNotReady());

  @override
  Future<List<ExpenseCategory>> loadInternal(bool emitLoading) async {
    if (emitLoading) emit(ExpenseCategorysLoading());

    final result = await getIt<AppDatabase>().listExpenseCategory();

    if (result is LISTresult<ExpenseCategory>) {
      emit(ExpenseCategorysReady(models: result.modelList));
      return result.modelList;
    } else if (result is ERRORresult) {
      emit(ExpenseCategorysError(message: result.message));
      return [];
    } else {
      emit(ExpenseCategorysError(message: "Unknown error on ExpenseCategory cubit."));
      return [];
    }
  }

  @override
  Future<void> saveInternal(ExpenseCategory model) async {
    final result = await getIt<AppDatabase>().saveExpenseCategory(model);

    if (result is OKresult) {
      emit(ExpenseCategorysNotReady());
    }
  }
}
