import 'package:ctse_quiz_app/models/db_connect.dart';
import 'package:ctse_quiz_app/widgets/next_button.dart';
import 'package:ctse_quiz_app/widgets/notes_box.dart';
import 'package:ctse_quiz_app/widgets/option_card.dart';
import 'package:ctse_quiz_app/widgets/result_box.dart';
import 'package:ctse_quiz_app/widgets/viewNotes_button.dart';
import 'package:ctse_quiz_app/widgets/viewProfile_button.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:ctse_quiz_app/models/question_model.dart';
import 'package:ctse_quiz_app/widgets/question_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.uniqueID}) : super(key: key);

  final String uniqueID;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = DBConnect();

  late Future _questions;

  Future<List<Question>> getData() async {
    print(this.widget.uniqueID);
    return db.fetchQuestions();
  }

  @override
  void initState() {
    _questions = getData();
    super.initState();
  }

  int index = 0;

  int score = 0;

  bool isPressed = false;

  bool isAlreadySelected = false;

  void NextQuestion(int questionLength) {
    if (index == questionLength - 1) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
                result: score,
                questionLength: questionLength,
                onPressed: startOver,
              ));
      return;
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please select any option'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20.0)));
      }
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        score++;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  void openNotesBox(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => NotesBox());
  }

  void openProfileBox(BuildContext context) {
    var db = DBConnect();
    db.fetchUser(this.widget.uniqueID, context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<Question>;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: background,
              appBar: AppBar(
                title: const Text('Quizzz! App'),
                backgroundColor: background,
                shadowColor: Colors.transparent,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Score: $score',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  )
                ],
              ),
              body: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(children: [
                  const SizedBox(
                    height: 25.0,
                  ),
                  QuestionWidget(
                      question: extractedData[index].title,
                      indexAction: index,
                      totalQuestions: extractedData.length),
                  const Divider(
                    color: neutral,
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  for (int i = 0; i < extractedData[index].options.length; i++)
                    GestureDetector(
                      onTap: () => checkAnswerAndUpdate(
                          extractedData[index].options.values.toList()[i]),
                      child: OptionCard(
                        option: extractedData[index].options.keys.toList()[i],
                        color: isPressed
                            ? extractedData[index].options.values.toList()[i] ==
                                    true
                                ? correct
                                : incorrect
                            : neutral,
                      ),
                    ),
                ]),
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => NextQuestion(extractedData.length),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: NextButton(),
                    ),
                  ),
                  const Divider(
                    thickness: 2.0,
                    color: Colors.white,
                  ),
                  // const SizedBox(
                  //   height: 25.0,
                  // ),
                  GestureDetector(
                    onTap: () => {openNotesBox(context)},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: ViewNotesButton(),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                    onTap: () => {openProfileBox(context)},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: ViewProfileButton(),
                    ),
                  ),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Loading Questions...',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.none,
                      fontSize: 18.0),
                )
              ],
            ),
          );
        }
        return const Center(
          child: Text('No Data'),
        );
      },
    );
  }
}
