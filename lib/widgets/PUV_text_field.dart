import 'package:flutter/material.dart';

class PUVTextField extends StatelessWidget {
  const PUVTextField(
      {Key? key,
      this.hint,
      this.controller,
      this.obscureText = false,
      this.enabled = true,
      this.onTop})
      : super(key: key);

  final hint;
  final controller;
  final obscureText;
  final onTop;
  final enabled;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: this.obscureText,
      decoration: InputDecoration(
        hintText: this.hint,
      ),
      controller: this.controller,
      onTap: this.onTop,
      enabled: this.enabled,
    );
  }
}
