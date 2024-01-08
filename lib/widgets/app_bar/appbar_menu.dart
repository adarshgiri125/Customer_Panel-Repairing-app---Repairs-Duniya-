import 'package:customer_app/theme/app_decoration.dart';
import 'package:flutter/material.dart';

class HalfPage extends StatelessWidget {
  final VoidCallback onClose;

  HalfPage({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          onClose();
        },
        child: Container(
          height: 300, // Set a fixed height
          margin: EdgeInsets.only(
            top: 60,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: AppDecoration.gradientAmberToErrorContainer,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Rows for the containers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildContainer(
                      'assets/images/image 64home.png','Home',
                    ),
                    _buildContainer(
                        'assets/images/image 63booking.png', 'My Booking'),

                    _buildContainer('assets/images/reward.png', 'Rewards'),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    SizedBox(
                        width: 15), // Add space to align "Name 4" with "Name 1"
                    _buildContainer('assets/images/image 68buy appliance.png',
                        'Buy Appliance'),
                    SizedBox(width: 15),
                    _buildContainer(
                        'assets/images/image 67help and support.png',
                        'Help & Support'),
                  ],
                ),

                // Row for the cross button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: onClose,
                      icon: Icon(Icons.close, color: Colors.white, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(String imagePath, String name) {
    return Column(
      children: [
        Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(imagePath), // Use your actual image path
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        // Remove SizedBox to reduce extra space
      ],
    );
  }
}
