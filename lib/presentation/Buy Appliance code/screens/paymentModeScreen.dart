// ignore_for_file: file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/provider/cartProvider.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20code/screens/orderConfirmScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PaymentModeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItemsDetails;
  final Map<String, dynamic> userDetails;

  const PaymentModeScreen({
    Key? key,
    required this.cartItemsDetails,
    required this.userDetails,
  }) : super(key: key);

  @override
  State<PaymentModeScreen> createState() => _PaymentModeScreenState();
}

class _PaymentModeScreenState extends State<PaymentModeScreen> {
  String? selectedPaymentMode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mode Of Payment'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mode Of Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Stack(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Online Payment'),
                      value: 'Online Payment',
                      subtitle: const Text(
                        'Deliver in 45 minutes & Free installation',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      groupValue: selectedPaymentMode,
                      onChanged: null, // Disable the option
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.block,
                              color: Colors.red,
                              size: 40,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Not available right now',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RadioListTile<String>(
                  title: const Text('Cash On Delivery'),
                  value: 'Cash On Delivery',
                  groupValue: selectedPaymentMode,
                  subtitle: const Text(
                    'Free installation & Same Day Delivery',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      selectedPaymentMode = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, value, child) => Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'ITEMS: ${value.totalItems}',
                      ),
                      const Spacer(),
                      Text(
                        'INR ${value.productTotalPrice.toStringAsFixed(2)}',
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Center(
                                    child: Container(
                                      height: 200,
                                      width: 250,
                                      padding: const EdgeInsets.all(15),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'View Billing Details',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon:
                                                      const Icon(Icons.cancel)),
                                            ],
                                          ),
                                          Text(
                                            'INR ${value.productTotalPrice.toStringAsFixed(2)}',
                                          ),
                                          const Text('Discount - 0'),
                                          const Divider(),
                                          Text(
                                            'Total : INR ${value.productTotalPrice}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                        },
                        child: const Text(
                          'View Billing Details',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const BeveledRectangleBorder(),
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      final documentId = await update(widget.userDetails,
                          widget.cartItemsDetails, value.productTotalPrice);
                      List<String> adminDeviceTokens =
                          await getAdminDeviceTokens("KADAPA");
                      for (var adminToken in adminDeviceTokens) {
                        print("Sending notification to admin...");
                        notificationFormat("admins", adminToken);
                      }
                      if (documentId != null) {
                        print(
                            'Order successfully created with ID: $documentId');
                        // Show the booking ID to the user
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Your booking ID is: $documentId')),
                        );
                        confirmOrder(context, documentId);
                      } else {
                        print('Failed to create order');
                        // Show an error message to the user
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Failed to create order. Please try again.')),
                        );
                      }
                    },
                    child: const Text(
                      'PLACE ORDER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class _PaymentModeScreenState extends State<PaymentModeScreen> {
//   String? selectedPaymentMode = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mode Of Payment'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(15.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Mode Of Payment',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 RadioListTile<String>(
//                   title: const Text('Online Payment'),
//                   value: 'Online Payment',
//                   subtitle: const Text(
//                     'Deliver in 45 minutes & Free installation',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ),
//                   groupValue: selectedPaymentMode,
//                   onChanged: (String? value) {
//                     setState(() {
//                       selectedPaymentMode = value;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 RadioListTile<String>(
//                   title: const Text('Cash On Delivery'),
//                   value: 'Cash On Delivery',
//                   groupValue: selectedPaymentMode,
//                   subtitle: const Text(
//                     'Free installat & Same Day Delivery',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ),
//                   onChanged: (String? value) {
//                     setState(() {
//                       selectedPaymentMode = value;
//                     });
//                   },
//                 ),

//                 // Add more RadioListTile widgets for other payment modes here
//               ],
//             ),
//           ),
//           Consumer<CartProvider>(
//             builder: (context, value, child) => Container(
//               padding: const EdgeInsets.all(15.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.shade300,
//                     blurRadius: 6,
//                     spreadRadius: 1,
//                   ),
//                 ],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         'ITEMS: ${value.totalItems}',
//                       ),
//                       const Spacer(),
//                       Text(
//                         'INR ${value.productTotalPrice.toStringAsFixed(2)}',
//                       ),
//                       const SizedBox(width: 10),
//                       TextButton(
//                         onPressed: () {
//                           showDialog(
//                               context: context,
//                               builder: (context) => Center(
//                                     child: Container(
//                                       height: 200,
//                                       width: 250,
//                                       padding: const EdgeInsets.all(15),
//                                       decoration: const BoxDecoration(
//                                         color: Colors.white,
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               const Text(
//                                                 'View Billing Details',
//                                                 style: TextStyle(
//                                                   color: Colors.green,
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                               IconButton(
//                                                   onPressed: () {},
//                                                   icon:
//                                                       const Icon(Icons.cancel)),
//                                             ],
//                                           ),
//                                           Text(
//                                             'INR ${value.productTotalPrice.toStringAsFixed(2)}',
//                                           ),
//                                           const Text('Discount - 0'),
//                                           const Divider(),
//                                           Text(
//                                             'Total : INR ${value.productTotalPrice}',
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ));
//                         },
//                         child: const Text(
//                           'View Billing Details',
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: const BeveledRectangleBorder(),
//                       backgroundColor: Colors.black,
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     onPressed: () async {
//                       print("hello");
//                       final documentId = await update(widget.userDetails,
//                           widget.cartItemsDetails, value.productTotalPrice);
//                       List<String> adminDeviceTokens =
//                           await getAdminDeviceTokens("KADAPA");

//                       // for (var adminToken in adminDeviceTokens) {
//                       //   print("Sending notification to admin...");
//                       //   notificationFormat("admins", adminToken);
//                       // }
//                       if (documentId != null) {
//                         print(
//                             'Order successfully created with ID: $documentId');
//                         // Show the booking ID to the user
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                               content: Text('Your booking ID is: $documentId')),
//                         );
//                         confirmOrder(context, documentId);
//                       } else {
//                         print('Failed to create order');
//                         // Show an error message to the user
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text(
//                                   'Failed to create order. Please try again.')),
//                         );
//                       }
//                     },
//                     child: const Text(
//                       'PLACE ORDER',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

Future<String?> update(
  Map<String, dynamic> userDetails,
  List<Map<String, dynamic>> cartItemsDetails,
  double productTotalPrice,
) async {
  try {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Fetch the current user
    final User? user = _auth.currentUser;

    if (user != null) {
      print('Updating order for user: ${user.uid}');
      final userDocRef =
          FirebaseFirestore.instance.collection('customers').doc(user.uid);

      print('Got user document reference');

      // Generate a unique 5-digit order ID based on current date and time
      final String orderId = _generateOrderId();

      final orderData = {
        'orderId': orderId, // Add the generated order ID
        'userDetails': {
          'userId': user.uid,
          ...userDetails,
        },
        'cartItemsDetails': cartItemsDetails,
        'timestamp': FieldValue.serverTimestamp(),
        'amountPayable': productTotalPrice,
      };

      print('Order data prepared: $orderData');

      // Add order data to the "orders" collection and get the document reference
      await userDocRef.collection('orders').doc(orderId).set(orderData);

      return orderId;
    } else {
      print('User not signed in');
      // Handle the case where the user is not signed in
    }
  } catch (e) {
    print('Error updating order: $e');
    // Handle the error here
  }
  return null;
}

// Function to generate a unique 5-digit order ID based on current date and time
String _generateOrderId() {
  DateTime now = DateTime.now();
  String orderId =
      '${now.month}${now.day}${now.hour}${now.minute}${now.millisecond}';
  return orderId;
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Processing Order..."),
            ],
          ),
        ),
      );
    },
  );
}

notificationFormat(receiverID, userDeviceToken) async {
  print("Building notification format...");

  Map<String, String> headerNotification = {
    "Content-Type": "application/json",
    "Authorization":
        "key=AAAA0PM0nhk:APA91bEEQmPk1eVc7fRsFUrI5ziYm-zWCi_5BrO88PDz5A48YUU96Iwrp0fIBJ6CV6HGXsn13yOFzvKxb0Fnk2VZyK7g1cPXBm1KimmoP_028MLNiSKsULtk2h9P1QU2kNIxmSBV2h1L",
  };

  Map bodyNotification = {
    "body": "you have received a new buy order from customer. click to see",
    "title": "New Order",
  };

  Map dataMap = {
    "click_action": "FLUTTER_NOTIFICATION_CLICK",
    "id": "1",
    "status": "done",
  };

  Map notificationFormat = {
    "notification": bodyNotification,
    "data": dataMap,
    "priority": "high",
    "to": userDeviceToken,
  };

  print("Sending notification to admin $receiverID...");
  try {
    final response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(notificationFormat),
    );

    if (response.statusCode == 200) {
      print("Notification Payload: $notificationFormat");
      print("Notification sent successfully to technician $receiverID.");
    } else {
      print(
          "Failed to send notification to technician $receiverID. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error while sending notification to technician $receiverID: $e");
  }
}

Future<List<String>> getAdminDeviceTokens(String city) async {
  try {
    // Reference to the 'adminss' collection
    CollectionReference adminsCollection =
        FirebaseFirestore.instance.collection('adminss');

    // Reference to the document representing the city under the 'adminss' collection
    DocumentReference cityDocument = adminsCollection.doc(city);

    // Fetch the document data for the specified city
    DocumentSnapshot citySnapshot = await cityDocument.get();

    if (citySnapshot.exists) {
      // Extract device tokens from the city document
      Map<String, dynamic> cityData =
          citySnapshot.data() as Map<String, dynamic>;
      List<String> cityTokens = [];

      // Iterate through the devices and extract tokens
      cityData.forEach((deviceId, deviceData) {
        String token = deviceData['token'];
        if (token != null) {
          cityTokens.add(token.toString());
        }
      });

      return cityTokens;
    } else {
      print("No admin documents found for city: $city");
      return [];
    }
  } catch (e) {
    print("Error fetching admin device tokens: $e");
    return [];
  }
}

void confirmOrder(BuildContext context, final bookingid) {
  showLoadingDialog(context);

  // Simulate a network request or some processing delay
  Future.delayed(
    const Duration(seconds: 3),
    () {
      Navigator.pop(context); // Remove the loading dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(bookingid: bookingid),
        ),
      );
    },
  );
}
