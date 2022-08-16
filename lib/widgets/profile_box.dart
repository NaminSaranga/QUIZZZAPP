import 'package:ctse_quiz_app/models/db_connect.dart';
import 'package:ctse_quiz_app/models/user_model.dart';
import 'package:ctse_quiz_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ProfileBox extends StatelessWidget {
  ProfileBox(
      {Key? key,
      required this.uniqueKey,
      required this.firstname,
      required this.lastname,
      required this.age,
      required this.address})
      : super(key: key);

  String uniqueKey;
  String firstname;
  String lastname;
  String age;
  String address;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  onPressedUpdateUser(BuildContext context) {
    var db = DBConnect();

    User user = User(
        firstname: firstNameController.text,
        lastname: lastNameController.text,
        age: ageController.text,
        address: addressController.text);

    db.updateUser(uniqueKey, user).then((value) => {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.RIGHSLIDE,
                  title: 'Success',
                  desc: 'Successfully Updated User',
                  autoHide: Duration(milliseconds: 1500))
              .show()
        });
  }

  onPressedDelete(BuildContext context, String uniqueIndex) {
    var db = DBConnect();

    db.deleteUser(uniqueKey).then((value) => {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (ctx) => LoginScreen()))
        });
  }

  @override
  Widget build(BuildContext context) {
    firstNameController.text = firstname;
    lastNameController.text = lastname;
    ageController.text = age;
    addressController.text = address;

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
                  'Personal Profile',
                  style: TextStyle(color: neutral, fontSize: 22.0),
                ),
                const SizedBox(height: 20.0),
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
                const SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  child: const Text(
                    'First Name : ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Color.fromARGB(255, 19, 255, 50),
                        fontSize: 15.0,
                        letterSpacing: 1.0),
                  ),
                ),
                const SizedBox(height: 5.0),
                TextField(
                  controller: firstNameController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.amberAccent, width: 5.0)),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                Container(
                  width: double.infinity,
                  child: const Text(
                    'Last Name : ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Color.fromARGB(255, 19, 255, 50),
                        fontSize: 15.0,
                        letterSpacing: 1.0),
                  ),
                ),
                const SizedBox(height: 5.0),
                TextField(
                  controller: lastNameController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.amberAccent, width: 5.0)),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                Container(
                  width: double.infinity,
                  child: const Text(
                    'Age : ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Color.fromARGB(255, 19, 255, 50),
                        fontSize: 15.0,
                        letterSpacing: 1.0),
                  ),
                ),
                const SizedBox(height: 5.0),
                TextField(
                  controller: ageController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.amberAccent, width: 5.0)),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10.0),
                Container(
                  width: double.infinity,
                  child: const Text(
                    'Address : ',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Color.fromARGB(255, 19, 255, 50),
                        fontSize: 15.0,
                        letterSpacing: 1.0),
                  ),
                ),
                const SizedBox(height: 5.0),
                TextField(
                  controller: addressController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white, width: 1.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.amberAccent, width: 5.0)),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () => {onPressedUpdateUser(context)},
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(
                        color: Color.fromARGB(255, 223, 152, 0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0),
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () => {onPressedDelete(context, uniqueKey)},
                  child: const Text(
                    'Delete Profile',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 51, 51),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
