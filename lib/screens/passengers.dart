import 'package:flutter/material.dart';
import 'package:puv_tracker/widgets/passenger_card.dart';

class Passengers extends StatefulWidget {
  const Passengers({
    Key? key,
    required this.passengers,
    required this.dropButton,
    required this.endTrip,
  }) : super(key: key);
  final passengers;
  final dropButton;
  final endTrip;
  @override
  _PassengersState createState() => _PassengersState();
}

class _PassengersState extends State<Passengers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue[300],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed: 4/8',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Earning: P535'),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                              'Are you sure you want to end this Trip Now?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  this.widget.endTrip();
                                  Navigator.pop(context);
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
                      },
                      child: Text('End Trip'),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.passengers?.length ?? 0,
              itemBuilder: (context, index) {
                return PassengerCard(
                  statusId: widget.passengers[index]['status_id'] ?? 0,
                  onPress: () =>
                      widget.dropButton(widget.passengers?[index]['id'] ?? 0),
                  fullName: widget.passengers[index]['full_name'].toString(),
                  typeName:
                      widget.passengers[index]['type']?.toString() ?? 'Regular',
                  location: widget.passengers[index]['location'].toString(),
                  fee: widget.passengers?[index]['fee'].toString(),
                  arrived: widget.passengers[index]['arrived'].toString(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
