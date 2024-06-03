import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/presentation/home_page_screen/home_page_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomerRatingScreen extends StatefulWidget {
  final String technicianName;
  final String lastService;
  final String serviceId;
  final String userId;
  final String profilePictureUrl;

  const CustomerRatingScreen({
    Key? key,
    required this.technicianName,
    required this.lastService,
    required this.serviceId,
    required this.userId,
    required this.profilePictureUrl,
  }) : super(key: key);

  @override
  State<CustomerRatingScreen> createState() => _CustomerRatingScreenState();
}

class _CustomerRatingScreenState extends State<CustomerRatingScreen> {
//Custom Background Colors

  Color backgroundColor1 = const Color(0xffE9EAF7);
  Color backgroundColor2 = const Color(0xffF4EEF2);
  Color backgroundColor3 = const Color(0xffEBEBF2);
  Color backgroundColor4 = const Color(0xffE3EDF5);

  double initialRating = 0;

//List of Review Types

  List<String> reviewType = [
    'Polite',
    "Punctual",
    "Quick and Accurate",
    "Friendly",
  ];

  List<bool> reviewValues = List.filled(5, false);

  bool checkBox = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final backgroundImage = widget.profilePictureUrl != null &&
            widget.profilePictureUrl.isNotEmpty
        ? NetworkImage(
            widget.profilePictureUrl) // Use the retrieved URL if available
        : NetworkImage(
            'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500');

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Booking Confirmation'),
      //   backgroundColor: Colors.yellow,
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor1, backgroundColor2, backgroundColor3],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.045,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Feedback is Valuable',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    CupertinoIcons.suit_heart_fill,
                    color: Colors.red,
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.005,
              ),
              Container(
                height: size.height / 1.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 05,
                        offset: Offset(2, 4),
                      )
                    ]),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: backgroundImage,
                      ),
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      Text(
                        "${widget.technicianName}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      const Text(
                        'Rate Your Experience',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      RatingBar.builder(
                        minRating: 1,
                        itemBuilder: (context, index) => const Icon(
                          CupertinoIcons.star_fill,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (value) {
                          setState(() {
                            initialRating = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: size.height * 0.015,
                      ),

                      //Check box options

                      Column(
                        children: [
                          for (int i = 0; i < reviewType.length; i++)
                            CheckboxListTile(
                              checkColor: Colors.white,
                              activeColor: Colors.amber,
                              value: reviewValues[i],
                              title: Text(
                                reviewType[i],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16, // Adjust the font size
                                  color: Colors
                                      .black87, // Customize the text color
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity
                                  .trailing, // Move checkbox to the right
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 05), // Adjust padding
                              onChanged: (value) {
                                setState(() {
                                  reviewValues[i] = value!;
                                });
                              },
                            )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              InkWell(
                onTap: () {
                  submitButton(size);
                },
                child: Container(
                  height: size.height * 0.065,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                    border: Border.all(
                      width: size.width * 0.0025,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitButton(Size size) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.yellow,
        ));
      },
    );

    // Calculate the average rating

    await FirebaseFirestore.instance
        .collection('technicians')
        .doc(widget.userId)
        .update({
      'StarRecieved':
          FieldValue.increment(initialRating), // Increment the total rating
      'polite': FieldValue.increment(
          reviewValues[0] ? 1 : 0), // Increment the value of 'polite'
      'punctual': FieldValue.increment(
          reviewValues[1] ? 1 : 0), // Increment the value of 'punctual'
      'quickAndAccurate': FieldValue.increment(
          reviewValues[2] ? 1 : 0), // Increment the value of 'quickAndAccurate'
      'friendly': FieldValue.increment(
          reviewValues[3] ? 1 : 0), // Increment the value of 'friendly'
      'RatedBy': FieldValue.increment(1),
    });

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('technicians')
        .doc(widget.userId)
        .get();
    double starReceived = snapshot['StarRecieved'] ?? 0;

    int ratedBy = snapshot['RatedBy'] ?? 0;

    double averageRating = ratedBy != 0 ? starReceived / ratedBy : 0;

    await FirebaseFirestore.instance
        .collection('technicians')
        .doc(widget.userId)
        .update({
      'Rating': averageRating,
    });

    // Simulate a delay of 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Close the loading dialog and show the "Thank you" message
    Navigator.pop(context);

    // Show the "Thank you" message using a custom dialog
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.thumb_up,
                  size: 48,
                  color: Colors.green,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Thank You!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your review has been submitted successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePageScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}




// await FirebaseFirestore.instance
//         .collection('customers')
//         .doc(widget.userId)
//         .collection('serviceDetails')
//         .doc(widget.serviceId)
//         .update({'rating': initialRating});