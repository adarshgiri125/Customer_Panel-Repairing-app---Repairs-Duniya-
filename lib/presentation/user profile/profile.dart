import 'package:customer_app/app state/app_state.dart';
import 'package:flutter/material.dart';



class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String phoneNumber = AppState.userPhoneNumber ?? "00000";

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80.0,
              backgroundImage: AssetImage('assets/profile_image.jpg'),
            ),
            SizedBox(height: 16.0),
            Text(
              phoneNumber,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
