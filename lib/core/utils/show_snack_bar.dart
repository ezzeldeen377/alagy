import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String content) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content)));
}

showCustomDialog(
    BuildContext context, String content, void Function() onPressed) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Alert"),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed,
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
