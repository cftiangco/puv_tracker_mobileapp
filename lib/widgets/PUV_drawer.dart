import 'package:flutter/material.dart';

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
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('History'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
