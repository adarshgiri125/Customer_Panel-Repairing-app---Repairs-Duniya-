// ignore_for_file: file_names


import 'package:customer_app/presentation/Buy%20Appliance%20model/provider/cartProvider.dart';
import 'package:customer_app/presentation/Buy%20Appliance/screens/orderConfirmScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentModeScreen extends StatefulWidget {
  const PaymentModeScreen({super.key});

  @override
  State<PaymentModeScreen> createState() => _PaymentModeScreenState();
}

class _PaymentModeScreenState extends State<PaymentModeScreen> {
  String? selectedPaymentMode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mode Of Payment'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mode Of Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RadioListTile<String>(
                  title: const Text('Online Payment'),
                  value: 'Online Payment',
                  subtitle: const Text(
                    'Deliver in 45 minutes & Free installation',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  groupValue: selectedPaymentMode,
                  onChanged: (String? value) {
                    setState(() {
                      selectedPaymentMode = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                RadioListTile<String>(
                  title: const Text('Cash On Delivery'),
                  value: 'Cash On Delivery',
                  groupValue: selectedPaymentMode,
                  subtitle: const Text(
                    'Free installat & Same Day Delivery',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      selectedPaymentMode = value;
                    });
                  },
                ),

                // Add more RadioListTile widgets for other payment modes here
              ],
            ),
          ),
          Consumer<CartProvider>(
            builder: (context, value, child) => Container(
              padding: const EdgeInsets.all(15.0),
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
                  Row(
                    children: [
                      Text(
                        'ITEMS: ${value.totalItems}',
                      ),
                      const Spacer(),
                      Text(
                        'INR ${value.productTotalPrice.toStringAsFixed(2)}',
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Center(
                                    child: Container(
                                      height: 200,
                                      width: 250,
                                      padding: const EdgeInsets.all(15),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'View Billing Details',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon:
                                                      const Icon(Icons.cancel)),
                                            ],
                                          ),
                                          Text(
                                            'INR ${value.productTotalPrice.toStringAsFixed(2)}',
                                          ),
                                          const Text('Discount -500'),
                                          const Divider(),
                                          Text(
                                            'Total : INR ${value.productTotalPrice - 500}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                        },
                        child: const Text(
                          'View Billing Details',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
                      confirmOrder(context);
                    },
                    child: const Text(
                      'PLACE ORDER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Processing Order..."),
            ],
          ),
        ),
      );
    },
  );
}

void confirmOrder(BuildContext context) {
  showLoadingDialog(context);

  // Simulate a network request or some processing delay
  Future.delayed(const Duration(seconds: 3), () {
    Navigator.pop(context); // Remove the loading dialog
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OrderConfirmationScreen(),
      ),
    );
  });
}
