import 'dart:io';

import 'package:dwarf_flutter/data/repository/database_result.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';

class AppDatabase {
  Future<Database> _getDbConnection() async {
    final dbFileName = "db_kuma_app.db";
    final dbPath = join((await getApplicationDocumentsDirectory()).path, dbFileName);

    // Copy if not found.
    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      final data = await rootBundle.load("assets/database/$dbFileName");
      final buffer = data.buffer;
      File(dbPath).writeAsBytesSync(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    }

    return await openDatabase(dbPath);
  }

  // LIST METHODS
  Future<DatabaseResult> listExpense() async {
    //print(await getDatabasesPath());
    try {
      final db = await _getDbConnection();

      final sql = """
        SELECT expn.id, expn.stx, expn.create_time, expn.name, expn.category_id, expn.price,
               ecat.name as category_name
        FROM t_expense expn
        LEFT JOIN t_expense_category ecat ON ecat.id = expn.category_id
        WHERE expn.stx > 0
        ORDER BY expn.create_time DESC
      """;

      final List<Map<String, dynamic>> maps = await db.rawQuery(sql);
      final modelList = List.generate(
        maps.length,
        (i) => Expense.fromMap(maps[i]),
      );
      return DatabaseResult.list(modelList);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  Future<DatabaseResult> listExpenseCategory() async {
    try {
      final db = await _getDbConnection();

      final sql = """
        SELECT ecat.id, ecat.stx, ecat.name
        FROM t_expense ecat
        WHERE ecat.stx > 0
        ORDER BY ecat.name
      """;

      final List<Map<String, dynamic>> maps = await db.rawQuery(sql);
      final modelList = List.generate(
        maps.length,
        (i) => ExpenseCategory.fromMap(maps[i]),
      );
      return DatabaseResult.list(modelList);
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  // SAVE METHODS
  Future<DatabaseResult> saveExpense(Expense model) async {
    try {
      final db = await _getDbConnection();

      if (model.id < 0) {
        final sql = """
          INSERT INTO t_expense (stx, create_time, name, category_id, price)
          VALUES  (?, datetime('now','localtime'), ?, ?, ?)
        """;
        final lastInsertId = await db.rawInsert(sql, [model.stx, model.name, model.categoryId, model.price]);
        //final insertedModel = await listExpense(filter: ExpenseFilter(id: lastInsertId));
        return DatabaseResult.ok(lastInsertId);
      } else {
        final sql = """
          UPDATE t_expense
          SET stx = ?, name = ?, category_id = ?, price = ?
          WHERE id = ?
        """;
        await db.rawUpdate(sql, [model.stx, model.name, model.categoryId, model.price, model.id]);
        return DatabaseResult.ok();
      }
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  Future<DatabaseResult> saveExpenseCategory(ExpenseCategory model) async {
    try {
      final db = await _getDbConnection();

      if (model.id < 0) {
        final sql = """
          INSERT INTO t_expense_category (stx, name)
          VALUES  (?, ?)
        """;
        final lastInsertId = await db.rawInsert(
          sql,
          [model.stx, model.name],
        );
        return DatabaseResult.ok(lastInsertId);
      } else {
        final sql = """
          UPDATE t_expense_category
          SET stx = ?, name = ?
          WHERE id = ?
        """;

        await db.rawUpdate(sql, [model.stx, model.name, model.id]);
        return DatabaseResult.ok();
      }
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }
}
