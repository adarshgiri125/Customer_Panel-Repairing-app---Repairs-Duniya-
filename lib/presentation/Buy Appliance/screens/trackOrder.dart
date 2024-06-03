
import 'package:customer_app/presentation/Buy%20Appliance%20model/provider/addressProvider.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/provider/cartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrackOrderScreen extends StatelessWidget {
  final String orderId = '#5PYL4D';
  final String productName = 'Orient Air cooler0';
  final double discount = 573.00;
  final double amountPayable = 8726.00;
  final double amountPaid = 0.00;
  final double pendingConfirmation = 8726.00;
  final double confirmedAmount = 0.00;

  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID $orderId',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Item List',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            ListTile(
              leading: Image.network(
                'https://via.placeholder.com/50',
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
              title: Text(productName),
              subtitle: Text(
                  'INR ${cartProvider.productTotalPrice}\nQuantity: ${cartProvider.totalItems}'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Chip(
                  label: const Text('Received'),
                  backgroundColor: Colors.green.shade100,
                ),
                Chip(
                  label: const Text('Not Shipped'),
                  backgroundColor: Colors.orange.shade100,
                ),
                Chip(
                  label: const Text('Pending'),
                  backgroundColor: Colors.grey.shade100,
                ),
              ],
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.green),
              title: const Text('Order Status'),
              subtitle: const Text('Received'),
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
              title: const Text('Total Product Price'),
              trailing: Text('INR ${cartProvider.productTotalPrice}'),
            ),
            ListTile(
              title: const Text('Total Product Discount'),
              trailing: Text('- INR $discount'),
            ),
            ListTile(
              title: const Text('Total Amount Payable'),
              trailing:
                  Text('INR ${cartProvider.productTotalPrice - discount}'),
            ),
            ListTile(
              title: const Text('Total Amount Paid'),
              trailing: Text('INR $amountPaid'),
            ),
            ListTile(
              title: const Text('Payment Pending Confirmation'),
              trailing: Text('INR $pendingConfirmation'),
            ),
            const Divider(),
            const Text(
              'Mode of Payment',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
