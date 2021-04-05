import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  Answer(
      {this.answerText,
      this.isCorrectAnswer,
      this.handleSelectedAnswer,
      this.answerId,
      this.questionAnswered,
      this.color: Colors.blue});

  final String answerText;
  final bool isCorrectAnswer;
  final Function handleSelectedAnswer;
  final int answerId;
  final bool questionAnswered;
  final Color color;

  void _handlePressed() {
    if (handleSelectedAnswer != null)
      this.handleSelectedAnswer(isCorrectAnswer, answerId);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          minimumSize: Size.fromHeight(50),
          textStyle: TextStyle(
            fontSize: 26,
          ),
        ),
        onPressed: _handlePressed,
        child: Text(this.answerText));
  }
}
