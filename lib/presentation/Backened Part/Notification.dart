import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<String> notifications;
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NotificationPage({required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchNotificationsFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<String> notifications = snapshot.data ?? [];
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notifications[index]),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<String>> fetchNotificationsFromFirestore() async {
    try {
      _user = _auth.currentUser;

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('customers')
          .doc(_user!.uid)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .get();

      List<String> notifications =
          querySnapshot.docs.map((doc) => doc['message'].toString()).toList();
      return notifications;
    } catch (error) {
      print('Error fetching notifications from Firestore: $error');
      throw error; // Rethrow the error to be caught by the FutureBuilder
    }
  }
}
