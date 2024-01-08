//  Future<void> sendNotificationsToNearbyTechnicians(String serviceName,
//       double customerLatitude, double customerLongitude) async {
//     List<DocumentSnapshot> nearbyTechnicians = await getNearbyTechnicians(
//         serviceName!,
//         serviceDetails.userLocation!.latitude,
//         serviceDetails.userLocation!.longitude);
//     sendNotificationToUser(receiverID, address, phoneNumber) async {
//       for (var technician in nearbyTechnicians) {
//         String technicianUserID = technician['userID'];
//         String userDeviceToken = "";
//         await FirebaseFirestore.instance
//             .collection("users")
//             .doc(receiverID)
//             .get()
//             .then((snapshot) {
//           if (snapshot.data()!["userDeviceToken"] != null) {
//             userDeviceToken = snapshot.data()!["userDeviceToken"].toString();
//           }
//         });
//         NotificationFormat(receiverID, address, phoneNumber, userDeviceToken);

//         bool jobAccepted = await waitForResponse(technician['userID']);
//         if (jobAccepted) {
//           // Technician accepted the job, stop sending notifications to others
//           break;
//         }
//       }
//     }
//   }

//   Future<bool> waitForResponse(String technicianId) async {
//     // Implement your logic to wait for the technician's response.
//     // For example, you might use a stream or another asynchronous mechanism.

//     // Placeholder implementation, you should replace this with your actual logic
//     await Future.delayed(Duration(
//         seconds: 300)); // Simulating a delay for demonstration purposes

//     return true; // Return true if the job is accepted, false otherwise
//   }

//   NotificationFormat(receiverID, address, phoneNumber, userDeviceToken) {
//     Map<String, String> headerNotification = {
//       "Content-Type": "application/json",
//       "Authorization":
//           "key=AAAA0PM0nhk:APA91bEEQmPk1eVc7fRsFUrI5ziYm-zWCi_5BrO88PDz5A48YUU96Iwrp0fIBJ6CV6HGXsn13yOFzvKxb0Fnk2VZyK7g1cPXBm1KimmoP_028MLNiSKsULtk2h9P1QU2kNIxmSBV2h1L",
//     };

//     Map bodyNotification = {
//       "body": "you have received a new service from $phoneNumber. click to see",
//       "title": "New Customer",
//     };

//     Map dataMap = {
//       "click_action": "FLUTTER_NOTIFICATION_CLICK",
//       "id": "1",
//       "status": "done",
//       // "userid": userId,
//       "phonenumber": phoneNumber,
//       "address": address,
//     };

//     Map notificationFormat = {
//       "notification": bodyNotification,
//       "data": dataMap,
//       "priority": "high",
//       "to": userDeviceToken,
//     };

//     http.post(
//       Uri.parse("https://fcm.googleapis.com/fcm/send"),
//       body: jsonEncode(notificationFormat),
//     );
//   }

//   Future<List<DocumentSnapshot>> getNearbyTechnicians(String serviceName,
//       double customerLatitude, double customerLongitude) async {
//     final QuerySnapshot result = await FirebaseFirestore.instance
//         .collection('users')
//         .doc('technician')
//         .collection('technicians')
//         .where(
//           'currentLocation',
//           isGreaterThanOrEqualTo:
//               GeoPoint(customerLatitude - 0.1, customerLongitude - 0.1),
//           isLessThanOrEqualTo:
//               GeoPoint(customerLatitude + 0.1, customerLongitude + 0.1),
//         )
//         .where('jobAccepted', isEqualTo: false)
//         .where('services',
//             arrayContains:
//                 serviceName) // Assuming 'services' is a field in the technician document containing a list of provided services
//         .orderBy('currentLocation', descending: false)
//         .get();

//     return result.docs;
//   }