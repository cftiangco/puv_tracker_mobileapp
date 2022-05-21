import 'package:flutter/material.dart';
import 'package:puv_tracker/widgets/passenger_card.dart';

class Passengers extends StatefulWidget {
  const Passengers(
      {Key? key,
      required this.passengers,
      required this.dropButton,
      required this.endTrip,
      required this.handleDrive,
      this.isDriving = false,
      this.handleRefresh})
      : super(key: key);
  final passengers;
  final dropButton;
  final endTrip;
  final handleDrive;
  final isDriving;
  final handleRefresh;
  @override
  _PassengersState createState() => _PassengersState();
}

class _PassengersState extends State<Passengers> {
  Future<void> handleRefresh() async {
    print('hello');
  }

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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text(
                //   'Completed: 4/8',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 20.0,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    this.widget.isDriving
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                            ),
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
                            child: Text('End Driving'),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Confirmation'),
                                  content: Text(
                                    'Are you sure you want to start driving now?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        this.widget.handleDrive();
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
                            child: Text('Start Driving'),
                          ),
                    SizedBox(
                      width: 10.0,
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: this.widget.passengers?.length > 0
                ? ListView.builder(
                    itemCount: widget.passengers?.length ?? 0,
                    itemBuilder: (context, index) {
                      return PassengerCard(
                        statusId: widget.passengers[index]['status_id'] ?? 0,
                        onPress: () => widget
                            .dropButton(widget.passengers?[index]['id'] ?? 0),
                        fullName:
                            widget.passengers[index]['full_name'].toString(),
                        typeName:
                            widget.passengers[index]['type']?.toString() ??
                                'Regular',
                        location:
                            widget.passengers[index]['location'].toString(),
                        fee: widget.passengers?[index]['fare'].toString(),
                        arrived: widget.passengers[index]['arrived'].toString(),
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: this.widget.handleRefresh,
                        child: Text('Click here to refresh'),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
