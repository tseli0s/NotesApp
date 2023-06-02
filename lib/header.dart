import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  String text = '';
  Color textColor = Colors.black;

  Header(this.text, this.textColor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32.0,
      ),
    );
  }
}
