// designer_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/DesignerStatus.dart';
import 'dart:convert';
import 'task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import necessary packages and files

class ViewOrders extends StatefulWidget {
  @override
  _ViewOrdersState createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  List<Task> _task = [];
  List<Task> _filteredTasks = [];
  TextEditingController _searchController = TextEditingController();

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


  void _filterTasks() {
    final String searchText = _searchController.text.toLowerCase();

    setState(() {
      _filteredTasks = _task.where((task) {
        final String taskType = task.type.toLowerCase();
        final String taskSize = task.size.toLowerCase();
        final String taskName = task.name.toLowerCase();

        return taskType.contains(searchText) ||
            taskSize.contains(searchText) ||
            taskName.contains(searchText);
      }).toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Orders'),
        backgroundColor:Color(0xFF880A35)
    ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _filterTasks(),
              decoration: InputDecoration(
                labelText: 'Search by Type, Size, or Name',
                hintText: 'Enter search text',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text('Type: ${_filteredTasks[index].type}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Size: ${_filteredTasks[index].size}'),
                        Text(
                            'Paper Orientation: ${_filteredTasks[index].paperorient}'),
                        Text('Paper: ${_filteredTasks[index].paper}'),
                        Text('Description: ${_filteredTasks[index].des}'),
                        Text('Quantity: ${_filteredTasks[index].quantity}'),
                        Text('Email: ${_filteredTasks[index].email}'),
                        Text('Name: ${_filteredTasks[index].name}'),
                        Text('Contact: ${_filteredTasks[index].contact}'),

                      ],

                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _deleteItem(_filteredTasks[index].id);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => DesignerStatus(
                        //       task: _task[index],
                        //       userEmail: widget.userEmail,
                        //       userPassword: widget.userPassword,
                        //     ),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        // Adjust the width
                        primary: Color(0xFF880A35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // Adjust the radius
                        ),// Set the background color
                      ),
                      child: Text('Cancel Order'),
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
      Uri.parse('http://192.168.225.207:3000/api/items/allitems'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> orderData = json.decode(response.body);
      print('Order Data: $orderData');
      setState(() {
        _task.clear();
        _task = orderData.map((data) => Task.fromJson(data)).toList();
        _filteredTasks = List.from(_task);
      });
    } else {
      print('Failed to load orders. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

    }
  } catch (error) {
    print('Error fetching orders: $error');
  }
}
  void _deleteItem(String itemId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.225.207:3000/api/items/deleteitem/$itemId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        // Successful deletion
        setState(() {
          // Remove the deleted item from the local list
          _task.removeWhere((task) => task.id == itemId);
          _filteredTasks.removeWhere((task) => task.id == itemId);
        });
      } else {
        // Failed to delete
        print('Failed to delete item. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error deleting item: $error');
    }
  }
}
