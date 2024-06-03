import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
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
                Color backgroundColor =
                    data['jobAcceptance'] ? Colors.white : Colors.white;

                // Build a Card with service details
                return Card(
                  color: backgroundColor,
                  child: ListTile(
                    title: Text('ServiceName: ${data['serviceName']}'),
                    // title: data['technicanNotAvailable']
                    //     ? Text("Pending")
                    //     : data['jobStatus']
                    //         ? Text("Completed")
                    //         : Text("Accepted"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 3,
                        ),
                        Text('Services: ${data['serviceList']}'),
                        Text(
                          'Date: ${DateFormat('dd-MM-yyyy').format(data['DateTime'].toDate())}',
                        ),
                        Text(
                          'Time: ${DateFormat('HH:mm:ss').format(data['DateTime'].toDate())}',
                        ),
                        data['jobAcceptance']
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  data['jobStatus']
                                      ? Text("Status : Completed")
                                      : Text("Status : Accepted"),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                            data['profilePictureUrl'],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                    text: 'Technician Name : ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${data['technicianName']}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                    text: 'Rating : ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  WidgetSpan(
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .middle,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .green, // Set background color to green
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5), // Set border radius
                                                      ),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Transform.translate(
                                                            offset: const Offset(
                                                                0,
                                                                0), // Adjust the offset to align the star vertically
                                                            child: const Icon(
                                                              Icons.star,
                                                              size:
                                                                  19, // Adjust the size of the icon
                                                              color: Colors
                                                                  .white, // Set icon color to white
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            '${data['rating']}',
                                                            style: GoogleFonts
                                                                .openSans(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Colors
                                                                  .white, // Set text color to white
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                    text: 'Works Completed : ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '${data['jobCompleted']}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                    text: 'Nature : ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  WidgetSpan(
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .middle,
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 2,
                                                          horizontal: 8),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors
                                                              .green, // Set border color to green
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                4), // Set border radius
                                                      ),
                                                      child: Text(
                                                        '${data['status']}',
                                                        style: GoogleFonts
                                                            .openSans(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: Colors
                                                              .green, // Set text color to green
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Text('Status: Pending'),
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

      // Fetch additional details for each service detail document
      List<Map<String, dynamic>> serviceDetailsList = [];

      for (DocumentSnapshot doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        // Only fetch additional technician details if job acceptance is true
        if (data['jobAcceptance']) {
          // Fetch technician details using technicianPhoneNumber
          String technicianPhoneNumber = data['userPhoneNumber'];

          QuerySnapshot technicianSnapshot = await FirebaseFirestore.instance
              .collection('technicians')
              .where('phone', isEqualTo: technicianPhoneNumber)
              .limit(1)
              .get();

          if (technicianSnapshot.docs.isNotEmpty) {
            var technicianData =
                technicianSnapshot.docs.first.data() as Map<String, dynamic>;
            String technicianName = technicianData['technicianName'] ?? "";
            String technicianUserId = technicianData['userId'] ?? "";
            String profilePictureUrl = technicianData
                    .containsKey('technicianProfilePicture')
                ? technicianData['technicianProfilePicture']
                : "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";
            num? ratingValue = technicianData['Rating'];
            double rating = (ratingValue ?? 0.0).toDouble();

            String roundedRating = rating.toStringAsFixed(1);
            String status = "";
            String jobCompleted =
                (technicianData['workDone'] ?? "0").toString();

            int polite = technicianData['polite'] ?? 0;
            int punctual = technicianData['punctual'] ?? 0;
            int quickAndAccurate = technicianData['quickAndAccurate'] ?? 0;
            int friendly = technicianData['friendly'] ?? 0;

            int maxRating = [polite, punctual, quickAndAccurate, friendly]
                .reduce((a, b) => a > b ? a : b);

            if (maxRating == polite) {
              status = "Polite";
            } else if (maxRating == punctual) {
              // Punctual is the maximum rating
              // Do something...
              status = "Punctual";
            } else if (maxRating == quickAndAccurate) {
              // Quick and Accurate is the maximum rating
              // Do something...
              status = "Quick And Accurate";
            } else if (maxRating == friendly) {
              // Friendly is the maximum rating
              // Do something...
              status = "Friendly";
            } else {
              status = "Polite";
            }
            String workStatus = data['workStatus'];
            bool jobStatus = false;
            if (workStatus == "Complete Working") {
              jobStatus = true;
            }
            // Add technician details to the serviceDetailsList
            serviceDetailsList.add({
              'address': data['address'],
              'serviceDate': data['serviceDate'],
              'timeIndex': data['timeIndex'],
              'urgentBooking': data['urgentBooking'],
              'jobAcceptance': data['jobAcceptance'],
              'userPhoneNumber': data['userPhoneNumber'],
              'serviceName': data['serviceName'],
              'serviceList': data['serviceList'],
              'DateTime': data['DateTime'],
              'jobAcceptance': data['jobAcceptance'],
              'technicianName': technicianName,
              'technicianUserId': technicianUserId,
              'profilePictureUrl': profilePictureUrl,
              'rating': roundedRating,
              'status': status,
              'jobCompleted': jobCompleted,
              'jobStatus': jobStatus,
              'technicanNotAvailable': false,
            });
          }
        } else {
          // If job acceptance is false, add service details without technician details
          serviceDetailsList.add({
            'address': data['address'],
            'serviceDate': data['serviceDate'],
            'timeIndex': data['timeIndex'],
            'urgentBooking': data['urgentBooking'],
            'jobAcceptance': data['jobAcceptance'],
            'userPhoneNumber': data['userPhoneNumber'],
            'serviceName': data['serviceName'],
            'serviceList': data['serviceList'],
            'DateTime': data['DateTime'],
            'jobAcceptance': data['jobAcceptance'],
            'technicanNotAvailable': true,
          });
        }
      }

      return serviceDetailsList;
    } else {
      // If user is null, return an empty list
      return [];
    }
  }
}
