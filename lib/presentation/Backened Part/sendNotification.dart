import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:convert';
import 'package:customer_app/app%20state/serviceDetails.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:http/http.dart' as http;

String? serviceName = serviceDetails.serviceName;
String? phoneNumber = serviceDetails.userPhoneNumber;
FirebaseAuth auth = FirebaseAuth.instance;
String? user = auth.currentUser?.uid;
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Timestamp timeStamp = Timestamp.now();

bool job = false;
String timing = '';
DateTime currentTime = DateTime.now();
DateTime bookingTime = DateTime.now();
int time = -1;
bool urgentBooking = false;
DateTime date = timeStamp.toDate();
GeoPoint? geoPoint = GeoPoint(serviceDetails.userLocation!.latitude,
    serviceDetails.userLocation!.longitude);

String service = "";

String? address = serviceDetails.address;
Future<void> sendNotificationsToNearbyTechnicians(
    String serviceName,
    double customerLatitude,
    double customerLongitude,
    String documentName,
    String customerName) async {
  print("Sending notifications to nearby technicians...");
  print("phoneNumber is : $phoneNumber");
  print("document is : ${serviceDetails.serviceDocumentName}");
  print("user is : $user");

  await FirebaseFirestore.instance
      .collection("customers")
      .doc(user)
      .collection("serviceDetails")
      .doc(documentName)
      .get()
      .then((snapshot) async {
    if (snapshot.exists) {
      job = snapshot.data()?['jobAcceptance'] ?? false;
      time = snapshot.data()?['timeIndex'] ?? -1;
      urgentBooking = snapshot.data()?['urgentBooking'] ?? false;
      timeStamp = Timestamp.now();
      if (urgentBooking == false) {
        timeStamp = snapshot.data()?['serviceDate'] ?? Timestamp.now();
        date = timeStamp.toDate();
      }
      if (urgentBooking == true) {
        Timestamp.now();
        date = timeStamp.toDate();
      }
      geoPoint = snapshot.data()?['userLocation'];
      service = snapshot.data()?['serviceName']?.toString() ?? 'hello';
      timeStamp = snapshot.data()?['DateTime'] ?? Timestamp.now();
      bookingTime = timeStamp.toDate();
      currentTime = DateTime.now();
      if (time == 0) {
        timing = 'Morning';
      } else if (time == 1) {
        timing = 'Afternoon';
      } else if (time == 2) {
        timing = 'Evening';
      }
    }
  });

  List<DocumentSnapshot> nearbyTechnicians = await getNearbyTechnicians(
    serviceName,
    customerLatitude,
    customerLongitude,
  );

  /// admin section----->>>>>
  print("geting details of admin... who is registered");
  List<String> adminDeviceTokens =
      await getAdminDeviceTokens(serviceDetails.city!);
  print("$adminDeviceTokens.length");
  //send notification to admin
  for (var adminToken in adminDeviceTokens) {
    print("Sending notification to admin...");
    notificationFormat("admins", address, phoneNumber, adminToken);
  }
  ////<<<<<------

  int availableTechniciansCount = nearbyTechnicians.length;
  DocumentReference candoRef = FirebaseFirestore.instance
      .collection("customers")
      .doc(user)
      .collection("serviceDetails")
      .doc(serviceDetails.serviceDocumentName);

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

    // Send notification to technician
    print("Sending notification to technician $technicianUserID...");
    String customerTokenId = '';

    await FirebaseFirestore.instance
        .collection('customers')
        .doc(user)
        .get()
        .then((snapshot) {
      if (snapshot.data()!['device_token'] != null) {
        customerTokenId = snapshot.data()!['device_token'].toString();
      }
    });

    print("date: $date");
    print("urgent: $urgentBooking");

    //sending document to the technician side ------>>>
    String techdocName = DateTime.now().millisecondsSinceEpoch.toString();
    await _firestore
        .collection('technicians')
        .doc(technicianUserID)
        .collection('serviceList')
        .doc(techdocName)
        .set({
      'jobAcceptance': job,
      'timeIndex': timing,
      'date': date,
      'serviceName': service,
      'serviceId': documentName,
      'customerPhone': phoneNumber,
      'urgentBooking': urgentBooking,
      'customerAddress': address,
      'customerLocation': geoPoint,
      'customerId': user,
      'customerTokenId': customerTokenId,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'n',
      'workStatus': "not started yet",
      'customerName': customerName,
      'subCategory': serviceDetails.services![0],
    }, SetOptions(merge: true));

    await candoRef.set(
      {
        'technicianAvailable': availableTechniciansCount.toString(),
      },
      SetOptions(merge: true),
    );

    notificationFormat(technicianUserID, address, phoneNumber, userDeviceToken);

    // print("Waiting for technician $technicianUserID response...");

    // bool jobAccepted = await Future.wait([
    //   Future.delayed(Duration(seconds: 180)),
    //   isJobAccepted(candoRef),
    // ]).then((results) => results[1] as bool);

    // bool jobAccepted = await isJobAccepted(candoRef);

    // Continue sending notifications to other technicians even if one accepts the job
    // if (jobAccepted) {
    //   await candoRef.set({
    //     'technicianAvailable': 0.toString(),
    //   }, SetOptions(merge: true));
    //   print(
    //       "Job accepted by technician $technicianUserID. Stop to send notifications.");
    //   break;
    // }
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
  List<Map<String, dynamic>> techniciansWithDistances = [];

  for (int index = 0; index < technicians.length; index++) {
    Map<String, dynamic> location = locationsData
        .firstWhere((element) => element['id'] == technicians[index].id);

    double distance = await calculateDistance(
      customerLatitude,
      customerLongitude,
      location['latitude'],
      location['longitude'],
    );

    if (distance <= 13.0) {
      techniciansWithDistances.add({
        'technician': technicians[index],
        'distance': distance,
      });
      print(
          "Technician ${technicians[index].id} is close (distance: $distance km). including from the list.");
    } else {
      print(
          "Technician ${technicians[index].id} is too far away (distance: $distance km). Excluding from the list.");
    }
  }

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
  if (endLat == 0.0 || endLon == 0.0) {
    print("Invalid destination coordinates: Latitude or longitude is 0.0");
    return double.infinity; // Return a large value to indicate invalid distance
  }
  print("check${startLat}, ${startLon}, $endLat, $endLon");
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
