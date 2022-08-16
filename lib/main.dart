import 'package:ctse_quiz_app/screens/splash.dart';
import 'package:flutter/material.dart';
import './models/db_connect.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // var db = DBConnect();
  // db.addQuestion(
  //   Question(
  //       id: '1',
  //       title: "Sample Question",
  //       options: {'A': false, 'B': false, 'C': false, 'D': true}),
  // );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
