import 'package:customer_app/theme/app_decoration.dart';
import 'package:flutter/material.dart';

import '../../presentation/home_page_screen/home_page_screen.dart';
import '../../presentation/myBooking/mybooking.dart';

class HalfPage extends StatelessWidget {
  final VoidCallback onClose;

  HalfPage({required this.onClose});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double bottomMargin = MediaQuery.of(context).viewInsets.bottom + 20;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: onClose,
        child: Container(
          height: screenHeight * 0.4, // Set a percentage of the screen height
          margin: EdgeInsets.only(
            top: screenHeight * 0.1, // Set a percentage of the screen height
            bottom: bottomMargin,
          ),
          decoration: AppDecoration.gradientAmberToErrorContainer,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Rows for the containers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildClickableContainer(
                    'assets/images/image 64home.png',
                    'Home',
                        () => _navigateToHomeScreen(context),
                  ),
                  _buildClickableContainer(
                    'assets/images/image 63booking.png',
                    'My Booking',
                        () => _navigateToBookingScreen(context),
                  ),
                  _buildClickableContainer(
                    'assets/images/reward.png',
                    'Rewards',
                        () => _navigateToRewardsScreen(context),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  SizedBox(width: 15),
                  _buildClickableContainer(
                    'assets/images/image 68buy appliance.png',
                    'Buy Appliance',
                        () => _navigateToBuyApplianceScreen(context),
                  ),
                  SizedBox(width: 15),
                  _buildClickableContainer(
                    'assets/images/image 67help and support.png',
                    'Help & Support',
                        () => _navigateToHelpScreen(context),
                  ),
                ],
              ),
              // Row for the cross button
              SizedBox(height: 10),
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

  Widget _buildClickableContainer(String imagePath, String name, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: _buildContainer(imagePath, name),
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
              image: AssetImage(imagePath),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePageScreen()),
    );
  }

  void _navigateToBookingScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ServiceDetailsList()),
    );
  }

  void _navigateToRewardsScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RewardsScreen()),
    );
  }

  void _navigateToBuyApplianceScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BuyApplianceScreen()),
    );
  }

  void _navigateToHelpScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HelpScreen()),
    );
  }
}

class RewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards'),
      ),
      body: Center(
        child: Text('This is the Rewards screen'),
      ),
    );
  }
}

class BuyApplianceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Appliance'),
      ),
      body: Center(
        child: Text('This is the Buy Appliance screen'),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
      ),
      body: Center(
        child: Text('This is the Help & Support screen'),
      ),
    );
  }
}
