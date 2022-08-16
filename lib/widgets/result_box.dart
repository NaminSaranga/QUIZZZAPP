import 'package:ctse_quiz_app/models/db_connect.dart';
import 'package:ctse_quiz_app/models/saveScore_model.dart';
import 'package:ctse_quiz_app/widgets/scoreboard_box.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ResultBox extends StatelessWidget {
  ResultBox({
    Key? key,
    required this.result,
    required this.questionLength,
    required this.onPressed,
  }) : super(key: key);

  final int result;
  final int questionLength;
  final VoidCallback onPressed;
  String name = "";

  TextEditingController nameController = TextEditingController();

  onPressedSaveResult(BuildContext context, String name) {
    var db = DBConnect();
    var score = result.toString() + "/" + questionLength.toString();
    SaveScore saveScore =
        SaveScore(uniqueKey: "", name: name, score: score, lastName: "");
    db.addSaveScore(saveScore).then((value) => {
          nameController.text = "",
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.RIGHSLIDE,
                  title: 'Success',
                  desc: 'Successfully Added Score',
                  autoHide: Duration(milliseconds: 1500))
              .show()
        });
  }

  viewOthersScore(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => const ScoreBoard());
  }

  @override
  Widget build(BuildContext context) {
    // String name = "";
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: background,
        content: Padding(
          padding: const EdgeInsets.all(70.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Result',
                  style: TextStyle(color: neutral, fontSize: 22.0),
                ),
                const SizedBox(height: 20.0),
                CircleAvatar(
                  child: Text(
                    '$result/$questionLength',
                    style: const TextStyle(fontSize: 30.0),
                  ),
                  radius: 70.0,
                  backgroundColor: result == questionLength / 2
                      ? Colors.yellow
                      : result < questionLength / 2
                          ? incorrect
                          : correct,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  result == questionLength / 2
                      ? 'Almost There!'
                      : result < questionLength / 2
                          ? 'Try Again'
                          : 'Nailed It!',
                  style: const TextStyle(color: neutral),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Container(
                  height: 35.0,
                  child: TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 1.0)),
                      hintStyle: const TextStyle(
                          height: 0.5, fontSize: 15.0, color: Colors.white),
                      hintText: "Enter Name",
                    ),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                GestureDetector(
                  onTap: () => onPressedSaveResult(context, name),
                  child: const Text(
                    'Save Result',
                    style: TextStyle(
                        color: Color.fromARGB(255, 80, 255, 214),
                        fontSize: 20.0,
                        letterSpacing: 1.0),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                GestureDetector(
                  onTap: () => viewOthersScore(context),
                  child: const Text(
                    'View Others Score',
                    style: TextStyle(
                      color: Color.fromARGB(255, 229, 255, 0),
                      fontSize: 15.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 80, 80),
                        fontSize: 20.0,
                        letterSpacing: 1.0),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
