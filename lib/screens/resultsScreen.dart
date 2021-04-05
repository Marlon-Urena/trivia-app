import 'package:flutter/material.dart';
import 'package:trivia_app/screens/homeScreen.dart';
import 'package:trivia_app/screens/quizScreen.dart';

class ResultsScreen extends StatelessWidget {
  ResultsScreen({this.numAnsweredCorrect, this.numQuestions});

  final int numQuestions;
  final int numAnsweredCorrect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                Container(child: Text("Answered Correct")),
                Container(
                    child: Text(numAnsweredCorrect.toString() +
                        "/" +
                        numQuestions.toString())),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      QuizScreen(text: "test")));
                        },
                        child: Text("Start Over")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        },
                        child: Text("Return Home"))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
