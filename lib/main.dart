import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data/models/expense.dart';
import 'widgets/pages/expense_detail_page.dart';
import 'widgets/pages/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurple;

    final darkColor = Colors.black;
    final lightColor = Colors.white;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        title: 'Kuma App',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: AppTheme.getAppTheme(primaryColor: primaryColor, modeColor: lightColor, brightness: Brightness.light),
        darkTheme: AppTheme.getAppTheme(primaryColor: primaryColor, modeColor: darkColor, brightness: Brightness.dark),
        home: MainPage(),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}

class AppRoute<T> extends CupertinoPageRoute<T> {
  AppRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(
          builder: builder,
          settings: settings,
        );
}

Route? generateRoute(RouteSettings settings) {
  final routeName = settings.name;
  final arguments = settings.arguments;

  final defaultRoute = AppRoute(
    builder: (_) => MainPage(),
  );

  switch (routeName) {
    case "/expense_detail":
      return (arguments is Expense) ? AppRoute(builder: (_) => ExpenseDetailPage(item: arguments)) : defaultRoute;
    default:
      return defaultRoute;
  }
}

class AppTheme {
  static getAppTheme({
    required MaterialColor primaryColor,
    required Color modeColor,
    required Brightness brightness,
  }) {
    return ThemeData(
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
      primarySwatch: primaryColor,
      brightness: brightness,
      scaffoldBackgroundColor: modeColor,
      appBarTheme: AppBarTheme(
        color: modeColor.withAlpha(1),
        titleTextStyle: TextStyle(color: _getContrastingTextColorFor(modeColor), fontWeight: FontWeight.w900, fontSize: 32.0),
        elevation: 0.0,
        centerTitle: false,
        actionsIconTheme: IconThemeData(color: primaryColor),
        iconTheme: IconThemeData(color: primaryColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: modeColor.withAlpha(1),
        selectedItemColor: primaryColor,
        elevation: 0.0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  static Color _getContrastingTextColorFor(Color color) {
    return color.computeLuminance() > 0.6 ? Colors.black : Colors.white;
  }
}
