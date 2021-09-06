import 'package:get_it/get_it.dart';

import 'data/db/app_database.dart';
import 'domain/expense/expense_cubit.dart';
import 'domain/expense_category/expense_category_cubit.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<ExpenseCubit>(ExpenseCubit());
  getIt.registerSingleton<ExpenseCategoryCubit>(ExpenseCategoryCubit());
}