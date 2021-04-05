import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class QuizResponse {
  int responseCode;
  List<Results> results;

  QuizResponse({this.responseCode, this.results});

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
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String category;
  String type;
  String difficulty;
  String question;
  String correctAnswer;
  List<String> incorrectAnswers;

  Results({this.category,
    this.type,
    this.difficulty,
    this.question,
    this.correctAnswer,
    this.incorrectAnswers});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  static Future<QuizResponse> fetchQuizQuestion() async {
    final response = await http.get('https://opentdb.com/api.php?amount=10');
    if (response.statusCode == 200) {
      return QuizResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load question");
    }
  }
}
