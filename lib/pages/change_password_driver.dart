import 'package:flutter/material.dart';
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
  var isPasswordMatched = true;
  var errorMessage = "";
  void handleChangePassword() {
    if (newPassword.text != ConfirmNewPassword.text) {
      setState(() {
        errorMessage = "New Password and Confirm Password not matched";
        this.isPasswordMatched = false;
      });
    } else {
      setState(() {
        this.isPasswordMatched = true;
      });

      print("current:" + this.currentPassword.text);
      print("new:" + this.newPassword.text);
      print("confirm" + this.ConfirmNewPassword.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
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
            this.isPasswordMatched
                ? SizedBox()
                : Text(
                    this.errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
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
