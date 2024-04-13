import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<void> showMyDialogBuilder({required BuildContext context, required String alertTitle, required String alertContent}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(alertTitle),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(alertContent),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Xác Nhận'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}