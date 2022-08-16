import 'package:ctse_quiz_app/models/db_connect.dart';
import 'package:ctse_quiz_app/models/notes_model.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class NotesBox extends StatelessWidget {
  NotesBox({
    Key? key,
  }) : super(key: key);

  String note = "";

  TextEditingController noteController = TextEditingController();

  onPressedSaveResult(BuildContext context) {
    var db = DBConnect();
    Note newNote = Note(note: noteController.value.text);
    db.addNotes(newNote).then((value) => {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.SUCCES,
                  animType: AnimType.RIGHSLIDE,
                  title: 'Success',
                  desc: 'Successfully Noted !',
                  autoHide: Duration(milliseconds: 1500))
              .show()
        });
  }

  onPressedUpdateNote(BuildContext context, String function) {
    var db = DBConnect();
    if (function == "UPDATE") {
      db
          .updateNote("-My7ZqwK20G-KQ5K-ves", noteController.value.text)
          .then((value) => {
                AwesomeDialog(
                        context: context,
                        dialogType: DialogType.SUCCES,
                        animType: AnimType.RIGHSLIDE,
                        title: 'Success',
                        desc: 'Successfully Updated Note',
                        autoHide: Duration(milliseconds: 1500))
                    .show()
              });
    } else if (function == "CLEAR") {
      noteController.text = "";
      db.updateNote("-My7ZqwK20G-KQ5K-ves", "").then((value) => {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.SUCCES,
                    animType: AnimType.RIGHSLIDE,
                    title: 'Success',
                    desc: 'Successfully Cleared Note',
                    autoHide: Duration(milliseconds: 1500))
                .show()
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var db = DBConnect();

    Future<List<Note>> getData() async {
      return db.fetchNote();
    }

    late Future _note = getData();

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
                  'Notes By Everyone',
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
                FutureBuilder(
                  future: _note as Future<List<Note>>,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'No Notes Yet..',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (snapshot.hasData) {
                        var extractedData = snapshot.data as List<Note>;
                        noteController.text = extractedData[0].note;
                        return TextField(
                          controller: noteController,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.0)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.amberAccent, width: 5.0)),
                          ),
                          style: TextStyle(color: Colors.white),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'Somethings Wrong !..',
                            style: TextStyle(color: Colors.white),
                          ),
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
                              'Loading Notes...',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  decoration: TextDecoration.none,
                                  fontSize: 18.0),
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () => {onPressedUpdateNote(context, "UPDATE")},
                  child: const Text(
                    'Note',
                    style: TextStyle(
                        color: Color.fromARGB(255, 223, 152, 0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0),
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () => {onPressedUpdateNote(context, "CLEAR")},
                  child: const Text(
                    'Clear Notes',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 223, 205),
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
