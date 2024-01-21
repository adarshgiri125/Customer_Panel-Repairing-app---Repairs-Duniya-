import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:convert';
import 'package:customer_app/app%20state/serviceDetails.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:http/http.dart' as http;

String? serviceName = serviceDetails.serviceName;
String? phoneNumber = serviceDetails.userPhoneNumber;
String? documentName = serviceDetails.serviceDocumentName;
FirebaseAuth auth = FirebaseAuth.instance;
String? user = auth.currentUser?.uid;

String? address = serviceDetails.address;
Future<void> sendNotificationsToNearbyTechnicians(
  String serviceName,
  double customerLatitude,
  double customerLongitude,
) async {
  print("Sending notifications to nearby technicians...");
  print("phoneNumber is : $phoneNumber");
  print("document is : ${serviceDetails.serviceDocumentName}");
  print("user is : $user");

  List<DocumentSnapshot> nearbyTechnicians = await getNearbyTechnicians(
    serviceName,
    customerLatitude,
    customerLongitude,
  );

  print("Number of nearby technicians: ${nearbyTechnicians.length}");
  // Print the sorted list of technicians
  for (var technician in nearbyTechnicians) {
    print("hyyyyyyyyyyyyyyyy");
    String technicianUserID = technician['userId'];
    String userDeviceToken = "";

    print("Fetching device token for technician $technicianUserID...");
    await FirebaseFirestore.instance
        .collection("technicians")
        .doc(technicianUserID)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["token"] != null) {
        userDeviceToken = snapshot.data()!["token"].toString();
      }
    });

    print("Technician $technicianUserID device token: $userDeviceToken");

    DocumentReference candoRef = FirebaseFirestore.instance
        .collection("customers")
        .doc(user)
        .collection("serviceDetails")
        .doc(serviceDetails.serviceDocumentName);

    // Send notification to technician
    print("Sending notification to technician $technicianUserID...");

    // Send notification
    notificationFormat(technicianUserID, address, phoneNumber, userDeviceToken);

    print("Waiting for technician $technicianUserID response...");

    bool jobAccepted = await Future.wait([
      Future.delayed(Duration(seconds: 1)),
      isJobAccepted(candoRef),
    ]).then((results) => results[1] as bool);

    // bool jobAccepted = await isJobAccepted(candoRef);

    // Continue sending notifications to other technicians even if one accepts the job
    if (jobAccepted) {
      print(
          "Job accepted by technician $technicianUserID. Stop to send notifications.");
      break;
    }
  }
}

Future<bool> isJobAccepted(DocumentReference jobAcceptedRef) async {
  try {
    Completer<bool> responseCompleter = Completer<bool>();
    // Explicitly cast the result to the correct type
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await jobAcceptedRef.get() as DocumentSnapshot<Map<String, dynamic>>;

    // Check if the snapshot exists and 'accepted' is true
    return snapshot.exists && snapshot.data()?['jobAcceptance'] == true;
  } catch (e) {
    print("Error checking job acceptance status: $e");
    return false;
  }
}

// Add print statements to the NotificationFormat function as well
notificationFormat(receiverID, address, phoneNumber, userDeviceToken) async {
  print("Building notification format...");

  Map<String, String> headerNotification = {
    "Content-Type": "application/json",
    "Authorization":
        "key=AAAA0PM0nhk:APA91bEEQmPk1eVc7fRsFUrI5ziYm-zWCi_5BrO88PDz5A48YUU96Iwrp0fIBJ6CV6HGXsn13yOFzvKxb0Fnk2VZyK7g1cPXBm1KimmoP_028MLNiSKsULtk2h9P1QU2kNIxmSBV2h1L",
  };

  Map bodyNotification = {
    "body": "you have received a new service from $phoneNumber. click to see",
    "title": "New Customer",
  };

  Map dataMap = {
    "click_action": "FLUTTER_NOTIFICATION_CLICK",
    "id": "1",
    "status": "done",
    "phonenumber": phoneNumber,
    "documentName": serviceDetails.serviceDocumentName,
    "user": user,
  };

  Map notificationFormat = {
    "notification": bodyNotification,
    "data": dataMap,
    "priority": "high",
    "to": userDeviceToken,
  };

  print("Sending notification to technician $receiverID...");
  try {
    final response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(notificationFormat),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully to technician $receiverID.");
    } else {
      print(
          "Failed to send notification to technician $receiverID. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error while sending notification to technician $receiverID: $e");
  }
}

Future<List<DocumentSnapshot>> getNearbyTechnicians(
  String serviceName,
  double customerLatitude,
  double customerLongitude,
) async {
  print("Fetching nearby technicians...");

  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('technicians')
      .where('services', arrayContains: serviceName)
      .get();

  List<DocumentSnapshot> technicians = result.docs;

  // Fetch all currentLocation data asynchronously
  List<Map<String, dynamic>> locationsData = await Future.wait(
    technicians.map((technician) async {
      try {
        DocumentSnapshot currentLocationSnapshot = await technician.reference
            .collection('location')
            .doc('currentLocation')
            .get();

        if (currentLocationSnapshot.exists) {
          return {
            'id': technician.id,
            'latitude': currentLocationSnapshot['latitude'] ?? 0.0,
            'longitude': currentLocationSnapshot['longitude'] ?? 0.0,
          };
        } else {
          print(
              "currentLocation document does not exist for technician ${technician.id}");
        }
      } catch (e) {
        print("Error fetching location for technician ${technician.id}: $e");
      }

      return {
        'id': technician.id,
        'latitude': 0.0,
        'longitude': 0.0,
      };
    }),
  );

  // Calculate distances asynchronously
  List<double> distances =
      await Future.wait(technicians.map((technician) async {
    Map<String, dynamic> location =
        locationsData.firstWhere((element) => element['id'] == technician.id);

    return await calculateDistance(
      customerLatitude,
      customerLongitude,
      location['latitude'],
      location['longitude'],
    );
  }));

  // Combine technicians with their corresponding distances
  List<Map<String, dynamic>> techniciansWithDistances =
      List.generate(technicians.length, (index) {
    return {
      'technician': technicians[index],
      'distance': distances[index],
    };
  });

  // Sort technicians based on distance
  techniciansWithDistances.sort((a, b) {
    double distanceA = a['distance'];
    double distanceB = b['distance'];

    print("Technician ${a['technician'].id} Distance: $distanceA");
    print("Technician ${b['technician'].id} Distance: $distanceB");

    return distanceA.compareTo(distanceB);
  });

  // Extract sorted technicians
  List<DocumentSnapshot> sortedTechnicians = techniciansWithDistances
      .map((technicianWithDistance) =>
          technicianWithDistance['technician'] as DocumentSnapshot)
      .toList();

  print("Sorted nearby technicians by distance.");

  return sortedTechnicians;
}

// Function to calculate distance between two points using Google Maps Distance Matrix API
Future<double> calculateDistance(
  double startLat,
  double startLon,
  double endLat,
  double endLon,
) async {
  final apiKey = 'AIzaSyArXVgSCF4LhaTp4M-ckCvz5ZzT2Xg68to';
  final apiUrl = 'https://maps.googleapis.com/maps/api/directions/json';

  final response = await http.get(
    Uri.parse(
      '$apiUrl?origin=$startLat,$startLon&destination=$endLat,$endLon&key=$apiKey',
    ),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final route = data['routes'][0]['legs'][0];
      final distanceInMeters = route['distance']['value'];
      return distanceInMeters / 1000.0; // Convert meters to kilometers
    } else {
      print('Error: ${data['status']} - ${data['error_message']}');
      throw Exception('Failed to get directions');
    }
  } else {
    print('Error: ${response.statusCode}');
    throw Exception('Failed to get directions');
  }
}
