class Migrations {
  static String initializeDb = """
          CREATE TABLE t_expense (
	            id INTEGER PRIMARY KEY,
	            stx INTEGER DEFAULT 1,
	            create_time TEXT NOT NULL,
   	          name TEXT NOT NULL,
            	category_id INTEGER DEFAULT 0,
            	price REAL DEFAULT 0,
            );
          CREATE TABLE t_expense_category (
	            id INTEGER PRIMARY KEY,
	            stx INTEGER DEFAULT 1,
   	          name TEXT NOT NULL,
              icon TEXT DEFAULT ''
            );
        """;
}
