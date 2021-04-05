import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:trivia_app/components/answer.dart';
import 'package:trivia_app/components/question.dart';
import 'package:trivia_app/screens/homeScreen.dart';
import 'package:trivia_app/screens/resultsScreen.dart';
import 'package:trivia_app/services/service.dart';

class QuizScreen extends StatefulWidget {
  final String text;

  const QuizScreen({Key key, this.text}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionNum = 0;
  int _selectedAnswer = -1;
  bool _isLoading = true;
  bool _hasSelected = false;
  List<String> _answers = [];
  Map<int, bool> _answerMap = Map();
  List<Results> _quizResults;
  int _numCorrect = 0;
  int _numQuestions = 0;

  @override
  void initState() {
    super.initState();
    Service.fetchQuizQuestion().then((value) {
      List<Results> results = value.results;
      this.loadQuizAnswers(results[_questionNum]);
      setState(() {
        _quizResults = results;
        _isLoading = false;
        _numQuestions = results.length;
      });
    });
  }

  void loadQuizAnswers(Results result) {
    List<String> answers = result.incorrectAnswers;
    answers.add(result.correctAnswer);
    answers.shuffle();
    Map<int, bool> answerMap = Map();
    for (int i = 0; i < answers.length; i++) {
      if (answers[i] == result.correctAnswer) {
        answerMap[i] = true;
      } else {
        answerMap[i] = false;
      }
    }
    setState(() {
      _answerMap = answerMap;
      _answers = answers;
    });
  }

  bool handleSelectAnswer(bool isCorrectAnswer, int choice) {
    bool hasSelected = true;

    setState(() {
      _hasSelected = hasSelected;
      _selectedAnswer = choice;
      _numCorrect = isCorrectAnswer ? _numCorrect + 1 : _numCorrect;
    });
    return isCorrectAnswer;
  }

  Color createColorSelection(int index) {
    if (_selectedAnswer == index) {
      if (_answerMap[index]) {
        return Colors.green;
      }
      return Colors.red;
    } else if (_hasSelected && _answerMap[index]) {
      return Colors.green;
    }
    return Colors.blue;
  }

  void proceedToNextQuestion() {
    if (_questionNum >= _quizResults.length - 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultsScreen(
                  numAnsweredCorrect: _numCorrect,
                  numQuestions: _quizResults.length)));
    } else {
      setState(() {
        _questionNum++;
        _hasSelected = false;
        _selectedAnswer = -1;
      });
      loadQuizAnswers(this._quizResults[this._questionNum]);
    }
  }

  Widget createQuizSection() {
    Results result = this._quizResults[this._questionNum];

    return Scaffold(
      appBar: AppBar(
        title: Text(this._quizResults[this._questionNum].category,
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                TextButton(
                  child: Text('EXIT'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
                Text('${_questionNum + 1}/$_numQuestions')
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(color: Colors.black, width: 3.0),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Question(HtmlUnescape().convert(result.question))),
            ...List.generate(_answers.length, (index) {
              return Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Answer(
                  answerText: _answers[index],
                  isCorrectAnswer: _answerMap[index],
                  handleSelectedAnswer:
                      _hasSelected ? null : this.handleSelectAnswer,
                  answerId: index,
                  color: createColorSelection(index),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  minimumSize: Size.fromHeight(50),
                  textStyle: TextStyle(
                    fontSize: 26,
                  ),
                ),
                child: Text("Next Question"),
                onPressed: _hasSelected ? this.proceedToNextQuestion : null,
              ),
            )
          ],
        ),
      )),
    );
  }

  createLoadingScreen() {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Awaiting result...'),
            )
          ],
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return this._isLoading
        ? this.createLoadingScreen()
        : this.createQuizSection();
  }
}
