import 'package:flutter/material.dart';
import 'package:puv_tracker/widgets/PUV_Button.dart';
import 'package:puv_tracker/widgets/PUV_text_field.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController birthday = new TextEditingController();
  TextEditingController LastName = new TextEditingController();
  TextEditingController firstName = new TextEditingController();
  TextEditingController middleName = new TextEditingController();
  TextEditingController MobileNo = new TextEditingController();
  TextEditingController userName = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController ConfirmPassword = new TextEditingController();
  DateTime date = DateTime(2022, 12, 24);
  int gender = 1;

  void handleSubmit() {
    print('lastname:' + this.LastName.text);
    print('firstname:' + this.firstName.text);
    print('middlename:' + this.middleName.text);
    print('birthday:' + this.birthday.text);
    print('mobileno:' + this.MobileNo.text);
    print('gender' + this.gender.toString());
    print('username' + this.userName.text);
    print('password' + this.password.text);
    print('confirm password' + this.ConfirmPassword.text);
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
              PUVTextField(
                controller: this.LastName,
                hint: 'Last Name',
              ),
              SizedBox(height: 10),
              PUVTextField(
                controller: this.firstName,
                hint: 'First Name',
              ),
              SizedBox(height: 10),
              PUVTextField(
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
              PUVTextField(
                controller: this.MobileNo,
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
                controller: this.ConfirmPassword,
                hint: 'Confirm Password',
              ),
              SizedBox(
                height: 10,
              ),
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
