import 'package:flutter/material.dart';
import 'package:puv_tracker/pages/check_in_v2.dart';

class Locations extends StatefulWidget {
  const Locations({
    Key? key,
    @required this.data,
    @required this.userId,
    @required this.token,
    this.destination,
    this.currentBalance,
    this.tripId,
  }) : super(key: key);
  final data;
  final userId;
  final token;
  final destination;
  final currentBalance;
  final tripId;
  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  void handleSelectedLocation({id, location, fare}) {
    if (double.parse(this.widget.currentBalance) < double.parse(fare)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Warning'),
          content: Text(
            "You don't have enough balance to complete this transaction",
          ),
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
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckInV2(
            locationId: id,
            location: location,
            userId: this.widget.userId,
            token: this.widget.token,
            destination: this.widget.destination,
            currentBalance: this.widget.currentBalance,
            fare: fare,
            tripId: this.widget.tripId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Location'),
        ),
        body: ListView.builder(
          itemCount: this.widget.data?.length,
          itemBuilder: (context, index) {
            return LocationCard(
              location: this.widget.data[index]['location'],
              fare: this.widget.data[index]['fare'],
              onPress: () => this.handleSelectedLocation(
                id: this.widget.data[index]['id'],
                location: this.widget.data[index]['location'],
                fare: this.widget.data[index]['fare'],
              ),
            );
          },
        ));
  }
}

class LocationCard extends StatelessWidget {
  LocationCard({
    required this.onPress,
    required this.location,
    required this.fare,
    Key? key,
  }) : super(key: key);

  final location;
  final fare;
  final onPress;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(this.location),
            Text("₱${this.fare}"),
          ],
        ),
        onTap: this.onPress,
      ),
    );
  }
}
