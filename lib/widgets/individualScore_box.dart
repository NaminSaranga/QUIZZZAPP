import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ctse_quiz_app/models/db_connect.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class IndividualScoreBox extends StatelessWidget {
  IndividualScoreBox(
      {Key? key,
      required this.uniqueKey,
      required this.name,
      required this.score,
      required this.lastName})
      : super(key: key);

  final String uniqueKey;
  final String name;
  final String score;
  String lastName;

  TextEditingController nameController = TextEditingController();

  onPressedDelete(BuildContext context) {
    var db = DBConnect();
    db.deleteScore(uniqueKey).then((value) => {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.RIGHSLIDE,
                  title: 'Success',
                  desc: 'Successfully Deleted Score',
                  autoHide: Duration(milliseconds: 1500))
              .show()
        });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  onPressedUpdateLastName(BuildContext context) {
    var db = DBConnect();
    db.updateScore(uniqueKey, lastName).then((value) => {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.RIGHSLIDE,
                  title: 'Success',
                  desc: 'Successfully Updated Profile',
                  autoHide: Duration(milliseconds: 1500))
              .show()
        });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = lastName;
    return SingleChildScrollView(
      child: AlertDialog(
        backgroundColor: background,
        content: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Individual Profile',
                  style: TextStyle(color: neutral, fontSize: 22.0),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                GestureDetector(
                  onTap: () => {Navigator.pop(context)},
                  child: const Text(
                    'Close',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 80, 80),
                        fontSize: 15.0,
                        letterSpacing: 1.0),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Text(
                  name + " " + lastName,
                  style: const TextStyle(color: neutral, fontSize: 22.0),
                ),
                Text(
                  score,
                  style: const TextStyle(color: neutral, fontSize: 22.0),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1.0)),
                    hintStyle: const TextStyle(
                        height: 0.5, fontSize: 15.0, color: Colors.white),
                    hintText: "Enter Last Name",
                  ),
                  onChanged: (value) {
                    lastName = value;
                  },
                ),
                const SizedBox(
                  height: 15.0,
                ),
                GestureDetector(
                  onTap: () => {onPressedUpdateLastName(context)},
                  child: const Text(
                    'Update Last Name',
                    style: TextStyle(
                        color: Color.fromARGB(255, 80, 255, 226),
                        fontSize: 20.0,
                        letterSpacing: 1.0),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                GestureDetector(
                  onTap: () => {onPressedDelete(context)},
                  child: const Text(
                    'Delete Record',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 188, 80),
                        fontSize: 20.0,
                        letterSpacing: 1.0),
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
              ]),
        ),
      ),
    );
  }
}
