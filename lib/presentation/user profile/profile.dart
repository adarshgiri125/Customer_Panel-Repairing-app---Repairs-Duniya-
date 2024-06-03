import 'package:customer_app/presentation/log_in_two_screen/log_in_two_screen.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/app%20state/serviceDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = serviceDetails.userName ?? '';
  }

  void _logout() async {
    try {
      deleteLoginInfo();

      await FirebaseAuth.instance.signOut();
      // Clear any additional user data or perform other necessary tasks for logout
      print("User logged out successfully");

      // Navigate to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LogInOneScreen()),
        (route) => false,
      );
    } catch (e) {
      print("Error during logout: $e");
      // Handle logout error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.06,
            ),
          ),
          backgroundColor: Colors.amberAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            iconSize: MediaQuery.of(context).size.width * 0.067,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.2,
                child: Icon(
                  Icons.person,
                  size: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                serviceDetails.userPhoneNumber ?? '',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        0), // Set borderRadius to 0 for a square button
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0), // Adjust the padding as needed
                  child: Text('Logout'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void deleteLoginInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Delete stored information
  await prefs.remove('user_token');
  await prefs.remove('expiration_date');
}
