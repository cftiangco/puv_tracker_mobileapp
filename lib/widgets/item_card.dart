import 'package:flutter/material.dart';

class ItemCards extends StatelessWidget {
  const ItemCards({
    this.label,
    required this.onPress,
    required this.icon,
    Key? key,
  }) : super(key: key);
  final label;
  final onPress;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(this.label),
        leading: this.icon,
        trailing: Icon(Icons.arrow_forward),
        onTap: this.onPress,
      ),
    );
  }
}
