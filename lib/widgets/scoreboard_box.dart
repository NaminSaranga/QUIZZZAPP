import 'package:ctse_quiz_app/models/db_connect.dart';
import 'package:ctse_quiz_app/models/saveScore_model.dart';
import 'package:ctse_quiz_app/widgets/individualScore_box.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class ScoreBoard extends StatelessWidget {
  const ScoreBoard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var db = DBConnect();

    Future<List<SaveScore>> getData() async {
      return db.fetchScores();
    }

    late Future _scores = getData();

    void openIndividualProfile(
        String uniqueKey, String name, String score, String lastName) {
      showDialog(
          context: context,
          builder: (ctx) => IndividualScoreBox(
              uniqueKey: uniqueKey,
              name: name,
              score: score,
              lastName: lastName));
    }

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
                  'Scoreboard',
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
                FutureBuilder(
                    future: _scores as Future<List<SaveScore>>,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text(
                              'No Scores in the Board yet..',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          var extractedData = snapshot.data as List<SaveScore>;
                          return Container(
                            height: extractedData.length * 80.0,
                            width: 300.0,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: extractedData.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      openIndividualProfile(
                                          extractedData[index].uniqueKey,
                                          extractedData[index].name,
                                          extractedData[index].score,
                                          extractedData[index].lastName);
                                    },
                                    title: Text(extractedData[index].name +
                                        " " +
                                        extractedData[index].lastName),
                                    subtitle: Text(extractedData[index].score),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const Text("SOMETHING's WRONG");
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
                                'Loading Scoreboard...',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.none,
                                    fontSize: 18.0),
                              )
                            ],
                          ),
                        );
                      }
                    })
              ]),
        ),
      ),
    );
  }
}
