// import 'dart:html';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:customer_app/app%20state/serviceDetails.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// class PushNotificationSystem {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   // for termination state
//   Future whenNotificationRecieved(BuildContext context) async {
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? remoteMessage) {
//       if (remoteMessage != Null) {
//         openAppShowAndShowNotification(
//           remoteMessage!.data["phonenumber"],
//           remoteMessage!.data["documentName"],
//           remoteMessage!.data["user"],
//           context,
//         );
//       }
//     });
//     // for foreground state
//     FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
//       if (remoteMessage != null) {
//         openAppShowAndShowNotification(
//           remoteMessage!.data["phonenumber"],
//           remoteMessage!.data["documentName"],
//           remoteMessage!.data["user"],
//           context,
//         );
//       }
//     });
//     // for background state
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
//       if (remoteMessage != null) {
//         openAppShowAndShowNotification(
//           remoteMessage!.data["phonenumber"],
//           remoteMessage!.data["documentName"],
//           remoteMessage!.data["user"],
//           context,
//         );
//       }
//     });
//   }

//   openAppShowAndShowNotification(
//       phoneNumber, documentName, user, context) async {
//     await FirebaseFirestore.instance
//         .collection("customers")
//         .doc(user)
//         .collection("serviceDetails")
//         .doc(documentName)
//         .get()
//         .then((snapshot) {
//       bool job = snapshot.data()!['jobAcceptance'];
//       int time = snapshot.data()!['timeIndex'];
//       DateTime date = snapshot.data()!['timeIndex'];
//       bool urgentBooking = snapshot.data()!['urgentBooking'];
//       String address = snapshot.data()!['address'].toString();
//       GeoPoint location = snapshot.data()!['userLocation'];
//       showDialog(
//           context: context,
//           builder: (context) {
//             return NotificationDialogBox(
//                 phoneNumber, user, address, job, time, date, urgentBooking,location);
//           });
//     });
//   }

//   Widget NotificationDialogBox(String phoneNumber, String user, String address,
//       bool job, int time, DateTime date, bool urgentBooking, GeoPoint userLocation) {
//     return Dialog(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SizedBox(
//           height: 300,
//           child: Card(
//             color: Colors.blue.shade200,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Sender: $phoneNumber',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text('Address: $address'),
//                   Text('Selected time: $time'),
//                   Text('Service Date: $date'),
//                   Text('User Location: $userLocation'),
//                   SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           // Handle button click or dismiss the dialog
//                         },
//                         child: Text('Close'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
