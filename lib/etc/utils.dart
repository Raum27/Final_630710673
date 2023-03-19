import 'package:flutter/material.dart';

Future<void> showOkDialog(BuildContext context, String title, String content) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Text(content, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black87)),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
