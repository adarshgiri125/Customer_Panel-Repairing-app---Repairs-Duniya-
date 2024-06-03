// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

class ItemsModel {
  final String productId;
  final String productName;
  final double productPrice;
  final String productImagePath;
  int quantity;

  ItemsModel({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImagePath,
    this.quantity = 1,
  });
}
