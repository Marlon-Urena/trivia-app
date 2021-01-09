import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final String answerText;

  Answer(this.answerText);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        height: 60,
        minWidth: 200,
        child: RaisedButton(
            onPressed: () {},
            child: Text(answerText,
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    backgroundColor: Colors.blue))));
  }
}
