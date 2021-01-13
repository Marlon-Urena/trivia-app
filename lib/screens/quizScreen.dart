import 'package:flutter/material.dart';
import 'package:trivia_app/answer.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:trivia_app/question.dart';
import 'package:trivia_app/services/service.dart';

class QuizScreen extends StatefulWidget {
  final String text;

  const QuizScreen({Key key, this.text}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionNum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('Entertainment',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'Video Games',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<QuizResponse>(
          future: Service.fetchQuizQuestion(),
          builder:
              (BuildContext context, AsyncSnapshot<QuizResponse> snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              Results result = snapshot.data.results[this._questionNum];
              List<String> answers = result.incorrectAnswers;
              answers.add(result.correctAnswer);
              answers.shuffle();
              children = <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      Question(HtmlUnescape().convert(result.question)),
                      ...List.generate(answers.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Answer(HtmlUnescape().convert(answers[index])),
                        );
                      }),
                    ],
                  ),
                )
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                Text("Error"),
              ];
            } else {
              children = <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                )
              ];
            }
            return Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            ));
          }),
    );
  }
}
