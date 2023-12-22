// performance.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/DesignerStatus.dart';
import 'dart:convert';
import 'task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Performance extends StatefulWidget {
  @override
  _PerformanceState createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
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
        final String taskdname = task.designerName.toLowerCase();
        final String taskdstatus = task.designerStatus.toLowerCase();
        final String taskpname = task.printerName.toLowerCase();
        final String taskpstatus = task.printStatus.toLowerCase();

        return taskType.contains(searchText) ||
            taskdname.contains(searchText) ||
            taskdstatus.contains(searchText) ||
            taskpname.contains(searchText) ||
            taskpstatus.contains(searchText);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Performance'),
        backgroundColor: Color(0xFF880A35),
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
                        Text('Name: ${_filteredTasks[index].name}'),
                        Text('Email: ${_filteredTasks[index].email}'),
                        Text('Designer Email: ${_filteredTasks[index].designeremail}'),
                        Text('Designer Name: ${_filteredTasks[index].designerName}'),
                        Text('Designing Status: ${_filteredTasks[index].designerStatus}'),
                        Text('Printer Email: ${_filteredTasks[index].printeremail}'),
                        Text('Printer Name: ${_filteredTasks[index].printerName}'),
                        Text('Printing Status: ${_filteredTasks[index].printStatus}'),
                      ],
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
        Uri.parse('http://192.168.225.207:3000/api/tasks/alltasks'),
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

}
