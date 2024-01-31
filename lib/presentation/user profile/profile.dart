import 'package:customer_app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/app%20state/serviceDetails.dart';

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
                    height: 20.v,
                  ),
                  Text(
                    serviceDetails.userPhoneNumber ?? '',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ]))));

    // Editable name field
  }
}
