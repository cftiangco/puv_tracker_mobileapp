import 'package:flutter/material.dart';

class PUVTextFormField extends StatelessWidget {
  const PUVTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.enable = true,
  }) : super(key: key);

  final TextEditingController controller;
  final labelText;
  final enable;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: this.labelText,
      ),
      controller: this.controller,
      enabled: this.enable,
    );
  }
}
