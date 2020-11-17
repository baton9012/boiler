import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final Color color;

  const ProgressBar({@required this.color});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 24;
    return Container(
      height: 8.0,
      color: color,
      width: width / 3,
    );
  }
}
