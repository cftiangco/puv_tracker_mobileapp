import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:puv_tracker/services/pref_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Discount extends StatefulWidget {
  const Discount({Key? key}) : super(key: key);

  @override
  State<Discount> createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  var id;
  var token;
  var discount;
  void getCache() async {
    PrefService _pref = new PrefService();
    this.id = await _pref.readId();
    this.token = await _pref.readToken();
    this.getDiscount();
    this.setState(() {});
  }

  Future<void> getDiscount() async {
    var res = await http.get(
      Uri.parse('http://www.puvtrackingsystem.xyz/api/discount/${this.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${this.token}'
      },
    );
    setState(() {
      this.discount = jsonDecode(res.body);
    });
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
        title: Text('Upload Discount ID'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text('Your ID #:'),
                SizedBox(
                  width: 10,
                ),
                Text(
                  this.discount['idno'] ?? "No uploaded Discount",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text('Status:'),
                SizedBox(
                  width: 10,
                ),
                Text(
                  this.discount['status'] ?? "No uploaded Discount",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () async {
                final url =
                    "http://www.puvtrackingsystem.xyz/uploading/${this.id}";

                await launch(url);
              },
              child: Text('Upload Discount ID'),
            ),
          ],
        ),
      ),
    );
  }
}
