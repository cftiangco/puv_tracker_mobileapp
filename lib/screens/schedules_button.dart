import 'package:flutter/material.dart';

class SchedulesButton extends StatefulWidget {
  const SchedulesButton({
    Key? key,
    required this.acceptPassenger,
    required this.data,
  }) : super(key: key);

  final Function acceptPassenger;
  final data;

  @override
  State<SchedulesButton> createState() => _SchedulesButtonState();
}

class _SchedulesButtonState extends State<SchedulesButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Center(
            child: Text(
              'Click Schedule below to start accepting passengers',
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.data?['data']?.length,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: (() => widget
                      .acceptPassenger(widget.data?['data'][index]['id'] ?? 0)),
                  child: Text(
                    widget.data?['data']?[index]['description'] ?? '',
                    style: TextStyle(
                      fontSize: 19.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
