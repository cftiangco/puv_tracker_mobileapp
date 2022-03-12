import 'package:flutter/material.dart';
import 'package:puv_tracker/widgets/item_card2.dart';

class available_trips extends StatefulWidget {
  const available_trips({
    Key? key,
    required this.data,
    required this.handleCheckIn,
  }) : super(key: key);

  final data;
  final handleCheckIn;

  @override
  State<available_trips> createState() => _available_tripsState();
}

class _available_tripsState extends State<available_trips> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: this.widget.data?.length ?? 0,
        itemBuilder: (context, index) {
          return TripCard(
            plateNo:
                this.widget.data[index]?['puv_platenumber'] ?? 'Loading...',
            slot:
                '${this.widget.data[index]['passengers']}/${this.widget.data[index]['number_of_seats']}',
            fare: this.widget.data[index]['fee'].toString(),
            destination:
                '${this.widget.data[index]['location_from']} - ${this.widget.data[index]['location_to']}',
            arrive: this.widget.data[index]['arrival'],
            onPress: () =>
                this.widget.handleCheckIn(this.widget.data[index]['id']),
          );
        },
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
