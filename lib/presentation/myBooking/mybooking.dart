import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
            // Use ListView.separated to create a scrollable list of cards with separators
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 15.0), // Add spacing between cards
              itemBuilder: (context, index) {
                var data = snapshot.data![index];

                // Determine background color based on jobAcceptance
                Color backgroundColor = data['jobAcceptance']
                    ? Colors.green
                    : Color.fromARGB(255, 230, 185, 5);

                // Build a Card with service details
                return Card(
                  color: backgroundColor,
                  child: ListTile(
                    title: Text('ServiceName: ${data['serviceName']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Services: ${data['serviceList']}'),
                        Text(
                            'Date: ${DateFormat('dd-MM-yyyy').format(data['DateTime'].toDate())}'),
                        Text(
                            'Time: ${DateFormat('HH:mm:ss').format(data['DateTime'].toDate())}'),
                        data['jobAcceptance']
                            ? Text('Status: BOOKING HAS ACCEPTED')
                            : Text('Status: BOOKING HAS NOT ACCEPTED YET'),
                        // Add more fields as needed
                      ],
                    ),
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

      // Get all documents in the 'serviceDetails' collection, ordered by 'DateTime' in descending order
      QuerySnapshot snapshot = await serviceDetailsCollection
          .orderBy('DateTime', descending: true)
          .get();

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
          'serviceName': data['serviceName'],
          'serviceList': data['serviceList'],
          'DateTime': data['DateTime'],
          'jobAcceptance': data['jobAcceptance']
        };
      }).toList();

      return serviceDetailsList;
    } else {
      // If user is null, return an empty list
      return [];
    }
  }
}
