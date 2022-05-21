import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:puv_tracker/services/pref_service.dart';
import 'package:puv_tracker/widgets/PUV_Button.dart';
import 'package:puv_tracker/widgets/PUV_text_form_field.dart';

class UpdateInformation extends StatefulWidget {
  const UpdateInformation({Key? key}) : super(key: key);

  @override
  State<UpdateInformation> createState() => _UpdateInformationState();
}

class _UpdateInformationState extends State<UpdateInformation> {
  var info;
  var token;
  var id;

  TextEditingController userName = new TextEditingController();
  TextEditingController passengerId = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController firstName = new TextEditingController();
  TextEditingController middleName = new TextEditingController();
  TextEditingController mobileNo = new TextEditingController();

  void getCache() async {
    PrefService _pref = new PrefService();
    this.id = await _pref.readId();
    this.token = await _pref.readToken();
    setState(() {
      this.getData();
    });
  }

  Future<void> getData() async {
    try {
      var res = await http.get(
        Uri.parse('http://puvtrackingsystem.xyz/api/passengers/${this.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer ${this.token}'
        },
      );
      setState(() {
        this.info = jsonDecode(res.body);
        this.passengerId.text = info['id'].toString() + " (Uneditable)";
        this.userName.text = info['username'] + " (Uneditable)";
        this.lastName.text = info['last_name'];
        this.firstName.text = info['first_name'];
        this.middleName.text = info['middle_name'];
        this.mobileNo.text = info['mobileno'];
      });
    } catch (e) {
      print(e);
    }
  }

  void handleUpdate() async {
    try {
      final res = await http.put(
        Uri.parse("http://puvtrackingsystem.xyz/api/passengers/${this.id}"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${this.token}',
        },
        body: jsonEncode({
          "id": this.id,
          "last_name": this.lastName.text,
          "first_name": this.firstName.text,
          "middle_name": this.middleName.text,
          "mobileno": this.mobileNo.text,
        }),
      );
      var result = jsonDecode(res.body);
      if (result['success']) {
        PrefService _pref = new PrefService();
        await _pref.saveFullName(
            '${result['data']['last_name']},${result['data']['first_name']} ${result['data']['middle_name']}');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Message'),
            content: Text(
              result['message'],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                },
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
    this.getCache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Information"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PUVTextFormField(
                controller: this.passengerId,
                labelText: 'Your Passenger ID',
                enable: false,
              ),
              PUVTextFormField(
                controller: this.userName,
                labelText: ' Your User Name',
                enable: false,
              ),
              PUVTextFormField(
                controller: lastName,
                labelText: 'Last Name',
              ),
              PUVTextFormField(
                controller: this.firstName,
                labelText: 'First Name',
              ),
              PUVTextFormField(
                controller: this.middleName,
                labelText: 'Middle Name',
              ),
              PUVTextFormField(
                controller: this.mobileNo,
                labelText: 'Mobile #',
              ),
              SizedBox(
                height: 10,
              ),
              PUVButton(
                label: 'Update',
                onPress: this.handleUpdate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
