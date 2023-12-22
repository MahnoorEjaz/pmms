// printer_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/PrinterStatus.dart';
import 'dart:convert';
import 'task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class PrinterScreen extends StatefulWidget {
  final String userEmail;
  final String userPassword;

  PrinterScreen({required this.userEmail, required this.userPassword});

  @override
  _PrinterScreenState createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterScreen> {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printer Screen'),
        backgroundColor: Color(0xFF880A35),
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
                        Text('Paper Orientation: ${_task[index].paperorient}'),
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
                        print('Task ID before navigating: ${_task[index]?.id}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrinterStatus(
                              task: _task[index],  // Ensure that _task[index] has a valid id
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
                            20.0, // Adjust the radius
                          ),
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
        Uri.parse('http://192.168.225.207:3000/api/tasks/completed-tasks'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> orderData = json.decode(response.body);
        print('Order Data: $orderData'); // Add this line to print order data
        setState(() {
          _task.clear();
          _task = orderData.map((data) => Task.fromJson(data)).toList();
        });
      } else {
        print('Failed to load orders. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching orders: $error');
    }
  }
}
