import 'package:flutter/material.dart';
import 'package:trivia_app/screens/homeScreen.dart';
import 'package:trivia_app/screens/quizScreen.dart';

class ResultsScreen extends StatelessWidget {
  ResultsScreen(
      {required this.numAnsweredCorrect,
      required this.numQuestions,
      required this.difficulty,
      required this.category,
      required this.amount,
      required this.questionType});

  final String questionType;
  final String difficulty;
  final String category;
  final int amount;
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
            padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                Container(
                    child: Text("Answered Correct",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
                Container(
                    child: Text('$numAnsweredCorrect/$numQuestions',
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      minimumSize: Size.fromHeight(50),
                      textStyle: TextStyle(
                        fontSize: 26,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                    category: category,
                                    questionType: questionType,
                                    amount: amount,
                                    difficulty: difficulty,
                                  )));
                    },
                    child: Text("Start Over"),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      minimumSize: Size.fromHeight(50),
                      textStyle: TextStyle(
                        fontSize: 26,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                    child: Text("Return Home"))
              ],
            )),
      ),
    );
  }
}
