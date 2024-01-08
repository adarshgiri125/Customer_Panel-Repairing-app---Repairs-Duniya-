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
              ),
              SizedBox(
                height: 20.v,
              ),
              // Editable name field
              _isEditing
                  ? Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(
                          color: Colors.black, // You can adjust the color
                          width: 2.0, // You can adjust the width
                        ), // You can adjust the color
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(
                          color: Colors.black, // You can adjust the color
                          width: 2.0, // You can adjust the width
                        ),
                        // You can adjust the color
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Name: ${serviceDetails.userName ?? ''}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    _isEditing = true;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                height: 20.v,
              ),
              ElevatedButton(
                onPressed: () {
                  // Save the user's name
                  serviceDetails.userName = _nameController.text;
                  // Update the UI
                  setState(() {
                    _isEditing = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Background color
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
