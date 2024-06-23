import 'package:cloud_firestore/cloud_firestore.dart';

class ItemsModel {
  final String productId;
  final double productPrice;
  final String productImagePath;
  final String productName;
  final bool available; // Add the available field

  ItemsModel({
    required this.productId,
    required this.productPrice,
    required this.productImagePath,
    required this.productName,
    required this.available, // Initialize the available field
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productPrice': productPrice,
      'productImagePath': productImagePath,
      'productName': productName,
      'available': available, // Include the available field
    };
  }

  factory ItemsModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ItemsModel(
      productId: data['productId'],
      productPrice: data['productPrice'],
      productImagePath: data['productImagePath'],
      productName: data['productName'],
      available: data['available'] ??
          false, // Handle the case where available is missing
    );
  }
}
