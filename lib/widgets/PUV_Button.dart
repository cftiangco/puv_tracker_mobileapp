import 'package:flutter/material.dart';

class PUVButton extends StatelessWidget {
  const PUVButton({Key? key, this.label, this.onPress}) : super(key: key);
  final label;
  final onPress;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      child: Text(
        label,
        style: TextStyle(fontSize: 16.0),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.only(left: 60.0, right: 60.0),
      ),
    );
  }
}
