import 'package:alagy/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
        title: Text(context.l10n.dialogAlertTitle),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed,
            child: Text(context.l10n.dialogOkButton),
          ),
        ],
      );
    },
  );
}
showToast(String content){
  Fluttertoast.showToast(
  msg: content,
  toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
  gravity: ToastGravity.BOTTOM, // Position (TOP, CENTER, BOTTOM)
  timeInSecForIosWeb: 1,
  backgroundColor: Colors.black,
  textColor: Colors.white,
  fontSize: 16.0,
);
}