import 'package:flutter/material.dart';

class PUVTextField extends StatelessWidget {
  const PUVTextField({Key? key, this.hint, this.controller}) : super(key: key);

  final hint;
  final controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: this.hint,
      ),
      controller: this.controller,
    );
  }
}
