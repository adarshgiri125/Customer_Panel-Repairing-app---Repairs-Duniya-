import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/presentation/log_in_two_screen/log_in_two_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<String?> getPhoneNumber(BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (user != null) {
    String userId = user.uid;

    // Reference to the 'customers' collection
    CollectionReference customers =
        FirebaseFirestore.instance.collection('customers');

    try {
      // Get the document with the user's ID
      DocumentSnapshot userDocument = await customers.doc(userId).get();

      // Check if the document exists
      if (userDocument.exists) {
        // Get the phone number from the document
        String? phoneNumber = userDocument.get('phone_number');

        return phoneNumber;
      } else {
        print('Document does not exist for user ID: $userId');
        return null;
      }
    } catch (e) {
      print('Error fetching phone number: $e');
      return null;
    }
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LogInOneScreen(),
      ),
    );
    return null;
  }
}
