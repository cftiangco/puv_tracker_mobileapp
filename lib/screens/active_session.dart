import 'package:flutter/material.dart';

class ActiveSession extends StatefulWidget {
  const ActiveSession({
    Key? key,
    required this.locationTo,
    required this.location,
    required this.departing,
    required this.fare,
    required this.tripId,
    required this.handleCancel,
    required this.handleCompleted,
  }) : super(key: key);
  final locationTo;
  final location;
  final departing;
  final fare;
  final tripId;
  final handleCancel;
  final handleCompleted;
  @override
  State<ActiveSession> createState() => _ActiveSessionState();
}

class _ActiveSessionState extends State<ActiveSession> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          SizedBox(height: 30.0),
          Text(
            'You have successfully checked-in',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 30.0),
          TextValue(
            label: 'To:',
            value: this.widget.locationTo,
          ),
          SizedBox(height: 20.0),
          TextValue(
            label: 'Your Destination:',
            value: this.widget.location,
          ),
          SizedBox(height: 20.0),
          TextValue(
            label: 'Departing Time:',
            value: this.widget.departing,
          ),
          SizedBox(height: 20.0),
          TextValue(
            label: 'Fare:',
            value: '₱${this.widget.fare}',
          ),
          SizedBox(height: 20.0),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () =>
                    this.widget.handleCompleted(this.widget.tripId),
                child: Text(
                  'Completed',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20.0,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => this.widget.handleCancel(this.widget.tripId),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TextValue extends StatelessWidget {
  const TextValue({
    Key? key,
    required this.label,
    required this.value,
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
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
