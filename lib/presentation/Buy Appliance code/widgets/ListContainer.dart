// import 'package:customer_app/presentation/Buy%20Appliance%20code/screens/productDetails.dart';
// import 'package:flutter/material.dart';

// class ItemContainerWidget extends StatelessWidget {
//   final String productId;
//   final String productName;
//   final double productPrice;
//   final String productImage;

//   const ItemContainerWidget({
//     super.key,
//     required this.productId,
//     required this.productName,
//     required this.productPrice,
//     required this.productImage,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailScreen(
//               productId: productId,
//               productName: productName,
//               productPrice: productPrice,
//               productImagePath: productImage,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         height: 200,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Image(
//                 image: AssetImage(productImage),
//                 fit: BoxFit.fill,
//               ),
//             ),
//             Text(
//               productName,
//               style: const TextStyle(
//                 fontSize: 19,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               'INR ${productPrice.toString()}',
//               style: const TextStyle(
//                 fontSize: 15,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20code/screens/productDetails.dart';

class ItemContainerWidget extends StatelessWidget {
  final String productId;
  final String productName;
  final double productPrice;
  final String productImage;

  const ItemContainerWidget({
    Key? key,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(
        "Product Image URL: $productImage"); // Debug print for productImage URL

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
              child: Image.network(
                productImage,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  print("Error loading image: $error"); // Debug print for error
                  return const Icon(Icons
                      .error); // Display a generic error icon if the image fails to load
                },
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
