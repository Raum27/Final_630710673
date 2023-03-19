class ResultPoll {
  final String choice;
  final int count;

  ResultPoll({
    required this.choice,
    required this.count,
  });

  factory ResultPoll.fromJson(Map<String, dynamic> json) {
    return ResultPoll(
      choice: json['choice'],
      count: json['count'],
    );
  }
}
