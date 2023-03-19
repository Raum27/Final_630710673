import 'package:election_2566_poll/models/resulpoll.dart';
import 'package:election_2566_poll/pages/my_scaffold.dart';
import 'package:election_2566_poll/services/api.dart';
import 'package:flutter/material.dart';

import '../../models/poll.dart';

class PollResultsPage extends StatelessWidget {
  final String question;
  final List<ResultPoll> re_poll;
  const PollResultsPage(
      {Key? key, required this.question, required this.re_poll})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(title: const Text('ผลโหวต')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // todo: Add your UI by replacing this Container()
        child: Container(
          child: Column(children: [
            Text('${question}'),
            Column(children: [_buildcount()])
          ]),
        ),
      ),
    );
  }

  Column _buildcount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < re_poll.length; ++i)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 30, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${re_poll[i].choice}'),
                Text('${re_poll[i].count}')
              ],
            ),
          )
      ],
    );
  }
}
