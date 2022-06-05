import 'package:flutter/material.dart';
import 'package:puv_tracker/pages/home_passenger.dart';

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
    required this.arriving,
    required this.discount,
    required this.status,
    required this.passengers,
  }) : super(key: key);
  final locationTo;
  final location;
  final departing;
  final arriving;
  final fare;
  final tripId;
  final handleCancel;
  final handleCompleted;
  final discount;
  final status;
  final passengers;
  @override
  State<ActiveSession> createState() => _ActiveSessionState();
}

class _ActiveSessionState extends State<ActiveSession> {
  void handleRefreshSession() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePassenger()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var _passengerStatus = "Waiting";

    switch (this.widget.status) {
      case 1:
        _passengerStatus = "On terminal";
        break;
      case 2:
        _passengerStatus = "On the way to your destination";
        break;
      case 3:
        _passengerStatus = "Completed";
        break;
    }

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
            label: 'Discount Type:',
            value: this.widget.discount,
          ),
          SizedBox(height: 20.0),
          TextValue(
            label: 'No. of Passenger(s):',
            value: this.widget.passengers.toString(),
          ),
          SizedBox(height: 20.0),
          TextValue(
            label: 'Fare:',
            value: '₱${this.widget.fare}',
          ),
          SizedBox(height: 20.0),
          TextValue(
            label: 'Destination:',
            value: this.widget.locationTo,
          ),
          SizedBox(height: 20.0),
          TextValue(
            label: "Passenger's Status:",
            value: _passengerStatus,
          ),
          SizedBox(height: 20.0),
          TextValue(
            label: "Departing Time:",
            value: this.widget.departing,
          ),
          SizedBox(height: 20.0),
          TextValue(
            label: "Arriving Time:",
            value: this.widget.arriving,
          ),
          SizedBox(height: 20.0),
          Divider(),
          SizedBox(height: 20.0),
          TextButton(
            onPressed: handleRefreshSession,
            child: Text(
              'Refresh',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 20.0,
              ),
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     TextButton(
          //       onPressed: () =>
          //           this.widget.handleCompleted(this.widget.tripId),
          //       child: Text(
          //         'Completed',
          //         style: TextStyle(
          //           color: Colors.green,
          //           fontSize: 20.0,
          //         ),
          //       ),
          //     ),
          //     TextButton(
          //       onPressed: () => this.widget.handleCancel(this.widget.tripId),
          //       child: Text(
          //         'Cancel',
          //         style: TextStyle(
          //           color: Colors.red,
          //           fontSize: 20.0,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
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
