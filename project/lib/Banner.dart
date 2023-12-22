import 'package:flutter/material.dart';
import 'package:project/CartScreen.dart';
import 'package:project/UserInfoInputScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BannerPosterPage(),
    );
  }
}

class BannerPosterPage extends StatefulWidget {
  @override
  _BannerPosterPageState createState() => _BannerPosterPageState();
}

class _BannerPosterPageState extends State<BannerPosterPage> {
  // Variables to store user selections and details
  String selectedSize = '';
  String selectedOrientation = '';
  String selectedPaper = '';
  int quantity = 0;
  int price = 0;
  String installationOption = '';
  String designDescription = '';
  String type = 'Banner';

  // Function to display a SnackBar with a given message
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
        title: Text('Banner'),
        backgroundColor: Color(0xFF880A35),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Size (cm)',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Buttons for selecting banner size
                  PosterButton(
                    image: 'assets/images/size.png',
                    text: '380x280',
                    onTap: () {
                      setState(() {
                        selectedSize = '380 x 280 cm';
                        displaySnackBar('selectedSize is: $selectedSize');
                      });
                    },
                  ),
                  PosterButton(
                    image: 'assets/images/size.png',
                    text: '400x300',
                    onTap: () {
                      setState(() {
                        selectedSize = '400x300cm';
                        displaySnackBar('selectedSize is: $selectedSize');
                      });
                    },
                  ),
                  PosterButton(
                    image: 'assets/images/size.png',
                    text: '580x280',
                    onTap: () {
                      setState(() {
                        selectedSize = '580x280cm';
                        displaySnackBar('selectedSize is: $selectedSize');
                      });
                    },
                  ),
                  PosterButton(
                    image: 'assets/images/size.png',
                    text: '600x300',
                    onTap: () {
                      setState(() {
                        selectedSize = '600 x 300 cm';
                        displaySnackBar('selectedSize is: $selectedSize');
                      });
                    },
                  ),
                ],
              ),
              Text(
                'Paper Orientation',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Buttons for selecting paper orientation
                  PosterButton(
                    image: 'assets/images/r.png',
                    text: '4 pieces',
                    onTap: () {
                      setState(() {
                        selectedOrientation = '4 pieces';
                        displaySnackBar(
                            'selected orientation is: $selectedOrientation');
                      });
                    },
                  ),
                  PosterButton(
                    image: 'assets/images/c.png',
                    text: '8 pieces',
                    onTap: () {
                      setState(() {
                        selectedOrientation = '8 pieces';
                        displaySnackBar(
                            'selected orientation is: $selectedOrientation');
                      });
                    },
                  ),
                ],
              ),
              Text(
                'Paper',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Button for selecting paper type
                  PosterButton(
                    image: 'assets/images/page.png',
                    text: 'Magistra Deluxe Blueback',
                    onTap: () {
                      setState(() {
                        selectedPaper = 'Magistra Deluxe Blueback';
                        displaySnackBar('selected paper is: $selectedPaper');
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Design Description',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              TextField(
                // Text field for entering design description
                decoration: InputDecoration(
                  hintText: 'Enter design description...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null, // Allows multiline input
                onChanged: (value) {
                  setState(() {
                    designDescription = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Installation',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Radio buttons for selecting installation option
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
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Quantity',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              TextField(
                // Text field for entering quantity
                decoration: InputDecoration(
                  hintText: 'Enter quantity...',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    quantity = int.tryParse(value) ?? 0;
                    price = quantity * 2000;
                    if (installationOption == 'Yes') {
                      price = price + 1000;
                    }
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Price: \$${price.toString()}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (selectedSize.isEmpty ||
                      selectedOrientation.isEmpty ||
                      selectedPaper.isEmpty ||
                      designDescription.isEmpty ||
                      installationOption.isEmpty ||
                      quantity <= 0) {
                    displaySnackBar('Please fill in all fields.');
                    return;
                  }
                  UserInfo userInfo = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInfoInputScreen()),
                  );

                  if (userInfo != null) {
                    // User has provided information, navigate to CartScreen
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
