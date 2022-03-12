import 'package:flutter/material.dart';
import 'package:puv_tracker/pages/login.dart';
import 'package:puv_tracker/pages/my_account_driver.dart';
import 'package:puv_tracker/services/pref_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PUVDrawer extends StatefulWidget {
  const PUVDrawer({Key? key}) : super(key: key);

  @override
  State<PUVDrawer> createState() => _PUVDrawerState();
}

class _PUVDrawerState extends State<PUVDrawer> {
  var fullName;
  void getCache() async {
    PrefService _pref = new PrefService();
    this.fullName = await _pref.readFullName();
    setState(() {});
  }

  void handleLogout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text(
          'Are you sure you want to logout',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();

              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()));
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
  void initState() {
    this.getCache();
    super.initState();
  }

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
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  this.fullName.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('My Account'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyAccountDriver()),
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: this.handleLogout,
          ),
        ],
      ),
    );
  }
}
