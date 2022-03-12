import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:puv_tracker/pages/home_passenger.dart';
import 'package:puv_tracker/services/pref_service.dart';
import 'package:puv_tracker/widgets/PUV_Button.dart';
import 'package:puv_tracker/widgets/PUV_text_field.dart';
import 'package:http/http.dart' as http;

class CheckIn extends StatefulWidget {
  const CheckIn({
    Key? key,
    required this.tripId,
  }) : super(key: key);
  final tripId;
  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  TextEditingController destinationController = new TextEditingController();
  var id;
  var token;
  var info;
  void getCache() async {
    PrefService _pref = new PrefService();
    this.id = await _pref.readId();
    this.token = await _pref.readToken();
    setState(() {
      this.getTrip();
    });
  }

  void getTrip() async {
    try {
      var res = await http.get(
        Uri.parse(
            "http://puvtrackingsystem.xyz/api/checkin/${this.id}/info/${this.widget.tripId}"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${this.token}'
        },
      );
      print(res.body);
      setState(() {
        this.info = jsonDecode(res.body);
      });
    } catch (e) {
      print(e);
    }
  }

  void handleCheckIn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text(
          'Are you sure you want check-in now?',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              //handle submit here
              var payload = {
                "trip_id": this.widget.tripId,
                "passenger_id": this.id,
                "location": this.destinationController.text,
                "fare": this.info?['data']?['total'] ?? 0
              };

              try {
                final res = await http.post(
                  Uri.parse('http://puvtrackingsystem.xyz/api/checkin'),
                  body: json.encode(payload),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ${this.token}',
                  },
                );
                var result = jsonDecode(res.body);
                print(result);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePassenger()),
                );
              } catch (e) {
                print(e);
              }
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    this.getCache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // this.getCache();
    print(this.info);
    return Scaffold(
      appBar: AppBar(
        title: Text('Check In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              Center(
                child: Text(
                  this.info?['data']?['destination'] ?? "loading...",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Arrive Time: ${this.info?['data']?['arrived'] ?? "loading..."}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 50),
              TextValue(
                label: 'Your current balance',
                value: '₱${this.info?['balance'] ?? "loading..."}',
              ),
              SizedBox(height: 50),
              TextValue(
                label: 'Fare:',
                value: '₱${this.info?['data']?['fee'] ?? "loading..."}',
              ),
              SizedBox(height: 20),
              TextValue(
                label: 'Discount:',
                value: '${this.info?['data']?['discount'] ?? "loading..."}',
              ),
              SizedBox(height: 20),
              Divider(
                height: 10.0,
              ),
              TextValue(
                label: 'Sub Total:',
                value: '₱${this.info?['data']?['total'] ?? "loading..."}',
              ),
              SizedBox(height: 30),
              PUVTextField(
                hint: 'Your Destination',
                controller: this.destinationController,
              ),
              SizedBox(height: 30),
              PUVButton(
                label: 'Check In',
                onPress: this.handleCheckIn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
