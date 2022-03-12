import 'package:flutter/material.dart';
import 'package:puv_tracker/widgets/PUV_Button.dart';
import 'package:puv_tracker/widgets/PUV_text_field.dart';

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
            onPressed: () {
              //handle submit here
              print(widget.tripId);
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
  }

  @override
  Widget build(BuildContext context) {
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
                  'SM North to SM Fairview',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Arrive Time: 4:30PM',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 50),
              TextValue(
                label: 'Your current balance',
                value: '₱455.43',
              ),
              SizedBox(height: 50),
              TextValue(
                label: 'Fare:',
                value: '₱32.0',
              ),
              SizedBox(height: 20),
              TextValue(
                label: 'Discount (Student):',
                value: '12%',
              ),
              SizedBox(height: 20),
              Divider(
                height: 10.0,
              ),
              TextValue(
                label: 'Sub Total:',
                value: '₱28.0',
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
            fontSize: 23.0,
          ),
        ),
        Text(
          this.value,
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
