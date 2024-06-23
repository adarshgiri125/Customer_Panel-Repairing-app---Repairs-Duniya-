import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  _TrackOrderScreenState createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  late StreamSubscription<QuerySnapshot> _orderSubscription;
  List<Map<String, dynamic>> ordersData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _subscribeToOrders();
  }

  @override
  void dispose() {
    _orderSubscription.cancel(); // Cancel subscription to avoid memory leaks
    super.dispose();
  }

  void _subscribeToOrders() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      final userDocRef =
          FirebaseFirestore.instance.collection('customers').doc(user.uid);
      _orderSubscription =
          userDocRef.collection('orders').snapshots().listen((querySnapshot) {
        setState(() {
          ordersData = querySnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ordersData.isEmpty
              ? const Center(child: Text('No orders found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(15.0),
                  itemCount: ordersData.length,
                  itemBuilder: (context, index) {
                    final order = ordersData[index];
                    final userDetails = order['userDetails'] ?? {};
                    final cartItems = order['cartItemsDetails'] ?? [];
                    final orderStatus = order['status'] ?? 'Pending';

                    // Handling data types correctly
                    final amountPayable = order['amountPayable'] is double
                        ? order['amountPayable']
                        : double.tryParse(order['amountPayable'].toString()) ??
                            0.0;
                    final discount = order['discount'] is double
                        ? order['discount']
                        : double.tryParse(order['discount'].toString()) ?? 0.0;
                    final amountPaid = order['amountPaid'] is double
                        ? order['amountPaid']
                        : double.tryParse(order['amountPaid'].toString()) ??
                            0.0;
                    final pendingConfirmation =
                        order['pendingConfirmation'] is double
                            ? order['pendingConfirmation']
                            : double.tryParse(
                                    order['pendingConfirmation'].toString()) ??
                                0.0;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order ID: ${order['orderId'] ?? 'Unknown'}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                            const SizedBox(height: 10),
                            const Text(
                              'Item List',
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                            ...cartItems.map<Widget>((item) {
                              return ListTile(
                                title: Text(item['productName'] ?? 'Unknown'),
                                subtitle: Text(
                                    'INR ${item['productPrice'] ?? 0}\nQuantity: ${item['quantity'] ?? 0}'),
                              );
                            }).toList(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Chip(
                                  label: const Text('Received'),
                                  backgroundColor: orderStatus == 'Received'
                                      ? Colors.green.shade100
                                      : Colors.white,
                                ),
                                Chip(
                                  label: const Text('Dispatched'),
                                  backgroundColor: orderStatus == 'Dispatched'
                                      ? Colors.green.shade100
                                      : Colors.white,
                                ),
                                Chip(
                                  label: const Text('Pending'),
                                  backgroundColor: orderStatus == 'Pending'
                                      ? Colors.green.shade100
                                      : Colors.white,
                                ),
                              ],
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(Icons.receipt_long,
                                  color: Colors.green),
                              title: const Text('Order Status'),
                              subtitle: Text(orderStatus),
                              trailing: TextButton(
                                onPressed: () {},
                                child: const Text('Track Order'),
                              ),
                            ),
                            const Divider(),
                            const Text(
                              'Payment Details',
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                            ListTile(
                              title: const Text('Total Amount Payable'),
                              trailing: Text('INR ${amountPayable - discount}'),
                            ),
                            ListTile(
                              title: const Text('Total Product Discount'),
                              trailing: Text('- INR $discount'),
                            ),
                            ListTile(
                              title: const Text('Total Amount Paid'),
                              trailing: Text('INR $amountPaid'),
                            ),
                            const Divider(),
                            SizedBox(height: 10)
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
