import 'package:flutter/material.dart';

void showAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required Function()? onPressed,
}) {
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: onPressed,
        child: const Text('OK'),
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
