// profile_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_model.dart';
import 'order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ProfileScreen extends StatefulWidget {
  final String userEmail;
  final String userPassword;

  ProfileScreen({required this.userEmail, required this.userPassword});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchOrders();
  }
  Future<void> fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.225.207:3000/api/items/getitems/${widget.userEmail}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> orderData = json.decode(response.body);
        print('Order Data: $orderData'); // Add this line to print order data
        setState(() {
          _orders = orderData.map((data) => Order.fromJson(data)).toList();
        });
      } else {
        print('Failed to load orders. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String type = prefs.getString('type')??'';
        String size = prefs.getString('selectedSize') ?? '';
        String or = prefs.getString('selectedOrientation') ?? '';
        String paper = prefs.getString('selectedPaper') ?? '';
        String desc = prefs.getString('designDescription') ?? '';
        String quant = prefs.getString('quantity') ?? '';
        String pric = prefs.getString('price') ?? '';
      }
    } catch (error) {
      print('Error fetching orders: $error');

    }
  }
  Future<void> fetchUserData() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.225.207:3000/api/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.userEmail, 'password': widget.userPassword}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        if (userData.containsKey('user')) {
          setState(() {
            _user = User.fromJson(userData['user']);
          });
        }
      } else {
        print('Failed to load user data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF880A35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${_user!.email}'),
            Text('First Name: ${_user!.firstname}'),
            Text('Last Name: ${_user!.lastname}'),
            Text('Address: ${_user!.address}'),
            Text('Contact: ${_user!.contact}'),

            SizedBox(height: 16),
            Text('Orders History:'),

            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Order ID: ${_orders[index].id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Size: ${_orders[index].size}'),
                        Text('Paper Orientation: ${_orders[index].paperorient}'),
                        Text('Paper: ${_orders[index].paper}'),
                        Text('Description: ${_orders[index].des}'),
                        Text('Quantity: ${_orders[index].quantity}'),
                        Text('Total Price: ${_orders[index].totalPrice}'),
                        // Text('User Email: ${_orders[index].userEmail}'),
                      ],
                    ),
                    // Display other order details as needed
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
