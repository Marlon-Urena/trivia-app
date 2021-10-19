import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class QuizResponse {
  QuizResponse({required this.responseCode, required this.results});

  late int responseCode;
  late List<Results> results;

  QuizResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['results'] = this.results.map((v) => v.toJson()).toList();
    return data;
  }
}

class Results {
  late String category;
  late String type;
  late String difficulty;
  late String question;
  late String correctAnswer;
  late List<String> incorrectAnswers;

  Results(
      {required this.category,
      required this.type,
      required this.difficulty,
      required this.question,
      required this.correctAnswer,
      required this.incorrectAnswers});

  //TODO: Unescape answers
  Results.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    type = json['type'];
    difficulty = json['difficulty'];
    question = HtmlUnescape().convert(json['question']);
    correctAnswer = HtmlUnescape().convert(json['correct_answer']);
    incorrectAnswers = json['incorrect_answers']
        .map<String>((e) => HtmlUnescape().convert(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['category'] = this.category;
    data['type'] = this.type;
    data['difficulty'] = this.difficulty;
    data['question'] = this.question;
    data['correct_answer'] = this.correctAnswer;
    data['incorrect_answers'] = this.incorrectAnswers;
    return data;
  }
}

class Service {
  static Future<QuizResponse> fetchQuizQuestion(String difficulty,
      String category, String questionType, int amount) async {
    Map<String, int> categoryMapping = {
      "General Knowledge": 9,
      "Mythology": 20,
      "Sports": 21,
      "Geography": 22,
      "History": 23,
      "Politics": 24,
      "Art": 25,
      "Celebrities": 26,
      "Animals": 27,
      "Vehicles": 28,
      "Entertainment: Books": 10,
      "Entertainment: Film": 11,
      "Entertainment: Music": 12,
      "Entertainment: Musicals & Theatres": 12,
      "Entertainment: Television": 14,
      "Entertainment: Video Games": 15,
      "Entertainment: Board Games": 16,
      "Entertainment: Comics": 29,
      "Entertainment: Japanese Anime & Manga": 31,
      "Entertainment: Cartoon & Animations": 32,
      "Science & Nature": 17,
      "Science: Computers": 18,
      "Science: Mathematics": 19,
      "Science: Gadgets": 30
    };
    Map<String, String> questionTypeMapping = {
      "Multiple Choice": "multiple",
      "True/False": "boolean"
    };
    String urlString = 'https://opentdb.com/api.php?amount=$amount';
    if (category != "Any")
      urlString += '&category=${categoryMapping[category]}';
    if (difficulty != "Any")
      urlString += '&difficulty=${difficulty.toLowerCase()}';
    if (questionType != "Any")
      urlString += '&type=${questionTypeMapping[questionType]}';
    var url = Uri.parse(urlString);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return QuizResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load question");
    }
  }
}
