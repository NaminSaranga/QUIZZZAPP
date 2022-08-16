import 'package:ctse_quiz_app/models/notes_model.dart';
import 'package:ctse_quiz_app/models/saveScore_model.dart';
import 'package:ctse_quiz_app/models/user_model.dart';
import 'package:ctse_quiz_app/screens/home_screen.dart';
import 'package:ctse_quiz_app/widgets/profile_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './question_model.dart';
import 'dart:convert';
import 'package:localstore/localstore.dart';

final db = Localstore.instance;

class DBConnect {
  final questionsURL = Uri.parse(
      'https://quizzzapp-c3d46-default-rtdb.asia-southeast1.firebasedatabase.app/questions.json');
  Future<void> addQuestion(Question question) async {
    http.post(questionsURL,
        body: json.encode({
          'title': question.title,
          'options': question.options,
        }));
  }

  final notesURL = Uri.parse(
      'https://quizzzapp-c3d46-default-rtdb.asia-southeast1.firebasedatabase.app/notes.json');
  Future<void> addNotes(Note note) async {
    http.post(notesURL, body: json.encode({'note': note.note}));
  }

  Future<List<Note>> fetchNote() async {
    return http.get(notesURL).then((response) {
      var data = json.decode(response.body) as Map<String, dynamic>;

      List<Note> newNotes = [];

      data.forEach((key, value) {
        var newNote = Note(note: value['note']);

        newNotes.add(newNote);
      });
      return newNotes;
    });
  }

  Future<void> updateNote(String uniqueKey, String note) async {
    var noteUPDATE_URL = Uri.parse(
        'https://quizzzapp-c3d46-default-rtdb.asia-southeast1.firebasedatabase.app/notes/' +
            uniqueKey +
            '.json');

    http
        .patch(noteUPDATE_URL, body: json.encode({'note': note}))
        .then((value) => print("UPDATE SUCCESSFUL"));
  }

  Future<List<Question>> fetchQuestions() async {
    return http.get(questionsURL).then((response) {
      var data = json.decode(response.body) as Map<String, dynamic>;

      List<Question> newQuestions = [];

      data.forEach((key, value) {
        var newQuestion = Question(
            id: key,
            title: value['title'],
            options: Map.castFrom(value['options']));

        newQuestions.add(newQuestion);
      });
      return newQuestions;
    });
  }

  final saveScoreURL = Uri.parse(
      'https://quizzzapp-c3d46-default-rtdb.asia-southeast1.firebasedatabase.app/scoreboard.json');
  Future<void> addSaveScore(SaveScore saveScore) async {
    http.post(saveScoreURL,
        body: json.encode({
          'name': saveScore.name,
          'score': saveScore.score,
          'lastName': ""
        }));
  }

  Future<List<SaveScore>> fetchScores() async {
    return http.get(saveScoreURL).then((response) {
      var data = json.decode(response.body) as Map<String, dynamic>;

      List<SaveScore> newScores = [];

      data.forEach((key, value) {
        var newSaveScore = SaveScore(
            uniqueKey: key,
            name: value['name'],
            score: value['score'],
            lastName: value['lastName']);

        newScores.add(newSaveScore);
      });
      // print(newScores);
      return newScores;
    });
  }

  Future<void> deleteScore(String uniqueKey) async {
    var saveScoreDELETE_URL = Uri.parse(
        'https://quizzzapp-c3d46-default-rtdb.asia-southeast1.firebasedatabase.app/scoreboard/' +
            uniqueKey +
            '.json');
    print(saveScoreDELETE_URL);
    http.delete(saveScoreDELETE_URL).then((value) => print("DELETE SUCCESS"));
  }

  Future<void> updateScore(String uniqueKey, String lastName) async {
    var saveScoreUPDATE_URL = Uri.parse(
        'https://quizzzapp-c3d46-default-rtdb.asia-southeast1.firebasedatabase.app/scoreboard/' +
            uniqueKey +
            '.json');

    http
        .patch(saveScoreUPDATE_URL, body: json.encode({'lastName': lastName}))
        .then((value) => print("UPDATE SUCCESSFUL"));
  }

  final createUserURL = Uri.parse(
      'https://quizzzapp-c3d46-default-rtdb.asia-southeast1.firebasedatabase.app/user.json');

  Future<String> addUser(User user, BuildContext context) async {
    String response = '';

    var unique_ID = {};

    http
        .post(createUserURL,
            body: json.encode({
              'firstname': user.firstname,
              'lastname': user.lastname,
              'address': user.address,
              'age': user.age
            }))
        .then((value) => {
              unique_ID = jsonDecode(value.body),
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          HomeScreen(uniqueID: unique_ID['name'])))
            });

    return response;
  }

  Future<List<User>> fetchUser(String uniqueKey, BuildContext context) async {
    final fetchUser = Uri.parse(
        'https://quizzzapp-c3d46-default-rtdb.asia-southeast1.firebasedatabase.app/user/' +
            uniqueKey +
            '.json');
    return http.get(fetchUser).then((response) {
      var data = json.decode(response.body) as Map<String, dynamic>;

      List<User> newUser = [];

      String address = "";
      String age = "";
      String firstname = "";
      String lastname = "";

      data.forEach((key, value) {
        if (key == "address") {
          address = value;
        } else if (key == "age") {
          age = value;
        } else if (key == "firstname") {
          firstname = value;
        } else if (key == "lastname") {
          lastname = value;
        }
      });

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ProfileBox(
              uniqueKey: uniqueKey,
              firstname: firstname,
              lastname: lastname,
              age: age,
              address: address));
      return newUser;
    });
  }

  Future<void> deleteUser(String uniqueKey) async {
    var userDELETE_URL = Uri.parse(
        'https://quizzzapp-c3d46-default-rtdb.asia-southeast1.firebasedatabase.app/user/' +
            uniqueKey +
            '.json');
    http.delete(userDELETE_URL).then((value) => print("DELETE SUCCESS"));
  }

  Future<void> updateUser(String uniqueKey, User user) async {
    var userUPDATE_URL = Uri.parse(
        'https://quizzzapp-c3d46-default-rtdb.asia-southeast1.firebasedatabase.app/user/' +
            uniqueKey +
            '.json');

    http
        .patch(userUPDATE_URL,
            body: json.encode({
              'firstname': user.firstname,
              'lastname': user.lastname,
              'age': user.age,
              'address': user.address
            }))
        .then((value) => print("UPDATE SUCCESSFUL"));
  }
}
