import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/presentation/Backened%20Part/Notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationSystem {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // for termination state
  Future whenNotificationReceived(BuildContext context) async {
    try {
      _user = _auth.currentUser;

      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? remoteMessage) {
        if (remoteMessage != null) {
          openAppShowAndShowNotification(
            remoteMessage.data["phonenumber"],
            context,
          );
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
        if (remoteMessage != null) {
          openAppShowAndShowNotification(
            remoteMessage.data["phonenumber"],
            context,
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage? remoteMessage) {
        if (remoteMessage != null) {
          openAppShowAndShowNotification(
            remoteMessage.data["phonenumber"],
            context,
          );
        }
      });
    } catch (error) {
      print("Error in whenNotificationReceived: $error");
    }
  }

  openAppShowAndShowNotification(
      String phoneNumber, BuildContext context) async {
    await saveNotificationToFirestore(phoneNumber);
    List<String> notifications = await fetchNotificationsFromFirestore();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationPage(notifications: notifications),
      ),
    );
  }

  Future<void> saveNotificationToFirestore(String phoneNumber) async {
    try {
      if (_user != null) {
        await _firestore
            .collection('customers')
            .doc(_user!.uid)
            .collection('notifications')
            .add({
          'message':
              'Your service has been accepted, and we have assigned an expert to you - His number - $phoneNumber',
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        print('User not authenticated. Unable to save notification.');
      }
    } catch (error) {
      print('Error saving notification to Firestore: $error');
    }
  }

  Future<List<String>> fetchNotificationsFromFirestore() async {
    try {
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
      return [];
    }
  }
}
