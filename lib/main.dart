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
    final primaryColor = Colors.deepOrange;
    final accentColor = Colors.deepOrangeAccent;
    final brightness = Brightness.light;

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primaryColor,
        brightness: brightness,
        primaryColor: primaryColor,
        accentColor: accentColor,
        appBarTheme: AppBarTheme(
          color: Theme.of(context).scaffoldBackgroundColor,
          titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 32.0),
          elevation: 1.0,
          centerTitle: false,
          actionsIconTheme: IconThemeData(color: primaryColor),
          iconTheme: IconThemeData(color: primaryColor),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: primaryColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
      home: MainPage(),
      onGenerateRoute: generateRoute,
    );
  }
}

class AppRoute<T> extends MaterialPageRoute<T> {
  AppRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return new FadeTransition(opacity: animation, child: child);
  }
}

Route? generateRoute(RouteSettings settings) {
  final routeName = settings.name;
  final arguments = settings.arguments;

  final defaultRoute = AppRoute(builder: (_) => MainPage(),);

  switch (routeName) {
    case "/expense_detail":
      return (arguments is Expense) ? AppRoute(builder: (_) => ExpenseDetailPage(item: arguments)) : defaultRoute;
    default:
      return defaultRoute;
  }
}
