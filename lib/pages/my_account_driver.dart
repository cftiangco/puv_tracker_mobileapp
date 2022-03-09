import 'package:flutter/material.dart';
import 'package:puv_tracker/pages/change_password_driver.dart';
import 'package:puv_tracker/widgets/item_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class MyAccountDriver extends StatefulWidget {
  const MyAccountDriver({Key? key}) : super(key: key);

  @override
  State<MyAccountDriver> createState() => _MyAccountDriverState();
}

class _MyAccountDriverState extends State<MyAccountDriver> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Account'),
        ),
        body: Column(
          children: [
            ItemCards(
              label: "Change Password",
              icon: Icon(Icons.lock_open_rounded),
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordDriver(),
                  ),
                );
              },
            ),
            ItemCards(
              label: "Logout",
              icon: Icon(Icons.exit_to_app),
              onPress: () async {
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();

                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ));
  }
}