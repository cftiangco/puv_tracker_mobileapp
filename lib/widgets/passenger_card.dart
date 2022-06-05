import 'package:flutter/material.dart';

class PassengerCard extends StatefulWidget {
  const PassengerCard({
    Key? key,
    this.fullName,
    this.typeName,
    this.location,
    this.arrived,
    this.fee,
    this.statusId,
    this.passengers,
    required this.onPress,
  }) : super(key: key);

  final fullName;
  final typeName;
  final location;
  final fee;
  final arrived;
  final Function() onPress;
  final statusId;
  final passengers;

  @override
  State<PassengerCard> createState() => _PassengerCardState();
}

class _PassengerCardState extends State<PassengerCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/student.png'),
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.widget.fullName ?? 'loading...',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(this.widget.typeName ?? 'loading...'),
                Text('Occupied: ${this.widget.passengers.toString()}'),
                Text('Location: ${this.widget.location ?? 'loading...'}'),
                Text('Fee: ${this.widget.fee ?? 'loading...'}'),
                this.widget.statusId == 2
                    ? Text('Arrived: ${this.widget.arrived}')
                    : SizedBox()
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: this.widget.statusId == 1
                ? TextButton(
                    child: Text(
                      'Drop',
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                    onPressed: widget.onPress,
                  )
                : this.widget.statusId == 2
                    ? Text(
                        'Completed',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        'Cancelled',
                        style: TextStyle(
                          color: Colors.red[100],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
