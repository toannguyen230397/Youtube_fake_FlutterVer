import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    TextEditingController titleController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: TextField(
            controller: titleController,
          ),
        ),
      ),
    );
  }
}