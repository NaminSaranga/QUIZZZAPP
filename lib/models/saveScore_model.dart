class SaveScore {
  final String uniqueKey;
  final String name;
  final String lastName;
  final String score;

  SaveScore(
      {required this.uniqueKey,
      required this.name,
      required this.score,
      required this.lastName});

  @override
  String toString() {
    return 'Question(id: $name,title: $score,uniqueKey: $uniqueKey)';
  }
}
