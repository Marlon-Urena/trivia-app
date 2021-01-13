import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final String answerText;

  Answer(this.answerText);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
          textStyle: TextStyle(
            fontSize: 26,
          ),
        ),
        onPressed: () {},
        child: Text(answerText));
  }
}
