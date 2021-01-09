import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
  int questionNum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<QuizResponse>(
          future: Service.fetchQuizQuestion(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              List<String> answers = snapshot.data.toJson()['results']
                  [this.questionNum]['incorrect_answers'];
              answers.add(snapshot.data.toJson()['results'][this.questionNum]
                  ['correct_answer']);
              answers.shuffle();
              children = <Widget>[
                Question(HtmlUnescape()
                    .convert(snapshot.data.results[this.questionNum].question)),
                ...List.generate(answers.length, (index) {
                  return Answer(answers[index]);
                }),
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
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ));
          }),
    );
  }
}
