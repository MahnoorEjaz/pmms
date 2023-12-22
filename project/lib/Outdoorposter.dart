import 'package:flutter/material.dart';
import 'package:project/CartScreen.dart';
import 'package:project/UserInfoInputScreen.dart';

class OutdoorPosterPage extends StatefulWidget {
  @override
  _OutdoorPosterPageState createState() => _OutdoorPosterPageState();
}

class _OutdoorPosterPageState extends State<OutdoorPosterPage> {
  // State variables
  String selectedSize = '';
  String selectedOrientation = '';
  String selectedPaper = '';
  int quantity = 0;
  int price = 0;
  String installationOption = '';
  String designDescription = '';
  String type = 'outdoorposter';

  // Display Snackbar with a message
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
        title: Text('Outdoor Poster'),
        backgroundColor: Color(0xFF880A35),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Size selection
              Text(
                'Size',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Buttons for different sizes
                  PosterButton(
                    image: 'assets/images/size.png',
                    text: 'A4',
                    onTap: () {
                      setState(() {
                        selectedSize = 'A4';
                      });
                      displaySnackBar('Size selected: $selectedSize');
                    },
                  ),
                  PosterButton(
                    image: 'assets/images/size.png',
                    text: 'A3',
                    onTap: () {
                      setState(() {
                        selectedSize = 'A3';
                      });
                      displaySnackBar('Size selected: $selectedSize');
                    },
                  ),
                  PosterButton(
                    image: 'assets/images/size.png',
                    text: 'A2',
                    onTap: () {
                      setState(() {
                        selectedSize = 'A2';
                      });
                      displaySnackBar('Size selected: $selectedSize');
                    },
                  ),
                  PosterButton(
                    image: 'assets/images/size.png',
                    text: 'B1',
                    onTap: () {
                      setState(() {
                        selectedSize = 'B1';
                      });
                      displaySnackBar('Size selected: $selectedSize');
                    },
                  ),
                  // Similar buttons for other sizes
                ],
              ),

              // Paper orientation selection
              Text(
                'Paper Orientation',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Buttons for different orientations
                  PosterButton(
                    image: 'assets/images/port.png',
                    text: 'Portrait',
                    onTap: () {
                      setState(() {
                        selectedOrientation = 'Portrait';
                        displaySnackBar(
                            'Size paper orientation is: $selectedOrientation');
                      });
                    },
                  ),
                  PosterButton(
                    image: 'assets/images/port.png',
                    text: 'Landscape',
                    onTap: () {
                      setState(() {
                        selectedOrientation = 'Landscape';
                        displaySnackBar(
                            'Size paper orientation is: $selectedOrientation');
                      });
                    },
                  ),
                  // Similar buttons for other orientations
                ],
              ),

              // Paper selection
              Text(
                'Paper',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Button for paper selection
                  PosterButton(
                    image: 'assets/images/page.png',
                    text: 'Magistra Deluxe Blueback',
                    onTap: () {
                      setState(() {
                        selectedPaper = 'Magistra Deluxe Blueback';
                        displaySnackBar('Size paper is: $selectedPaper');
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),

              // Design description input
              Text(
                'Design Description',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter design description...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    designDescription = value;
                  });
                },
              ),
              SizedBox(height: 16.0),

              // Installation option selection
              Text(
                'Installation',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Radio(
                    value: 'No',
                    groupValue: installationOption,
                    onChanged: (value) {
                      setState(() {
                        installationOption = value as String;
                      });
                    },
                  ),
                  Text('No'),
                  // Radio buttons for installation option
                  Radio(
                    value: 'Yes',
                    groupValue: installationOption,
                    onChanged: (value) {
                      setState(() {
                        installationOption = value as String;
                      });
                    },
                  ),
                  Text('Yes'),
                  // Similar radio button for 'No'
                ],
              ),
              SizedBox(height: 16.0),

              // Quantity input
              Text(
                'Quantity',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter quantity...',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    quantity = int.tryParse(value) ?? 0;
                    price = quantity * 300;
                    if (installationOption == 'Yes') {
                      price = price + 1000;
                    }
                  });
                },
              ),
              SizedBox(height: 16.0),

              // Displaying the calculated price
              Text(
                'Price: ${price.toString()}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),

              // Button to add to cart
              ElevatedButton(
                onPressed: () async {
                  // Validate input fields before adding to cart
                  if (selectedSize.isEmpty ||
                      selectedOrientation.isEmpty ||
                      selectedPaper.isEmpty ||
                      designDescription.isEmpty ||
                      installationOption.isEmpty ||
                      quantity <= 0) {
                    displaySnackBar('Please fill in all fields.');
                    return;
                  }

                  // Get user information from UserInfoInputScreen
                  UserInfo userInfo = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserInfoInputScreen()),
                  );

                  // If user information is provided, navigate to CartScreen
                  if (userInfo != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(
                          selectedSize: selectedSize,
                          selectedOrientation: selectedOrientation,
                          selectedPaper: selectedPaper,
                          quantity: quantity,
                          price: price,
                          installationOption: installationOption,
                          designDescription: designDescription,
                          type: type,
                          email: userInfo.email,
                          name: userInfo.name,
                          contact: userInfo.contact,
                          address: userInfo.address,
                          carddetails: userInfo.cardDetails,
                        ),
                      ),
                    );
                  }
                },
                child: Text('Add to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget for buttons used in the page
class PosterButton extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback? onTap;

  PosterButton({required this.image, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Card(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  width: 82.0,
                  height: 89.0,
                ),
                SizedBox(height: 10.0),
                Text(
                  text,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
