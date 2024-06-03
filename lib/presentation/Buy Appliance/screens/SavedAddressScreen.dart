// ignore_for_file: file_names

import 'package:customer_app/presentation/Buy%20Appliance%20model/provider/addressProvider.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/provider/cartProvider.dart';
import 'package:customer_app/presentation/Buy%20Appliance/screens/paymentModeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedAddressScreen extends StatelessWidget {
  const SavedAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add address screen
            },
          ),
        ],
      ),

      //On this developer has to fetch the details of address from Firebase

      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Name: ${addressProvider.fullName ?? ''}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            addressProvider.addressType ?? '',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Edit address action
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Address Type :${addressProvider.address ?? ''}'),
                    const SizedBox(height: 4),
                    Text("Postal Code :${addressProvider.postalCode ?? ''}"),
                    const SizedBox(height: 4),
                    Text('Contact Number: ${addressProvider.phone ?? ''}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: (value) {
                            // Handle checkbox change
                          },
                        ),
                        const Text('Ship To This Address'),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Delete address action
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.green),
                    title: Text(
                        'Delivery To ${addressProvider.addressType ?? ''}'),
                    subtitle: Text(addressProvider.address ?? ''),
                  ),
                  const Divider(),
                  //₹
                  Consumer<CartProvider>(
                    builder: (context, value, child) => ListTile(
                      title: Text(
                        'ITMES: ${value.totalItems}',
                      ),
                      trailing: Text(
                        'INR ${value.productTotalPrice.toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const BeveledRectangleBorder(),
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PaymentModeScreen()),
                      );
                    },
                    child: const Text(
                      'PROCEED TO PAY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
