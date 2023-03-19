import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Decoration? decoration;

  const MyScaffold({
    Key? key,
    this.appBar,
    required this.body,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var horizontalMargin = getHorizontalPageMargin(context);
    horizontalMargin = horizontalMargin > 0 ? horizontalMargin : 0;

    return Scaffold(
      appBar: appBar,
      body: Container(
        margin: EdgeInsets.only(left: horizontalMargin, right: horizontalMargin),
        decoration: decoration,
        child: body,
      ),
    );
  }

  static double getHorizontalPageMargin(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return (width - 500) / 2;
  }
}
