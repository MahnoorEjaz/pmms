import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'DatabaseHelper.dart'; // Import the DatabaseHelper


class WriteReviewScreen extends StatefulWidget {
  final String userEmail;

  WriteReviewScreen({required this.userEmail});

  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  String _selectedProduct = 'Banner';
  TextEditingController _reviewController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();


  Future<void> addReviews() async {
    if (!_reviewController.text.isEmpty) {
      try {
        await _databaseHelper.addReview(
          widget.userEmail,
          _selectedProduct,
          _reviewController.text,
        );
        print('Review added to SQLite successfully!');
      } catch (error) {
        print('Error adding review to SQLite: $error');
      }
    } else {

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write Review'),
        backgroundColor: Color(0xFF880A35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedProduct,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedProduct = newValue!;
                });
              },
              items: <String>['Banner', 'Outdoor Poster']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Review',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your review here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
        Center(
            child:ElevatedButton(
              onPressed: () {
                // Handle the submission of the review
                print('Product: $_selectedProduct');
                print('Review: ${_reviewController.text}');
                addReview(); // Call the addReview method
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(

                padding: EdgeInsets.symmetric(horizontal: 100.0),
                // Adjust the width
                primary: Color(0xFF880A35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      20.0), // Adjust the radius
                ),
              ),
              child: Text('Submit Review'),
            ),
        ),
          ],
        ),
      ),
    );
  }




































































































































































































































































void addReview() async {
  if (!_reviewController.text.isEmpty) {
    var regBody = {
      "email": widget.userEmail,
      "type": _selectedProduct,
      "review": _reviewController.text,
    };

    var response = await http.post(
      Uri.parse('http://192.168.225.207:3000/api/review/addreview'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(regBody),
    );

    print(response);
  } else {
    // Handle the case when the review is empty
  }
}
}

