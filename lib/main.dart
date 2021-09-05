import 'package:dwarf_flutter/widgets/pages/route_not_found_page.dart';
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

    final darkColorValue = 20;
    final darkColor = Color.fromARGB(255, darkColorValue, darkColorValue, darkColorValue);
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

// extension WidgetRouteExtension on Widget {
//   AppRoute asRoute() {
//     return AppRoute(builder: (_) => this);
//   }
// }

Route? generateRoute(RouteSettings settings) {
  final routeName = settings.name;
  final arguments = settings.arguments;

  final defaultRoute = AppRoute(
    builder: (_) => RouteNotFoundPage(),
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
    final barColor = primaryColor;
    final barIconColor = Colors.white;

    return ThemeData(
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
      primarySwatch: barColor,
      brightness: brightness,
      scaffoldBackgroundColor: modeColor,
      fontFamily: "Rubik",
      appBarTheme: AppBarTheme(
        color: primaryColor,
        titleTextStyle: TextStyle(color: _getContrastingTextColorFor(barColor), fontWeight: FontWeight.bold, fontSize: 32.0),
        elevation: 8.0,
        shadowColor: primaryColor,
        centerTitle: false,
        actionsIconTheme: IconThemeData(color: barIconColor),
        iconTheme: IconThemeData(color: barIconColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: modeColor,
        selectedItemColor: primaryColor,
        //elevation: 10.0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        // border: OutlineInputBorder(
        //   borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        // ),
        border: InputBorder.none,
        //contentPadding: const EdgeInsets.only(left: 8.0),
        isDense: true,
      ),
      cardTheme: CardTheme(
        color: modeColor,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: _getContrastingTextColorFor(barColor),
        splashColor: primaryColor,
      ),
      dividerTheme: DividerThemeData(
          //indent: 12.0,
          color: Colors.grey),
      bottomAppBarTheme: BottomAppBarTheme(
        color: modeColor,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: modeColor,
        modalBackgroundColor: modeColor,
      ),
    );
  }

  static Color _getContrastingTextColorFor(Color color) {
    return color.computeLuminance() > 0.6 ? Colors.black : Colors.white;
  }
}
