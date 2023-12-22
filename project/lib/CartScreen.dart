import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/OrderPlacedScreen.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatelessWidget {
  // Parameters for order details
  final String selectedSize;
  final String selectedOrientation;
  final String selectedPaper;
  final int quantity;
  final int price;
  final String installationOption;
  final String designDescription;
  final String type;
  final String email;
  final String name;
  final String contact;
  final String address;
  final String carddetails;
  CartScreen({
    required this.selectedSize,
    required this.selectedOrientation,
    required this.selectedPaper,
    required this.quantity,
    required this.price,
    required this.installationOption,
    required this.designDescription,
    required this.type,
    required this.email,
    required this.name,
    required this.contact,
    required this.address,
    required this.carddetails,
  });
  // Function to show a dialog indicating the order has been placed

  Future<void> additem({
    required String type,
    required String selectedSize,
    required String selectedOrientation,
    required String selectedPaper,
    required String designDescription,
    required int quantity,
    required int price,
    required String installationOption,
    required String email,
    required String name,
    required String contact,
    required String address,
    required String cardDetails,

  }) async {
    try {
      CollectionReference orders = FirebaseFirestore.instance.collection('orders');
      await orders.add({
        'type': type,
        'selectedSize': selectedSize,
        'selectedOrientation': selectedOrientation,
        'selectedPaper': selectedPaper,
        'designDescription': designDescription,
        'quantity': quantity,
        'price': price,
        'installationOption': installationOption,
        'email': email,
        'name': name,
        'contact': contact,
        'address': address,
        'cardDetails': cardDetails,
        'timestamp': FieldValue.serverTimestamp(),
        // Add a timestamp for ordering purposes

      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('type', type);
      prefs.setString('selectedSize', selectedSize);
      prefs.setString('selectedOrientation', selectedOrientation);
      prefs.setString('selectedPaper', selectedPaper);
      prefs.setString('designDescription', designDescription);
      prefs.setInt('quantity', quantity);
      prefs.setInt('price', price);
      prefs.setString('installationOption', installationOption);
      prefs.setString('email', email);
      prefs.setString('name', name);
      prefs.setString('contact', contact);
      prefs.setString('address', address);
      prefs.setString('cardDetails', carddetails);


      print('Order added to Firestore successfully');
    } catch (e) {
      print('Error adding order to Firestore: $e');
    }
  }
  Future<void> showOrderPlacedDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Placed'),
          content: Text('Order Placed Successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  void additems() async {
    var regBody = {
      "type": type,
      "size": selectedSize,
      "paperorient": selectedOrientation,
      "paper": selectedPaper,
      "des": designDescription,
      "quantity": quantity,
      "totalPrice": price,
      "email": email,
      "name": name,
      "contact": contact,
      "address": address,
      "carddetails": carddetails
    };
    var response = await http.post(
      Uri.parse('http://192.168.225.207:3000/api/items/itemadd'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: Color(0xFF880A35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order Details Heading
            Text(
              'Order Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),

            // Display the selected type
            Text('Selected Type: $type'),
            Text('Selected Size: $selectedSize'),
            Text('Selected Orientation: $selectedOrientation'),
            Text('Selected Paper: $selectedPaper'),
            Text('Quantity: $quantity'),
            Text('Price: \$${price.toString()}'),
            Text('Installation Option: $installationOption'),
            Text('Design Description: $designDescription'),

            SizedBox(height: 20),

            // Email Textbox
            Text(
              'Email:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(email),
            ),
            SizedBox(height: 20),

            // Name Textbox
            Text(
              'Name:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(name),
            ),

            SizedBox(height: 20),

            // Contact Textbox
            Text(
              'Contact:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text('contact'),
            ),
            SizedBox(height: 20),

            // Address Textbox
            Text(
              'Address:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(address),
            ),

            SizedBox(height: 20),

            // Card Details Textbox
            Text(
              'Card Details:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(carddetails),
            ),

            ElevatedButton(
              onPressed: () {
                additems(); // Call the function to add items to the server
                // You can also perform any other actions related to placing the order here
                showOrderPlacedDialog(context);
              },
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}