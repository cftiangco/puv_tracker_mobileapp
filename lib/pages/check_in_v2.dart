import 'package:flutter/material.dart';
import 'package:puv_tracker/pages/home_passenger.dart';
import 'package:puv_tracker/widgets/PUV_Button.dart';
import 'package:puv_tracker/widgets/text_value.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class CheckInV2 extends StatefulWidget {
  const CheckInV2({
    Key? key,
    @required this.userId,
    @required this.token,
    @required this.locationId,
    @required this.location,
    @required this.fare,
    this.destination,
    this.currentBalance,
    this.tripId,
  }) : super(key: key);
  final userId;
  final token;
  final locationId;
  final destination;
  final location;
  final fare;
  final currentBalance;
  final tripId;
  @override
  State<CheckInV2> createState() => _CheckInV2State();
}

class _CheckInV2State extends State<CheckInV2> {
  var computation;
  var subTotal;
  String _noOfPassengers = "1";

  void handleCheckIn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text(
          "Once you confirm you'll be charged on this transaction",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              this.checkIn();
            },
            child: Text('Confirm'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  void checkIn() async {
    var payload = {
      "trip_id": this.widget.tripId,
      "passenger_id": this.widget.userId,
      "location": this.widget.locationId,
      "location_id": this.widget.locationId,
      "passengers": _noOfPassengers,
      "fare": this.computation?['subTotal'] ?? 0,
    };
    try {
      final res = await http.post(
        Uri.parse('http://puvtrackingsystem.xyz/api/v2/checkin'),
        body: json.encode(payload),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${this.widget.token}',
        },
      );
      var result = jsonDecode(res.body);
      if (result?['success']) {
        setState(() {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePassenger()),
          );
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Alert'),
            content: Text(result?['message']),
            actions: [
              TextButton(
                onPressed: () => {
                  Navigator.pop(context),
                  Navigator.pop(context),
                  Navigator.pop(context),
                  Navigator.pop(context),
                },
                child: Text('Ok'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void getComputation(int noPassengers) async {
    try {
      var res = await http.get(
        Uri.parse(
            'http://puvtrackingsystem.xyz/api/fare/${this.widget.userId}/${this.widget.locationId}/${noPassengers}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${this.widget.token}'
        },
      );
      setState(() {
        computation = jsonDecode(res.body)['data'];
        print(computation);
      });
    } catch (e) {
      print(e);
    }
  }

  void handleNoOfPassengerChange(value) {
    setState(() {
      _noOfPassengers = value;
      getComputation(int.parse(_noOfPassengers));
    });
  }

  @override
  void initState() {
    getComputation(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Center(
              child: Text(
                this.widget.destination ?? 'Loading...',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 50),
            TextValue(
              label: 'Your current balance',
              value: '₱${this.widget.currentBalance ?? 'Calculating..'}',
            ),
            SizedBox(height: 50),
            TextValue(
              label: 'Your location:',
              value: this.widget.location ?? 'Loading...',
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select No. Passengers:',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                DropdownButton<String>(
                  items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    );
                  }).toList(),
                  value: _noOfPassengers,
                  onChanged: this.handleNoOfPassengerChange,
                )
              ],
            ),
            SizedBox(height: 20),
            TextValue(
              label: 'Fare:',
              value: '₱${this.widget.fare ?? '0'}',
            ),
            SizedBox(height: 20),
            TextValue(
              label: 'Discount:',
              value: "- ₱${this.computation?['discount'] ?? 'Calculating..'}",
            ),
            SizedBox(height: 20),
            Divider(
              height: 10.0,
            ),
            TextValue(
              label: 'Sub total:',
              value: "₱${this.computation?['subTotal'] ?? 'Calculating..'}",
            ),
            SizedBox(height: 30),
            PUVButton(
              label: 'Check In',
              onPress: this.handleCheckIn,
            ),
          ],
        ),
      ),
    );
  }
}
