import 'package:flutter/material.dart';

class TextValue extends StatelessWidget {
  const TextValue({
    Key? key,
    this.label,
    this.value,
  }) : super(key: key);
  final label;
  final value;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          this.label,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        Text(
          this.value,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
