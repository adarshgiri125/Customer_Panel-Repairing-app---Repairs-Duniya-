import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app%20state/serviceDetails.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';

void storeServiceDetails() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (user != null) {
    String userId = user.uid;

    // Generate a unique document name
    String documentName = DateTime.now().millisecondsSinceEpoch.toString();
    DateTime time = DateTime.now();

    // Create a reference to the 'customers' collection
    CollectionReference customers =
        FirebaseFirestore.instance.collection('customers');

    serviceDetails.serviceDocumentName = documentName;
    serviceDetails.user = user;
    String? phoneNumber = serviceDetails.userPhoneNumber;

    // Add a new document with a generated ID
    await customers
        .doc(userId)
        .collection('serviceDetails')
        .doc(documentName)
        .set({
      'address': serviceDetails.address,
      'serviceDate': serviceDetails.serviceDate,
      'timeIndex': serviceDetails.timeIndex,
      'urgentBooking': serviceDetails.urgentBooking,
      'jobAcceptance': false,
      'serviceName': serviceDetails.serviceName,
      'serviceList': serviceDetails.services,
      'DateTime': time,
      'userLocation': GeoPoint(serviceDetails.userLocation!.latitude,
          serviceDetails.userLocation!.longitude),
      'userPhoneNumber': serviceDetails.userPhoneNumber,
      'userId': userId,
      'phoneNumber': phoneNumber,
    });

    print('Service details stored successfully.');
  }
}

void deleteOldServiceDetails() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (user != null) {
    String userId = user.uid;

    // Reference to the 'customers' collection
    CollectionReference customers =
        FirebaseFirestore.instance.collection('customers');

    // Reference to the 'serviceDetails' subcollection
    CollectionReference serviceDetailsCollection =
        customers.doc(userId).collection('serviceDetails');

    // Get current time
    DateTime currentTime = DateTime.now();

    // Get documents older than two days
    QuerySnapshot oldDocuments = await serviceDetailsCollection
        .where('serviceDate',
            isLessThan: currentTime.subtract(Duration(days: 2)))
        .get();

    // Delete old documents
    oldDocuments.docs.forEach((doc) {
      serviceDetailsCollection.doc(doc.id).delete();
      print('Deleted old service details with document ID: ${doc.id}');
    });
  }
}
