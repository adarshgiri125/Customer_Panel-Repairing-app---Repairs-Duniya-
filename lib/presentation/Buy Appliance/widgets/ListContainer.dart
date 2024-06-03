// ignore_for_file: file_names
import 'package:customer_app/presentation/Buy%20Appliance/screens/productDetails.dart';
import 'package:flutter/material.dart';

class ItemContainerWidget extends StatelessWidget {
  final String productId;
  final String productName;
  final double productPrice;
  final String productImage;

  const ItemContainerWidget({
    super.key,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productId: productId,
              productName: productName,
              productPrice: productPrice,
              productImagePath: productImage,
            ),
          ),
        );
      },
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image(
                image: AssetImage(productImage),
                fit: BoxFit.fill,
              ),
            ),
            Text(
              productName,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'INR ${productPrice.toString()}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
