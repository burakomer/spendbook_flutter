import 'package:dwarf_flutter/config/localization.dart';
import 'package:dwarf_flutter/theme/app_theme.dart';
import 'package:dwarf_flutter/widgets/pages/route_not_found_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'config/app_localization.dart';
import 'data/models/expense.dart';
import 'data/models/expense_category.dart';
import 'locator.dart';
import 'widgets/pages/expense_category_detail_page.dart';
import 'widgets/pages/expense_category_page.dart';
import 'widgets/pages/expense_detail_page.dart';
import 'widgets/pages/main_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(SpendBookApp());
}

class SpendBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.indigo;
    final appTheme = AppTheme(
      primaryColor: primaryColor,
    );

    final localization = AppLocalization();

    return MultiProvider(
      providers: [
        Provider<AppTheme>.value(value: appTheme),
        Provider<Localization>.value(value: localization),
      ],
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp(
            supportedLocales: [
              Locale("en"),
              Locale("tr"),
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            title: 'SpendBook App',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system,
            theme: appTheme.getThemeData(
              brightness: Brightness.light,
            ),
            darkTheme: appTheme.getThemeData(
              brightness: Brightness.dark,
            ),
            home: MainPage(),
            onGenerateRoute: generateRoute,
          ),
        );
      },
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
}

// extension WidgetRouteExtension on Widget {
//   AppRoute asRoute() {
//     return AppRoute(builder: (_) => this);
//   }
// }

Route? generateRoute(RouteSettings settings) {
  final routeName = settings.name;
  final arguments = settings.arguments;

  final pickerMode = settings.arguments is bool ? settings.arguments as bool : false;

  final defaultRoute = AppRoute(
    builder: (_) => RouteNotFoundPage(),
  );

  switch (routeName) {
    case "/expense_detail":
      return (arguments is Expense) ? AppRoute(builder: (_) => ExpenseDetailPage(item: arguments)) : defaultRoute;
    case "/expense_category":
      return AppRoute(builder: (_) => ExpenseCategoryPage(pickerMode: pickerMode));
    case "/expense_category_detail":
      return (arguments is ExpenseCategory) ? AppRoute(builder: (_) => ExpenseCategoryDetailPage(item: arguments)) : defaultRoute;
    default:
      return defaultRoute;
  }
}
