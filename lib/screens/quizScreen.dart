import 'package:flutter/material.dart';
import 'package:trivia_app/components/answer.dart';
import 'package:trivia_app/components/question.dart';
import 'package:trivia_app/screens/homeScreen.dart';
import 'package:trivia_app/screens/resultsScreen.dart';
import 'package:trivia_app/services/service.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen(
      {Key? key,
      required this.category,
      required this.questionType,
      required this.amount,
      required this.difficulty})
      : super(key: key);

  final String category;
  final String questionType;
  final int amount;
  final String difficulty;

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _questionNum = 0;
  int _selectedAnswer = -1;
  int _correctAnswer = -1;
  bool _isLoading = true;
  bool _hasSelected = false;

  //Contains the possible answers for question
  List<String> _answers = [];

  //Contains array of questions and their possible answers
  late List<Results> _quizResults;
  int _numCorrect = 0;

  @override
  void initState() {
    super.initState();
    Service.fetchQuizQuestion(widget.difficulty, widget.category,
            widget.questionType, widget.amount)
        .then((value) {
      List<Results> results = value.results;
      this.loadQuizAnswers(results[_questionNum]);
      setState(() {
        _quizResults = results;
        _isLoading = false;
      });
    });
  }

  void loadQuizAnswers(Results result) {
    List<String> answers;
    if (result.type == "boolean") {
      answers = ["True", "False"];
    } else {
      answers = result.incorrectAnswers;
      answers.add(result.correctAnswer);
      answers.shuffle();
    }
    int correctAnswer = answers.indexOf(result.correctAnswer);
    setState(() {
      _answers = answers;
      _correctAnswer = correctAnswer;
    });
  }

  void handleSelectAnswer(bool isCorrectAnswer, int choice) {
    setState(() {
      _hasSelected = true;
      _selectedAnswer = choice;
      _numCorrect = isCorrectAnswer ? _numCorrect + 1 : _numCorrect;
    });
  }

  Color createColorSelection(int answer) {
    /*
    If answer has been chosen and the answer is correct return green
    regardless if right or wrong
     */
    if (_hasSelected && answer == _correctAnswer) {
      return Colors.green;
    }
    /*
     If answer has been chosen and is not the correct answer
     then highlight that answer as red
     */
    else if (_hasSelected &&
        _selectedAnswer == answer &&
        answer != _correctAnswer) {
      return Colors.red;
    }
    // If no answer has been chosen then answer will be blue
    return Colors.blue;
  }

  void proceedToNextQuestion() {
    if (_questionNum >= _quizResults.length - 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultsScreen(
                  questionType: widget.questionType,
                  category: widget.category,
                  amount: widget.amount,
                  difficulty: widget.difficulty,
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
                Text('${_questionNum + 1}/${_quizResults.length}')
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
                child: Question(result.question)),
            ...List.generate(_answers.length, (index) {
              return Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Answer(
                  answerText: _answers[index],
                  isCorrectAnswer: _correctAnswer == index,
                  handleSelectedAnswer: this.handleSelectAnswer,
                  isAnswerChosen: _hasSelected,
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
