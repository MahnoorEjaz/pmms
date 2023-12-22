// designer_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/DesignerStatus.dart';
import 'dart:convert';
import 'task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DesignerScreen extends StatefulWidget {
  final String userEmail;
  final String userPassword;

  DesignerScreen({required this.userEmail, required this.userPassword});

  @override
  _DesignerScreenState createState() => _DesignerScreenState();
}

class _DesignerScreenState extends State<DesignerScreen> {
  List<Task> _task = [];

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }
  Future<void> fetchTask() async {
    try {
      CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await tasks.get() as QuerySnapshot<Map<String, dynamic>>;
      if (querySnapshot.docs.isNotEmpty) {
        final List<dynamic> taskData =
        querySnapshot.docs.map((doc) => doc.data()).toList();
        print('Task Data: $taskData');
        setState(() {
          _task.clear();
          _task = taskData.map((data) => Task.fromJson(data)).toList();
        });
      }
    } catch (error) {
      print('Error fetching tasks: $error');
    }
  }
  // Function to fetch tasks from the server


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF880A35),
        title: Text('Designer Screen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tasks',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _task.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text('Type: ${_task[index].type}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Size: ${_task[index].size}'),
                        Text(
                            'Paper Orientation: ${_task[index].paperorient}'),
                        Text('Paper: ${_task[index].paper}'),
                        Text('Description: ${_task[index].des}'),
                        Text('Quantity: ${_task[index].quantity}'),
                        Text('Email: ${_task[index].email}'),
                        Text('Name: ${_task[index].name}'),
                        Text('Contact: ${_task[index].contact}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Navigate to the DesignerStatus screen with relevant task details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DesignerStatus(
                              task: _task[index],
                              userEmail: widget.userEmail,
                              userPassword: widget.userPassword,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        // Adjust the width
                        primary: Color(0xFF880A35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20.0), // Adjust the radius
                        ),
                      ),
                      child: Text('View Order'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }











































































  Future<void> fetchTasks() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.225.207:3000/api/items/unassigned'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the response body to a list of dynamic data
        final List<dynamic> orderData = json.decode(response.body);
        print('Order Data: $orderData'); // Print order data to console
        setState(() {
          _task.clear();
          // Convert dynamic data to a list of Task objects
          _task = orderData.map((data) => Task.fromJson(data)).toList();
        });
      } else {
        // Handle error if the status code is not 200
        print('Failed to load orders. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Handle any exceptions that might occur during the fetch
      print('Error fetching orders: $error');
    }
  }
}
