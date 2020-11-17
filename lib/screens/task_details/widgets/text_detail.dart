import 'package:flutter/material.dart';

import '../../../global.dart';

class TextDetail extends StatelessWidget {
  final String title;
  final String data;

  TextDetail({@required this.title, @required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
              style: TextStyle(
                fontSize: 17.0,
                color: Colors.black87,
              ),
              children: <TextSpan>[
                TextSpan(text: title, style: titleLabelStyle),
                TextSpan(text: data),
              ]),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
