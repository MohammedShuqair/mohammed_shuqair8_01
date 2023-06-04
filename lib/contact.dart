import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

Uri phone = Uri.parse('tel:0592509703');
Uri sms = Uri.parse('sms:0592509703?body=I Got you');
Uri email = Uri.parse('mailto:disa_2334@gmail.com');
Uri web = Uri.parse('https://pub.dev/');

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Go to"),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              launchUrl(phone);
            },
            icon: Icon(Icons.phone),
          ),
          IconButton(
            onPressed: () {
              launchUrl(sms);
            },
            icon: Icon(Icons.sms),
          ),
          IconButton(
            onPressed: () {
              launchUrl(email);
            },
            icon: Icon(Icons.email),
          ),
          IconButton(
            onPressed: () {
              launchUrl(web);
            },
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
}
