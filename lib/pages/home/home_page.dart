import 'dart:js';

import 'package:election_2566_poll/models/resulpoll.dart';
import 'package:flutter/material.dart';

import '../../etc/utils.dart';
import '../../models/poll.dart';
import '../../services/api.dart';
import '../my_scaffold.dart';
import '../poll_results/poll_results_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Poll>? _polls;
  List<ResultPoll>? re_polls;
  var _isLoading = false;
  var _isvote = false;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    // todo: Load list of polls here
    var result = await ApiClient().getAllPoll();
    setState(() {
      _polls = result;
    });
  }

  _loadVote(int id) async {
    // todo: Load list of polls here
    var result = await ApiClient().getIdPoll(id);
    setState(() {
      re_polls = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Column(
        children: [
          Image.network(
              'https://cpsu-test-api.herokuapp.com/images/election.jpg'),
          Expanded(
            child: Stack(
              children: [
                if (_polls != null) _buildList(),
                if (_isLoading) _buildProgress(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListView _buildList() {
    return ListView.builder(
      itemCount: _polls!.length,
      itemBuilder: (BuildContext context, int index) {
        // todo: Create your poll item by replacing this Container()
        var id = _polls![index].id;
        var question = _polls![index].question;
        var choices = _polls![index].choices;
        return Card(
            child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${id} ${question}'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildchoies(choices)],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 700,
                    height: 30,
                    child: ElevatedButton(
                        onPressed: () {
                          _loadVote(id);
                          _navigator(context, question, re_polls!);
                        },
                        child: Text('ดูผลโหวต'))),
              ),
            ],
          ),
        ));
      },
    );
  }

  Widget _buildProgress() {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(color: Colors.white),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('รอสักครู่', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

Column _buildchoies(List<String> choices) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var i = 0; i < choices.length; ++i)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 30, top: 8),
          child: OutlinedButton(
            onPressed: () {
              // var check = ApiClient().VoteCheckIn(i + 1);
              // _buildProgress();
              // showOkDialog(context, choices[i], check);
              // print(check);
            },
            child: Text(choices[i]),
          ),
        )
    ],
  );
}

void _navigator(
    BuildContext context, String question, List<ResultPoll> re_poll) {
  // for (var i = 0; i < re_poll.length; ++i) {
  //   // print(re_poll[i].choice + " " + '${re_poll[i].count}');
  // }
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              PollResultsPage(question: question, re_poll: re_poll)));
}
