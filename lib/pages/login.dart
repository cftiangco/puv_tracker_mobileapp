import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:puv_tracker/pages/home_driver.dart';
import 'package:puv_tracker/pages/register.dart';
import 'package:puv_tracker/services/pref_service.dart';

import '../widgets/PUV_Button.dart';
import '../widgets/PUV_text_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  var id = 0;
  var type = 0;

  void getIdAndType() async {
    PrefService _pref = new PrefService();
    this.id = await _pref.readId() ?? 0;
    this.type = await _pref.readType() ?? 0;
    if (this.id > 0 && this.type > 0) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeDriver()),
        );
      });
    }
  }

  final url = "http://puvtrackingsystem.xyz/api/login";

  void handleLogin() async {
    PrefService _pref = new PrefService();
    try {
      final res = await post(Uri.parse(url), body: {
        'username': this.usernameController.text,
        'password': this.passwordController.text
      });

      var result = jsonDecode(res.body);
      if (result['success'] == true) {
        if (result['type'] == 2) {
          await _pref.saveToken(result['token']);
          await _pref.saveFullName(
              '${result['data']['last_name']},${result['data']['first_name']} ${result['data']['middle_name']}');
          int id = int.parse(result['data']['id'].toString());
          await _pref.saveId(id);
          await _pref.saveType(result['type']);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeDriver()),
          );
          setState(() {});
        }
      } else {
        print('wrong');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    this.getIdAndType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 170,
              width: 170,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                ),
                // shape: BoxShape.circle,
              ),
            ),
            PUVTextField(
              hint: 'Username',
              controller: this.usernameController,
            ),
            SizedBox(height: 10.0),
            PUVTextField(
              obscureText: true,
              hint: 'Password',
              controller: this.passwordController,
            ),
            SizedBox(height: 10.0),
            PUVButton(
              label: 'Login',
              onPress: handleLogin,
            ),
            TextButton(
              onPressed: () => print('register account page'),
              child: TextButton(
                child: Text('Register New Account'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
