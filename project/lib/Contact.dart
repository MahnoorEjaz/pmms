import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  // Controller for the text field
  TextEditingController _reviewController = TextEditingController();

  // Function to send an email using the EmailJS service
  void Send_mail() {
    var Service_id = 'service_fpdbuyt';
    var Template_id = 'template_ll7mt6h';
    var User_id = 's8BPFicQhyWq8BeHp';
    var s = http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {
        'origin': 'http:localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': Service_id,
        'user_id': User_id,
        'template_id': Template_id,
        'template_params': {
          'name': 'admin',
          'message': _reviewController.text,
          'sender': 'emahnoor@yahoo.com',
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Admin'),
        backgroundColor: Color(0xFF880A35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter any queries or cancellation request',
            ),
            SizedBox(height: 20),
            Text(
              'Email',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Text field for entering email content
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your message here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Call the function to send an email
                  Send_mail();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100.0),
                  primary: Color(0xFF880A35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
