import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:puv_tracker/pages/home_passenger.dart';
import 'package:puv_tracker/services/pref_service.dart';
import 'package:puv_tracker/widgets/PUV_Button.dart';
import 'package:puv_tracker/widgets/PUV_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:puv_tracker/widgets/text_value.dart';

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
  var isError = false;
  var errorMessage = "";
  var id;
  var token;
  var info;
  void getCache() async {
    PrefService _pref = new PrefService();
    this.id = await _pref.readId();
    this.token = await _pref.readToken();
    setState(() {
      this.getTrip();
      this.getValidation();
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
      // print(res.body);
      setState(() {
        this.info = jsonDecode(res.body);
      });
    } catch (e) {
      print(e);
    }
  }

  void getValidation() async {
    try {
      var res = await http.get(
        Uri.parse(
            "http://puvtrackingsystem.xyz/api/checkin/${this.widget.tripId}/validation"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${this.token}'
        },
      );
      var result = jsonDecode(res.body);
      print(result);
      if (!result?['success']) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Message'),
            content: Text(
              result['message'].toString(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void handleCheckIn() {
    isError = false;
    if (this.destinationController.text == "") {
      setState(() {
        this.errorMessage = 'Destination field is required';
        isError = true;
      });
      return;
    }
    var balance = this.info['balance'].toString();
    if (double.parse(balance) < double.parse(this.info['data']['total'])) {
      print('balance not eno');
      setState(() {
        this.errorMessage = 'Your Balance is not enough please top-up first';
        isError = true;
      });
      return;
    }
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
                await http.post(
                  Uri.parse('http://puvtrackingsystem.xyz/api/checkin'),
                  body: json.encode(payload),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ${this.token}',
                  },
                );
                setState(() {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePassenger()),
                  );
                });
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
                value: '₱${this.info?['balance'] ?? "0"}',
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
              SizedBox(height: 10),
              this.isError
                  ? Text(
                      this.errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : SizedBox(),
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
