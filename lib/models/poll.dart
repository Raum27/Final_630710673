class Poll {
  final int id;
  final String question;
  final List<String> choices;

  Poll({
    required this.id,
    required this.question,
    required this.choices,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json['id'],
      question: json['question'],
      choices: (json['choices'] as List).map((item) => item as String).toList(),
    );
  }
}
