import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  Answer(
      {required this.answerText,
      required this.isCorrectAnswer,
      required this.handleSelectedAnswer,
      required this.answerId,
      required this.isAnswerChosen,
      this.color: Colors.blue});

  final String answerText;
  final bool isAnswerChosen;
  final bool isCorrectAnswer;
  final Function handleSelectedAnswer;
  final int answerId;
  final Color color;

  void _handlePressed() {
    if (!isAnswerChosen) this.handleSelectedAnswer(isCorrectAnswer, answerId);
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
