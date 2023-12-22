import 'package:flutter/material.dart';

class UserInfoInputScreen extends StatefulWidget {

  @override
  _UserInfoInputScreenState createState() => _UserInfoInputScreenState();
}

class _UserInfoInputScreenState extends State<UserInfoInputScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cardDetailsController = TextEditingController();
  void displaySnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
        backgroundColor: Color(0xFF880A35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: contactController,
              decoration: InputDecoration(labelText: 'Contact'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: cardDetailsController,
              decoration: InputDecoration(labelText: 'Card Details'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (emailController.text.isEmpty ||
                    nameController.text.isEmpty ||
                    contactController.text.isEmpty ||
                    addressController.text.isEmpty ||
                    cardDetailsController.text.isEmpty) {
                  displaySnackBar('Please fill in all fields.');
                } else if (cardDetailsController.text.length != 13) {
                  displaySnackBar('Card details must be exactly 13 digits.');
                } else {
                  Navigator.pop(
                    context,
                    UserInfo(
                      email: emailController.text,
                      name: nameController.text,
                      contact: contactController.text,
                      address: addressController.text,
                      cardDetails: cardDetailsController.text,
                    ),
                  );
                }

              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfo {
  final String email;
  final String name;
  final String contact;
  final String address;
  final String cardDetails;

  UserInfo({
    required this.email,
    required this.name,
    required this.contact,
    required this.address,
    required this.cardDetails,
  });
}
