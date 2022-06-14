import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:puv_tracker/pages/locations.dart';
import 'package:puv_tracker/screens/active_session.dart';
import 'package:puv_tracker/screens/available_trips.dart';
import 'package:puv_tracker/services/pref_service.dart';
import 'package:puv_tracker/widgets/PUV_drawer.dart';
import 'package:http/http.dart' as http;

class HomePassenger extends StatefulWidget {
  const HomePassenger({Key? key}) : super(key: key);

  @override
  State<HomePassenger> createState() => _HomePassengerState();
}

class _HomePassengerState extends State<HomePassenger> {
  var availables;
  var id;
  var token;
  var isActive = false;
  var activeSession;
  var balance;
  var locations;

  void getAvailable() async {
    try {
      var res = await http.get(
        Uri.parse('http://puvtrackingsystem.xyz/api/available'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${this.token}'
        },
      );
      setState(() {
        this.availables = jsonDecode(res.body);
        print(this.availables);
      });
    } catch (e) {
      print(e);
    }
  }

  void getCache() async {
    PrefService _pref = new PrefService();
    this.id = await _pref.readId();
    this.token = await _pref.readToken();
    setState(() {
      this.getAvailable();
      this.handleActive();
      this.getBalance();
    });
  }

  void getBalance() async {
    try {
      var res = await http.get(
        Uri.parse('http://puvtrackingsystem.xyz/api/balance/${this.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${this.token}'
        },
      );
      setState(() {
        this.balance = jsonDecode(res.body);
      });
    } catch (e) {
      print(e);
    }
  }

  void handleCheckIn(
      id, destination, currentBalance, tripId, seats, passengers) async {
    if (seats == passengers) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Warning'),
          content: Text("Sorry this schedule is already full"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    try {
      var res = await http.get(
        Uri.parse('http://puvtrackingsystem.xyz/api/locations/${id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${this.token}'
        },
      );
      setState(() {
        this.locations = jsonDecode(res.body);
        print(this.locations);
        print("id: ${id}");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Locations(
              data: this.locations?['data'],
              userId: this.id,
              token: this.token,
              destination: destination,
              currentBalance: currentBalance,
              tripId: tripId,
            ),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> handleRefresh() async {
    this.getCache();
  }

  void handleActive() async {
    try {
      var res = await http.get(
        Uri.parse('http://puvtrackingsystem.xyz/api/active/${this.id}/trip'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${this.token}'
        },
      );
      setState(() {
        this.activeSession = jsonDecode(res.body);
        print(this.activeSession);
        if (this.activeSession?['success']) {
          isActive = true;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void handleCancel(id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text(
          'Are you sure you want to cancel your session?',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                final res = await http.put(
                  Uri.parse(
                      'http://puvtrackingsystem.xyz/api/trips/${id}/cancel'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ${this.token}',
                  },
                );
                var result = jsonDecode(res.body);
                if (result?['success'] == true) {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePassenger()),
                    );
                  });
                }
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

  void handleCompleted(id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text(
          'Are you sure you want to mark your session as completed?',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                final res = await http.put(
                  Uri.parse(
                      'http://puvtrackingsystem.xyz/api/trips/${id}/drop'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer ${this.token}',
                  },
                );
                var result = jsonDecode(res.body);
                if (result?['success'] == true) {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePassenger()),
                    );
                  });
                }
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
    print('token: ${this.token}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger'),
      ),
      drawer: PUVDrawer(),
      body: RefreshIndicator(
        onRefresh: this.handleRefresh,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/home-background.jpg"),
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.8),
                    BlendMode.dstATop,
                  ),
                ),
              ),
              height: 150,
              width: double.infinity,
              // color: Colors.blue[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '₱${this.balance?['data'] ?? '0'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Your Current Balance',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
            this.isActive
                ? ActiveSession(
                    locationTo: this.activeSession?['data']?['location_to'] ??
                        'Loading..',
                    location:
                        this.activeSession?['data']?['loc'] ?? 'Loading..',
                    departing: this.activeSession?['data']?['departing'] ??
                        'Loading..',
                    arriving:
                        this.activeSession?['data']?['arriving'] ?? 'Loading..',
                    fare: this.activeSession?['data']?['fare'] ?? 'Loading..',
                    tripId: this.activeSession?['data']?['id'] ?? 0,
                    discount:
                        this.activeSession?['data']?['type'] ?? 'Loading..',
                    status:
                        this.activeSession?['data']?['driver_status_id'] ?? 0,
                    passengers: this.activeSession?['data']?['passengers'] ?? 0,
                    handleCancel: this.handleCancel,
                    handleCompleted: this.handleCompleted,
                  )
                : available_trips(
                    data: this.availables?['data'],
                    handleCheckIn: this.handleCheckIn,
                    currentBalance: this.balance?['data'],
                  ),
          ],
        ),
      ),
    );
  }
}
