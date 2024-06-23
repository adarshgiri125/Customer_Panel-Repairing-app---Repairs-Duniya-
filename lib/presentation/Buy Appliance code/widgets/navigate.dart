import 'package:customer_app/presentation/Buy%20Appliance%20code/screens/trackOrder.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20code/widgets/appBar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniversalAppBar(),
      drawer: OrderDrawer(),
      body: Center(
        child: Text('Main Screen Content'),
      ),
    );
  }
}

class OrderDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Order Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('My Orders'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrackOrderScreen()),
              );
            },
          ),
          // Add more options here if needed
        ],
      ),
    );
  }
}
