import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:puv_tracker/services/pref_service.dart';
import 'package:puv_tracker/widgets/PUV_Button.dart';
import 'package:puv_tracker/widgets/PUV_text_field.dart';

class ChangePasswordDriver extends StatefulWidget {
  const ChangePasswordDriver({Key? key}) : super(key: key);

  @override
  State<ChangePasswordDriver> createState() => _ChangePasswordDriverState();
}

class _ChangePasswordDriverState extends State<ChangePasswordDriver> {
  TextEditingController currentPassword = new TextEditingController();
  TextEditingController newPassword = new TextEditingController();
  TextEditingController ConfirmNewPassword = new TextEditingController();
  var token;
  var type;
  var id;
  void handleChangePassword() async {
    try {
      final res = await put(
        Uri.parse("http://puvtrackingsystem.xyz/api/changepassword"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${this.token}',
        },
        body: jsonEncode({
          "id": this.id,
          "type": this.type,
          "current_password": this.currentPassword.text,
          "new_password": this.newPassword.text,
        }),
      );
      var result = jsonDecode(res.body);
      if (result['success']) {
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
        this.currentPassword.text = "";
        this.ConfirmNewPassword.text = "";
        this.newPassword.text = "";
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Message'),
            content: Text(
              result['message'],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
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

  void getCache() async {
    PrefService _pref = new PrefService();
    this.type = await _pref.readType();
    this.id = await _pref.readId();
    this.token = await _pref.readToken();
    setState(() {});
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
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            PUVTextField(
              controller: this.currentPassword,
              hint: 'Current Password',
              obscureText: true,
            ),
            SizedBox(height: 10),
            PUVTextField(
              controller: this.newPassword,
              hint: 'New Password',
              obscureText: true,
            ),
            SizedBox(height: 10),
            PUVTextField(
              controller: this.ConfirmNewPassword,
              hint: 'Confirm New Password',
              obscureText: true,
            ),
            SizedBox(height: 10),
            PUVButton(
              label: 'Change',
              onPress: handleChangePassword,
            ),
          ],
        ),
      ),
    );
  }
}
