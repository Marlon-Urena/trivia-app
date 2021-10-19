import 'package:flutter/material.dart';
import 'package:trivia_app/components/settingsDialog.dart';
import 'package:numberpicker/numberpicker.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen(
      {Key? key,
      required this.setDifficulty,
      required this.setQuestionType,
      required this.setAmount,
      required this.setCategory,
      required this.category,
      required this.questionType,
      required this.amount,
      required this.difficulty})
      : super(key: key);

  final String category;
  final int amount;
  final String questionType;
  final String difficulty;
  final void Function(String?) setDifficulty;
  final void Function(String?) setQuestionType;
  final void Function(String?) setCategory;
  final void Function(int) setAmount;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _amount = 0;
  String _category = "Any";
  String _questionType = "Any";
  String _difficulty = "Any";
  List<String> difficultyOptions = ["Any", "Easy", "Medium", "Hard"];
  List<String> questionTypeOptions = ["Any", "Multiple Choice", "True/False"];
  List<String> categoryOptions = [
    "Any",
    "General Knowledge",
    "Mythology",
    "Sports",
    "Geography",
    "History",
    "Politics",
    "Art",
    "Celebrities",
    "Animals",
    "Vehicles",
    "Entertainment: Books",
    "Entertainment: Film",
    "Entertainment: Music",
    "Entertainment: Musicals & Theatres",
    "Entertainment: Television",
    "Entertainment: Video Games",
    "Entertainment: Board Games",
    "Entertainment: Comics",
    "Entertainment: Japanese Anime & Manga",
    "Entertainment: Cartoon & Animations",
    "Science & Nature",
    "Science: Computers",
    "Science: Mathematics",
    "Science: Gadgets"
  ];

  void initState() {
    super.initState();
    setState(() {
      _difficulty = widget.difficulty;
      _amount = widget.amount;
      _questionType = widget.questionType;
      _category = widget.category;
    });
  }

  void handleQuestionType(String? questionType) {
    widget.setQuestionType(questionType);
    setState(() {
      _questionType = questionType!;
    });
  }

  void handleDifficulty(String? difficulty) {
    widget.setDifficulty(difficulty);
    setState(() {
      _difficulty = difficulty!;
    });
  }

  void handleAmount(int amount) {
    widget.setAmount(amount);
    setState(() {
      _amount = amount;
    });
  }

  void handleCategory(String? category) {
    widget.setCategory(category);
    setState(() {
      _category = category!;
    });
  }

  Future<void> numberSelectionDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SimpleDialog(
              title: Text("Number of Questions"),
              children: <Widget>[
                NumberPicker(
                  value: _amount,
                  minValue: 5,
                  maxValue: 20,
                  step: 1,
                  haptics: true,
                  onChanged: (value) {
                    widget.setAmount(value);
                    setState(() => _amount = value);
                  },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Center(
              child: Column(
            children: <Widget>[
              ListTile(
                title: Text("Category"),
                subtitle: Text(_category),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => SettingsDialog(
                          title: "Category",
                          value: _category,
                          onChange: handleCategory,
                          optionsMapping: categoryOptions));
                },
              ),
              ListTile(
                title: Text("Amount"),
                subtitle: Text('$_amount'),
                onTap: () async {
                  return await numberSelectionDialog(context);
                },
              ),
              ListTile(
                  title: Text("Difficulty"),
                  subtitle: Text(_difficulty),
                  onTap: () {
                    showDialog<void>(
                        context: context,
                        builder: (context) => SettingsDialog(
                            title: "Difficulty",
                            value: _difficulty,
                            onChange: handleDifficulty,
                            optionsMapping: difficultyOptions));
                  }),
              ListTile(
                title: Text("Question Type"),
                subtitle: Text(_questionType),
                onTap: () {
                  showDialog<void>(
                      context: context,
                      builder: (context) => SettingsDialog(
                          title: "Question Type",
                          value: _questionType,
                          onChange: handleQuestionType,
                          optionsMapping: questionTypeOptions));
                },
              )
            ],
          ))),
    );
  }
}
