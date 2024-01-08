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
//           remoteMessage!.data["userid"],
//           remoteMessage!.data["senderid"],
//           context,
//         );
//       }
//     });
//     // for foreground state
//     FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
//       if (remoteMessage != null) {
//         openAppShowAndShowNotification(
//           remoteMessage.data["userid"],
//           remoteMessage.data["senderid"],
//           context,
//         );
//       }
//     });
//     // for background state
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
//       if (remoteMessage != null) {
//         openAppShowAndShowNotification(
//           remoteMessage.data["userid"],
//           remoteMessage.data["senderid"],
//           context,
//         );
//       }
//     });
//   }

  // openAppShowAndShowNotification(recieverId, senderId, context) async {
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(senderId)
  //       .get()
  //       .then((snapshot) {
  //     // string user = snapshot.data()!['name'].toString(); --->> fetch data
  //     showDialog(
  //         context: context,
  //         builder: (context) {
  //           return NotificationDialogBox(
  //             senderId,
  //             serviceDetails.address,
  //             serviceDetails.selectedReas,
  //             serviceDetails.serviceDate,
  //             serviceDetails.services,
  //             serviceDetails.timeIndex,
  //             serviceDetails.userDes,
  //             serviceDetails.userLocation,
  //             serviceDetails.userPhoneNumber,
  //           );
  //         });
  //   });
  // }

  // Widget NotificationDialogBox(
  //   String senderId,
  //   String address,
  //   String selectedReason,
  //   String serviceDate,
  //   String services,
  //   int timeIndex,
  //   String userDes,
  //   String userLocation,
  //   String userPhoneNumber,
  // ) {
  //   return Dialog(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: SizedBox(
  //         height: 300,
  //         child: Card(
  //           color: Colors.blue.shade200,
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'Sender ID: $senderId',
  //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                 ),
  //                 SizedBox(height: 8),
  //                 Text('Address: $address'),
  //                 Text('Selected Reason: $selectedReason'),
  //                 Text('Service Date: $serviceDate'),
  //                 Text('Services: $services'),
  //                 Text('Time Index: $timeIndex'),
  //                 Text('User Description: $userDes'),
  //                 Text('User Location: $userLocation'),
  //                 Text('User Phone Number: $userPhoneNumber'),
  //                 SizedBox(height: 16),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         // Handle button click or dismiss the dialog
  //                         Get.Back();
  //                       },
  //                       child: Text('Close'),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
// }






// ---->>>
// Future<List<DocumentSnapshot>> getNearbyTechnicians(
//   String serviceName,
//   double customerLatitude,
//   double customerLongitude,
// ) async {
//   print("Fetching nearby technicians...");

//   final QuerySnapshot result = await FirebaseFirestore.instance
//       .collection('technicians')
//       .where('services', arrayContains: serviceName)
//       .get();

//   List<DocumentSnapshot> technicians = result.docs;

//   // Fetch all currentLocation data asynchronously
//   List<Map<String, dynamic>> locationsData = await Future.wait(
//     technicians.map((technician) async {
//       try {
//         DocumentSnapshot currentLocationSnapshot = await technician.reference
//             .collection('location')
//             .doc('currentLocation')
//             .get();

//         if (currentLocationSnapshot.exists) {
//           return {
//             'id': technician.id,
//             'latitude': currentLocationSnapshot['latitude'] ?? 0.0,
//             'longitude': currentLocationSnapshot['longitude'] ?? 0.0,
//           };
//         } else {
//           print(
//               "currentLocation document does not exist for technician ${technician.id}");
//         }
//       } catch (e) {
//         print("Error fetching location for technician ${technician.id}: $e");
//       }

//       return {
//         'id': technician.id,
//         'latitude': 0.0,
//         'longitude': 0.0,
//       };
//     }),
//   );

//   // Calculate distances asynchronously
//   List<double> distances = await Future.wait(technicians.map((technician) async {
//     Map<String, dynamic> location =
//         locationsData.firstWhere((element) => element['id'] == technician.id);

//     return await calculateDistance(
//       customerLatitude,
//       customerLongitude,
//       location['latitude'],
//       location['longitude'],
//     );
//   }));

//   // Combine technicians with their corresponding distances
//   List<Map<String, dynamic>> techniciansWithDistances =
//       List.generate(technicians.length, (index) {
//     return {
//       'technician': technicians[index],
//       'distance': distances[index],
//     };
//   });

//   // Sort technicians based on distance
//   techniciansWithDistances.sort((a, b) {
//     double distanceA = a['distance'];
//     double distanceB = b['distance'];

//     print("Technician ${a['technician'].id} Distance: $distanceA");
//     print("Technician ${b['technician'].id} Distance: $distanceB");

//     return distanceA.compareTo(distanceB);
//   });

//   // Extract sorted technicians
//   List<DocumentSnapshot> sortedTechnicians = techniciansWithDistances
//       .map((technicianWithDistance) =>
//           technicianWithDistance['technician'] as DocumentSnapshot)
//       .toList();

//   print("Sorted nearby technicians by distance.");

//   return sortedTechnicians;
// }

// // Function to calculate distance between two points using Google Maps Distance Matrix API
// Future<double> calculateDistance(
//   double startLat,
//   double startLon,
//   double endLat,
//   double endLon,
// ) async {
//   final apiKey = 'AIzaSyArXVgSCF4LhaTp4M-ckCvz5ZzT2Xg68to';
//   final apiUrl = 'https://maps.googleapis.com/maps/api/directions/json';

//   final response = await http.get(
//     Uri.parse(
//       '$apiUrl?origin=$startLat,$startLon&destination=$endLat,$endLon&key=$apiKey',
//     ),
//   );

//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);

//     if (data['status'] == 'OK') {
//       final route = data['routes'][0]['legs'][0];
//       final distanceInMeters = route['distance']['value'];
//       return distanceInMeters / 1000.0; // Convert meters to kilometers
//     } else {
//       print('Error: ${data['status']} - ${data['error_message']}');
//       throw Exception('Failed to get directions');
//     }
//   } else {
//     print('Error: ${response.statusCode}');
//     throw Exception('Failed to get directions');
//   }
// }



// Future<void> sendNotificationsToNearbyTechnicians(
//   String serviceName,
//   double customerLatitude,
//   double customerLongitude,
// ) async {
//   print("Sending notifications to nearby technicians...");
//   print("phoneNumber is : $phoneNumber");

//   List<DocumentSnapshot> nearbyTechnicians = await getNearbyTechnicians(
//     serviceName,
//     customerLatitude,
//     customerLongitude,
//   );

//   print("Number of nearby technicians: ${nearbyTechnicians.length}");
//   // Print the sorted list of technicians
//   for (var technician in nearbyTechnicians) {
//     print("Technician ${technician['userId']}");
//   }

//   for (var technician in nearbyTechnicians) {
//     String technicianUserID = technician['userId'];
//     String userDeviceToken = "";

//     print("Fetching device token for technician $technicianUserID...");
//     await FirebaseFirestore.instance
//         .collection("technicians")
//         .doc(technicianUserID)
//         .get()
//         .then((snapshot) {
//       if (snapshot.data()!["token"] != null) {
//         userDeviceToken = snapshot.data()!["token"].toString();
//       }
//     });

//     print("Technician $technicianUserID device token: $userDeviceToken");

//     // Set up a unique identifier for this job
//     String jobId = DateTime.now().millisecondsSinceEpoch.toString();

//     // Set up the Firestore reference to "cando" field
//     DocumentReference candoRef = FirebaseFirestore.instance
//         .collection("technicians")
//         .doc(technicianUserID)
//         .collection("jobs")
//         .doc(jobId);

//     // Initialize "cando" to false
//     await candoRef.set({"accepted": false});

//     // Send notification to technician
//     print("Sending notification to technician $technicianUserID...");

//     //Send notification
//     notificationFormat(
//         technicianUserID, address, phoneNumber, userDeviceToken, jobId);

//     // Wait for the technician's response
//     print("Waiting for technician $technicianUserID response...");
//     bool jobAccepted = await waitForResponse(candoRef);

//     // If job is accepted, stop sending notifications to others
//     if (jobAccepted) {
//       print(
//           "Job accepted by technician $technicianUserID. Stopping further notifications.");
//       break;
//     }
//   }
// }

