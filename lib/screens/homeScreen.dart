import 'package:flutter/material.dart';
import 'package:trivia_app/screens/quizScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ButtonTheme(
                height: 60,
                minWidth: 200,
                child: ElevatedButton(
                  child: Text('Start Quiz',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuizScreen(text: "test")));
                  },
                ))));
  }
}
