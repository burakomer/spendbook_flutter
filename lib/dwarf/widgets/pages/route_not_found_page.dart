
import 'package:flutter/material.dart';

import '../../../widgets/pages/app_scaffold.dart';

class RouteNotFoundPage extends StatelessWidget {
  const RouteNotFoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(child: Text("route_not_found")),
    );
  }
}