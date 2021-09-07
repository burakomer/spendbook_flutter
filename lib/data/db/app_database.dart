import 'dart:io';

import 'package:dwarf_flutter/data/repository/database_result.dart';
import 'package:dwarf_flutter/utils/helpers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import 'migrations.dart';

class AppDatabase {
  static const dbFileName = "db_kuma_app.db";
  static Future<String> dbPath() async => join((await getApplicationDocumentsDirectory()).path, dbFileName);

  static Future<bool> shareDatabase() async {
    final dbPath = await AppDatabase.dbPath();
    try {
      await Share.shareFiles([dbPath]);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> importDatabase(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    try {
      if (result != null) {
        if (result.files.single.extension != "db") {
          showSnackbar(context: context, content: Text("Selected file is not a database."));
          return;
        }
        final file = File(result.files.single.path);
        final data = await file.readAsBytes();
        final buffer = data.buffer;

        final dbFile = File(await dbPath());

        if (await dbFile.exists()) {
          final override = await showBooleanDialog(context: context, title: "Warning", message: "Current data will be overwritten.", okayText: "Continue");
          if (override == null || !override) {
            showSnackbar(context: context, content: Text("Canceled"));
            return;
          }
        }
        return; // TODO: Check the db integrity first.
        File(await dbPath()).writeAsBytesSync(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      showSnackbar(
        context: context,
        content: Text("An error occured."),
      );
      return;
    }
  }

  Future<Database> _getDbConnection() async {
    final dbPath = await AppDatabase.dbPath();

    // // Copy if not found.
    // if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
    //   final data = await rootBundle.load("assets/database/$dbFileName");
    //   final buffer = data.buffer;
    //   File(dbPath).writeAsBytesSync(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    // }

    return await openDatabaseWithMigration(dbPath, Migrations.config);
  }

  // LIST METHODS
  Future<DatabaseResult> listExpense() async {
    //print(await getDatabasesPath());
    try {
      final db = await _getDbConnection();

      final sql = """
        SELECT expn.id, expn.stx, expn.create_time, expn.name, expn.category_id, expn.price,
               ecat.name as category_name, ecat.color_hex as category_color_hex
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
        SELECT ecat.id, ecat.stx, ecat.name, ecat.color_hex
        FROM t_expense_category ecat
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

      final arguments = [
        model.stx,
        model.name,
        model.categoryId,
        model.price,
      ];

      if (model.id < 0) {
        final sql = """
          INSERT INTO t_expense (stx, name, category_id, price)
          VALUES  (?, ?, ?, ?)
        """;
        final lastInsertId = await db.rawInsert(sql, arguments);
        //final insertedModel = await listExpense(filter: ExpenseFilter(id: lastInsertId));
        return DatabaseResult.ok(lastInsertId);
      } else {
        final sql = """
          UPDATE t_expense
          SET stx = ?, name = ?, category_id = ?, price = ?
          WHERE id = ?
        """;
        arguments.addAll([model.id]);
        await db.rawUpdate(sql, arguments);
        return DatabaseResult.ok();
      }
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }

  Future<DatabaseResult> saveExpenseCategory(ExpenseCategory model) async {
    try {
      final db = await _getDbConnection();

      final arguments = [
        model.stx,
        model.name,
        model.colorHex,
      ];

      if (model.id < 0) {
        final sql = """
          INSERT INTO t_expense_category (stx, name, color_hex)
          VALUES  (?, ?, ?)
        """;
        final lastInsertId = await db.rawInsert(sql, arguments);
        return DatabaseResult.ok(lastInsertId);
      } else {
        final sql = """
          UPDATE t_expense_category
          SET stx = ?, name = ?, color_hex = ?
          WHERE id = ?
        """;
        arguments.addAll([model.id]);
        await db.rawUpdate(sql, arguments);
        return DatabaseResult.ok();
      }
    } catch (e) {
      return DatabaseResult.error(e.toString());
    }
  }
}
