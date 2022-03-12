import 'package:flutter/material.dart';
import 'package:puv_tracker/pages/check_in.dart';
import 'package:puv_tracker/widgets/PUV_drawer.dart';
import 'package:puv_tracker/widgets/item_card2.dart';

class HomePassenger extends StatefulWidget {
  const HomePassenger({Key? key}) : super(key: key);

  @override
  State<HomePassenger> createState() => _HomePassengerState();
}

class _HomePassengerState extends State<HomePassenger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger'),
      ),
      drawer: PUVDrawer(),
      body: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.blue[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current Balance: ₱0',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
              ],
            ),
          ),
          TripCard(
            plateNo: 'ABC12345',
            slot: '4/8',
            fare: '45.0',
            destination: 'Bulacan - Pampanga',
            arrive: '1:45PM',
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckIn(
                    tripId: 1,
                  ),
                ),
              );
            },
          ),
          TripCard(
            plateNo: 'XYZ98123',
            slot: '2/8',
            fare: '32.0',
            destination: 'SM North - SM Fairview',
            arrive: '3:40PM',
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckIn(
                    tripId: 1,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  const TripCard({
    Key? key,
    this.plateNo,
    this.slot,
    this.fare,
    this.destination,
    this.arrive,
    required this.onPress,
  }) : super(key: key);

  final plateNo;
  final slot;
  final fare;
  final destination;
  final arrive;
  final onPress;
  @override
  Widget build(BuildContext context) {
    return ItemCard2(
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Plate #: ${this.plateNo}',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Slot: ${this.slot}',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                'Fare: ₱${this.fare}',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                '(${this.destination})',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Arrived Time: ${this.arrive}',
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
      icon: Icon(
        Icons.car_rental_rounded,
      ),
      onPress: this.onPress,
    );
  }
}
