import 'package:alagy/core/helpers/extensions.dart';
import 'package:alagy/core/helpers/navigator.dart';
import 'package:alagy/core/routes/routes.dart';
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

showCustomSnackBar({
  required BuildContext context,
  required String message,
  required bool isError,
}) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
}

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // Allows dismissing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Login Required',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: const Text(
          'You can\'t use this feature until you log in.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'Later',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              context.pushNamed(RouteNames.signIn);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
        elevation: 8,
      );
    },
  );
}

showToast(String content) {
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
