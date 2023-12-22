
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_model.dart';
import 'task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrinterStatus extends StatefulWidget {
  final Task task;
  final String userEmail;
  final String userPassword;

  PrinterStatus({
    required this.task,
    required this.userEmail,
    required this.userPassword,
  });

  @override
  _PrinterStatusState createState() => _PrinterStatusState();
}

class _PrinterStatusState extends State<PrinterStatus> {
  late String _selectedStatus;
  late CollectionReference users;
  late CollectionReference tasks;
  User? _user;

  @override
  void initState() {
    super.initState();
    print('Task ID in PrinterStatus: ${widget.task.id}');
    _selectedStatus = widget.task.designerStatus;
    fetchUserData();
  }
  Future<void> fetchUsersData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await users.doc(widget.userEmail).get() as DocumentSnapshot<Map<String, dynamic>>;
      if (userSnapshot.exists) {
        setState(() {
          _user = User.fromJson(userSnapshot.data()!);
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }
  Future<void> updatePrintersStatus() async {
    try {
      // Update the printer status in the tasks collection
      await tasks.doc(widget.task.id).update({
        'printeremail': widget.userEmail,
        'printerName': _user?.firstname ?? 'N/A',
        'printStatus': _selectedStatus,
      });

      // Display a message in the console
      print('Printer status updated successfully in Firestore');

    } catch (error) {
      // Handle any errors that occur during the update
      print('Error updating printer status: $error');
    }
  }
  void sendMail() {
    var serviceId = 'service_fpdbuyt';
    var templateId = 'template_ll7mt6h';
    var userId = 's8BPFicQhyWq8BeHp';

    http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {
        'origin': 'http:localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': serviceId,
        'user_id': userId,
        'template_id': templateId,
        'template_params': {
          'name': widget.task.name,
          'message': _selectedStatus,
          'sender': widget.task.email,
        },
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF880A35),
        title: Text('Printing Status'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('id: ${widget.task.id}'),
            Text('Type: ${widget.task.type}'),
            Text('Size: ${widget.task.size}'),
            Text('Paper Orientation: ${widget.task.paperorient}'),
            Text('Paper: ${widget.task.paper}'),
            Text('Description: ${widget.task.des}'),
            Text('Email: ${widget.task.email}'),
            Text('Name: ${widget.task.name}'),
            Text('Contact: ${widget.task.contact}'),

            SizedBox(height: 20),

            DropdownButton<String>(
              value: _selectedStatus,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                }
              },
              items: <String>['', 'Pending', 'Completed']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            ElevatedButton(
              onPressed: () async {
                await updatePrinterStatus();
                sendMail();
                Navigator.pop(context, _selectedStatus);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 100.0),
                primary: Color(0xFF880A35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Save Status'),
            ),
          ],
        ),
      ),
    );
  }






























































































































































































  Future<void> updatePrinterStatus() async {
    try {
      final response = await http.put(
        Uri.parse('http://192.168.0.103:3000/api/tasks/update-task/${widget.task.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'printeremail': widget.userEmail,
          'printerName': _user?.firstname ?? 'N/A',
          'printStatus': _selectedStatus,
        }),
      );
      print('Task ID: ${widget.task.id}');
      if (response.statusCode == 200) {
        print('Printer status updated successfully');
      } else {
        print('Failed to update printer status. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error updating printer status: $error');
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
}

