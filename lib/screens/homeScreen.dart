import 'package:flutter/material.dart';
import 'package:trivia_app/screens/quizScreen.dart';
import 'package:trivia_app/screens/settingsScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = "Any";
  int _amount = 5;
  String _questionType = "Any";
  String _difficulty = "Any";

  void setDifficulty(String? difficulty) {
    setState(() {
      _difficulty = difficulty!;
    });
  }

  void setQuestionType(String? questionType) {
    setState(() {
      _questionType = questionType!;
    });
  }

  void setCategory(String? category) {
    setState(() {
      _category = category!;
    });
  }

  void setAmount(int amount) {
    setState(() {
      _amount = amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Trivia App"),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text("Trivia App"),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                                category: _category,
                                questionType: _questionType,
                                amount: _amount,
                                difficulty: _difficulty,
                                setDifficulty: setDifficulty,
                                setQuestionType: setQuestionType,
                                setCategory: setCategory,
                                setAmount: setAmount,
                              )));
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    minimumSize: Size.fromHeight(60),
                    textStyle: TextStyle(
                      fontSize: 26,
                    ),
                  ),
                  child: Text('Start Quiz',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuizScreen(
                                  category: _category,
                                  questionType: _questionType,
                                  amount: _amount,
                                  difficulty: _difficulty,
                                )));
                  },
                ),
              ),
            ],
          )),
        ));
  }
}
