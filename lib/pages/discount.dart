import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puv_tracker/widgets/PUV_text_form_field.dart';
import 'package:image_picker/image_picker.dart';

class Discount extends StatefulWidget {
  const Discount({Key? key}) : super(key: key);

  @override
  State<Discount> createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  TextEditingController idNoController = new TextEditingController();
  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        final temp = File(image.path);
        this.image = temp;
        print(this.image);
      });
    } on PlatformException catch (e) {
      print(e);
    }
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
          children: [
            PUVTextFormField(
              labelText: "ID #",
              controller: idNoController,
            ),
            TextButton(
              onPressed: () => this.pickImage(),
              child: Text('Browse image'),
            ),
            this.image != null ? Image.file(image!) : Text('No image found')
          ],
        ),
      ),
    );
  }
}
