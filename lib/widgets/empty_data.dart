import 'package:flutter/material.dart';

Widget EmptyDataWidget({required String Label}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/images/nodata.jpg'),
      Text(
        Label,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black26),
      )
    ],
  );
}
