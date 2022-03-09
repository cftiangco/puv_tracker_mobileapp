import 'package:flutter/material.dart';
import 'package:puv_tracker/pages/home_driver.dart';
import 'package:puv_tracker/pages/login.dart';
import 'package:puv_tracker/pages/my_account_driver.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PUVDrawer extends StatelessWidget {
  const PUVDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('My Account'),
            onTap: () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyAccountDriver()),
              );
            },
          ),
          // ListTile(
          //   title: const Text('History'),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();

              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
        ],
      ),
    );
  }
}
