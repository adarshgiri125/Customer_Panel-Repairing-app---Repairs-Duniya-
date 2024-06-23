// // ignore_for_file: file_names

// import 'package:customer_app/presentation/Buy%20Appliance%20model/class/itemModel.dart';
// import 'package:customer_app/presentation/Buy%20Appliance%20model/lists/ItemsCatelog.dart';
// import 'package:customer_app/presentation/Buy%20Appliance%20code/screens/home.dart';
// import 'package:customer_app/presentation/Buy%20Appliance%20code/screens/trackOrder.dart';
// import 'package:customer_app/presentation/Buy%20Appliance%20code/widgets/ListContainer.dart';
// import 'package:flutter/material.dart';

// class OrderConfirmationScreen extends StatelessWidget {
//   final bookingid;

//   const OrderConfirmationScreen({super.key, required this.bookingid});

//   @override
//   Widget build(BuildContext context) {
//     // Feature List of Products for showing from All Products
//     List<ItemsModel> showingItems = allItemsCatalog.sublist(0, 5);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Order Confirmed'),
//         automaticallyImplyLeading: false,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 20),
//               const Icon(
//                 Icons.check_circle,
//                 color: Colors.green,
//                 size: 100,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Order Confirmed',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 'Your Order ID - ${bookingid}',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black54,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Thanks for your Order',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Text(
//                 'Your order has been placed successfully',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black54,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const TrackOrderScreen(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       // onPrimary: Colors.orange,
//                       side: const BorderSide(color: Colors.black),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 30,
//                         vertical: 15,
//                       ),
//                     ),
//                     child: const Text(
//                       'Track Order',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const HomeScreen(),
//                         ),
//                         (route) => false,
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.black,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 30,
//                         vertical: 15,
//                       ),
//                     ),
//                     child: const Text(
//                       'BACK TO HOME',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'People Also Bought This',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               GridView.builder(
//                 itemCount: showingItems.length,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 5,
//                   mainAxisSpacing: 25,
//                   childAspectRatio: 0.75,
//                 ),
//                 itemBuilder: (context, index) {
//                   return ItemContainerWidget(
//                     productId: showingItems[index].productId,
//                     productName: showingItems[index].productName,
//                     productPrice: showingItems[index].productPrice,
//                     productImage: showingItems[index].productImagePath,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/lists/itemcatalog.dart';
import 'package:flutter/material.dart';

import 'package:customer_app/presentation/Buy%20Appliance%20code/screens/home.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20code/screens/trackOrder.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20code/widgets/ListContainer.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final String bookingid;

  const OrderConfirmationScreen({Key? key, required this.bookingid});

  @override
  _OrderConfirmationScreenState createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  List<ItemsModel> showingItems = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('itemsCatalog')
          .limit(5)
          .get();
      setState(() {
        showingItems = querySnapshot.docs
            .map((doc) => ItemsModel.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      // Handle errors if any
      print('Error fetching items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Order Confirmed',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your Order ID - ${widget.bookingid}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Thanks for your Order',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Your order has been placed successfully',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrackOrderScreen(),
                        ),
                        (route) {
                          // Check if the route's settings name is '/homebuy'
                          return route.settings.name == '/homebuy';
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Track Order',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'BACK TO HOME',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'People Also Bought This',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                itemCount: showingItems.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 25,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return ItemContainerWidget(
                    productId: showingItems[index].productId,
                    productName: showingItems[index].productName,
                    productPrice: showingItems[index].productPrice,
                    productImage: showingItems[index].productImagePath,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
