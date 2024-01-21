import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceDetailsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Details List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getCustomerServiceDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Use ListView.builder to create a scrollable list of cards
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var data = snapshot.data![index];

                // Determine background color based on jobAcceptance
                Color backgroundColor = data['jobAcceptance'] ? Colors.green : Colors.red;

                // Build a Card with service details
                return Card(
                  color: backgroundColor,
                  child: ListTile(
                    title: Text('Address: ${data['address']}'),
                    subtitle: Text('Service Date: ${data['serviceDate']}'),
                    // Add more fields as needed
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getCustomerServiceDetails() async {
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

      // Get all documents in the 'serviceDetails' collection
      QuerySnapshot snapshot = await serviceDetailsCollection.get();

      // Convert each document to a map and add to the list
      List<Map<String, dynamic>> serviceDetailsList = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'address': data['address'],
          'serviceDate': data['serviceDate'],
          'timeIndex': data['timeIndex'],
          'urgentBooking': data['urgentBooking'],
          'jobAcceptance': data['jobAcceptance'],
          'userPhoneNumber': data['userPhoneNumber'],
        };
      }).toList();

      return serviceDetailsList;
    } else {
      // If user is null, return an empty list
      return [];
    }
  }
}
