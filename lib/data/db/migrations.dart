import 'package:sqflite_migration/sqflite_migration.dart';

class Migrations {
  static var initScripts = <String>[
    """
          CREATE TABLE t_expense (
	            id INTEGER PRIMARY KEY AUTOINCREMENT,
	            stx INTEGER NOT NULL DEFAULT(1),
	            create_time TEXT NOT NULL DEFAULT(datetime('now','localtime')),
   	          name TEXT NOT NULL DEFAULT(''),
            	category_id INTEGER DEFAULT(0),
            	price REAL DEFAULT(0))
    """,
    """
          CREATE TABLE t_expense_category (
	            id INTEGER PRIMARY KEY,
	            stx INTEGER NOT NULL DEFAULT(1),
   	          name TEXT NOT NULL)
    """,
  ];

  static var migrationScripts = <String>[
    """
          ALTER TABLE t_expense_category 
            ADD COLUMN color_hex TEXT NOT NULL DEFAULT('');
    """,
  ];

  static var config = MigrationConfig(initializationScript: initScripts, migrationScripts: migrationScripts);
}
