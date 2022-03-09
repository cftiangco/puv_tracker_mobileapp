import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:puv_tracker/screens/passengers.dart';
import 'package:puv_tracker/screens/schedules_button.dart';
import 'package:puv_tracker/services/pref_service.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../widgets/PUV_drawer.dart';

class HomeDriver extends StatefulWidget {
  const HomeDriver({Key? key}) : super(key: key);

  @override
  State<HomeDriver> createState() => _HomeDriver();
}

class _HomeDriver extends State<HomeDriver> {
  var isAccepting = false;

  var token;
  var fullName;
  var id;
  var routes;
  var passengers;

  void getId() async {
    PrefService _pref = new PrefService();
    this.id = await _pref.readId();
    setState(() {
      this.getData();
      this.getPassengers();
    });
  }

  void getToken() async {
    PrefService _pref = new PrefService();
    token = await _pref.readToken();
    setState(() {});
  }

  Future<void> getData() async {
    var res = await http.get(
      Uri.parse('http://puvtrackingsystem.xyz/api/schedules/${this.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${this.token}'
      },
    );
    setState(() {
      this.routes = jsonDecode(res.body);
    });
  }

  Future<void> getPassengers() async {
    try {
      var res = await http.get(
        Uri.parse('http://puvtrackingsystem.xyz/api/trips/${this.id}/active'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${this.token}'
        },
      );
      this.passengers = jsonDecode(res.body);
      setState(() {
        if (this.passengers['data']?.length > 0) {
          this.isAccepting = true;
        }
      });
      print(this.passengers);
    } catch (e) {
      print(e);
    }
  }

  void acceptPassengers(slotId) async {
    try {
      final res = await post(
        Uri.parse('http://puvtrackingsystem.xyz/api/trips'),
        body: json.encode({'driver_id': this.id, 'slot_id': slotId}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${this.token}',
        },
      );
      var result = jsonDecode(res.body);
      if (result['success']) {
        setState(() {
          this.isAccepting = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void dropPassenger(tripPassengerId) async {
    try {
      final res = await put(
        Uri.parse(
            'http://puvtrackingsystem.xyz/api/trips/${tripPassengerId}/drop'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${this.token}',
        },
      );
      var result = jsonDecode(res.body);
      if (result['success'] == true) {
        this.getPassengers();
      }
    } catch (e) {
      print(e);
    }
  }

  void handleEndTrip() async {
    try {
      final res = await post(
        Uri.parse('http://puvtrackingsystem.xyz/api/trips/${this.id}/end'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${this.token}',
        },
      );
      var result = jsonDecode(res.body);
      if (result['success']) {
        setState(() {
          this.isAccepting = false;
          this.getData();
        });
      } else {
        // if there's a active passengers
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Message'),
            content: Text(
              result['message'].toString(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
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

  @override
  void initState() {
    this.getToken();
    this.getId();
    this.getData();
    this.getPassengers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PUV Tracker'),
      ),
      drawer: PUVDrawer(),
      body: isAccepting == true
          ? Passengers(
              dropButton: (id) => {this.dropPassenger(id)},
              passengers: this.passengers['data'],
              endTrip: this.handleEndTrip,
            )
          : SchedulesButton(
              acceptPassenger: (slotId) => this.acceptPassengers(slotId),
              data: this.routes,
            ),
    );
  }
}
