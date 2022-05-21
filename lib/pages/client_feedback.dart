import 'package:flutter/material.dart';

class ClientFeedback extends StatelessWidget {
  const ClientFeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Feedback'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.0,
              ),
              Text(
                'Please write your feedback.',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Your feedback..',
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 18),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Submit'),
              ),
            ],
          ),
        ));
  }
}
