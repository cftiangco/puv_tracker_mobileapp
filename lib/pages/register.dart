import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:puv_tracker/services/pref_service.dart';
import 'package:puv_tracker/widgets/PUB_text_field_number.dart';
import 'package:puv_tracker/widgets/PUV_Button.dart';
import 'package:puv_tracker/widgets/PUV_text_field.dart';
import 'package:puv_tracker/widgets/PUV_text_field_character.dart';

import 'home_passenger.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController birthday = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController firstName = new TextEditingController();
  TextEditingController middleName = new TextEditingController();
  TextEditingController mobileNo = new TextEditingController();
  TextEditingController userName = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();
  DateTime date = DateTime(2012, 1, 1);
  int gender = 1;

  var isNoError = true;
  var errorMessage = "";

  void handleSubmit() async {
    this.isNoError = true;

    if (this.firstName.text.isEmpty) {
      this.isNoError = false;
      this.errorMessage = "First Name is a required field";
      setState(() {});
      return;
    }

    if (this.lastName.text.isEmpty) {
      this.isNoError = false;
      this.errorMessage = "Last Name is a required field";
      setState(() {});
      return;
    }

    if (this.birthday.text.isEmpty) {
      this.isNoError = false;
      this.errorMessage = "Birthday is a required field";
      setState(() {});
      return;
    }

    if (this.mobileNo.text.isEmpty) {
      this.isNoError = false;
      this.errorMessage = "Mobile # is a required field";
      setState(() {});
      return;
    }

    if (this.password.text.length < 6 || this.userName.text.length < 6) {
      this.isNoError = false;
      this.errorMessage = "Username or Password must be 6 characters long";
      setState(() {});
      return;
    }

    if (this.mobileNo.text.length > 11) {
      this.isNoError = false;
      this.errorMessage = "Mobile number must be 11 digits long";
      setState(() {});
      return;
    }

    if (this.password.text != this.confirmPassword.text) {
      this.isNoError = false;
      this.errorMessage = "Password didn't matched the confirm password";
      setState(() {});
      return;
    }

    final url = "http://puvtrackingsystem.xyz/api/register/";
    var values = {
      "last_name": this.lastName.text,
      "first_name": this.firstName.text,
      "middle_name": this.middleName.text,
      "mobileno": this.mobileNo.text,
      "birthday": this.birthday.text,
      "gender": this.gender,
      "username": this.userName.text,
      "password": this.password.text,
    };
    try {
      final res = await post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(values),
      );
      var result = jsonDecode(res.body);
      print(result);
      if (result.containsKey('errors')) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Message'),
            content: Text(
              result['errors']['username'].toString(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      if (result['success']) {
        PrefService _pref = new PrefService();
        await _pref.saveToken(result['token']);
        await _pref.saveFullName(
            '${result['data']['last_name']},${result['data']['first_name']} ${result['data']['middle_name']}');
        int id = int.parse(result['data']['id'].toString());
        await _pref.saveId(id);
        await _pref.saveType(result['type']);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePassenger()),
          (route) => false,
        );
        setState(() {});
        return;
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register New Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              PUVTextFieldCharacter(
                controller: this.lastName,
                hint: 'Last Name',
              ),
              SizedBox(height: 10),
              PUVTextFieldCharacter(
                controller: this.firstName,
                hint: 'First Name',
              ),
              SizedBox(height: 10),
              PUVTextFieldCharacter(
                controller: this.middleName,
                hint: 'Middle Name',
              ),
              SizedBox(height: 10),
              PUVTextField(
                controller: this.birthday,
                hint: 'Birthday',
                enabled: true,
                onTop: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );

                  if (newDate == null) return;
                  setState(() {
                    date = newDate;
                    this.birthday.text =
                        "${date.year}/${date.month}/${date.day}";
                  });
                },
              ),
              SizedBox(height: 10),
              PUVTextFieldNumber(
                controller: this.mobileNo,
                hint: 'Mobile #',
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: this.gender,
                    onChanged: (value) {
                      setState(() {
                        this.gender = int.parse(value.toString());
                      });
                    },
                  ),
                  Text('Male'),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 2,
                    groupValue: this.gender,
                    onChanged: (value) {
                      setState(() {
                        this.gender = int.parse(value.toString());
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              Text('Log-in Credential'),
              Divider(),
              SizedBox(height: 10),
              PUVTextField(
                controller: this.userName,
                hint: 'User Name',
              ),
              SizedBox(height: 10),
              PUVTextField(
                obscureText: true,
                controller: this.password,
                hint: 'Password',
              ),
              SizedBox(height: 10),
              PUVTextField(
                obscureText: true,
                controller: this.confirmPassword,
                hint: 'Confirm Password',
              ),
              SizedBox(
                height: 10,
              ),
              !this.isNoError
                  ? Text(
                      this.errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  : SizedBox(),
              PUVButton(
                label: 'Submit',
                onPress: handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
