import 'package:flutter/material.dart';

import '../../data/models/base_model.dart';

class SimpleModelList<M extends BaseModel> extends StatelessWidget {
  final List<M> items;
  final Widget Function(BuildContext, int, M) itemBuilder;

  SimpleModelList({
    Key? key,
    required this.items,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, index, items[index]),
    );
  }
}
