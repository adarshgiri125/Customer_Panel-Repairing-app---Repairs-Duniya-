
import 'package:customer_app/presentation/Buy%20Appliance%20code/widgets/ListContainer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Buy Appliance model/lists/itemcatalog.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({Key? key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final TextEditingController searchController = TextEditingController();
  late List<ItemsModel> filteredItems =
      []; // Initialize filteredItems as an empty list

  @override
  void initState() {
    super.initState();
    fetchItems(); // Fetch items when the screen initializes
  }

  Future<void> fetchItems() async {
    // Fetch items from Firestore collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('itemsCatalog').get();
    setState(() {
      // Update filteredItems with items fetched from Firestore
      filteredItems = querySnapshot.docs
          .map((doc) => ItemsModel.fromFirestore(doc))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Products'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  // Filter items based on search query
                  setState(() {
                    filteredItems = filteredItems
                        .where((item) => item.productName
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
              const SizedBox(
                height: 30,
              ),
              GridView.builder(
                itemCount: filteredItems.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 25,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return ItemContainerWidget(
                    productId: filteredItems[index].productId,
                    productName: filteredItems[index].productName,
                    productPrice: filteredItems[index].productPrice,
                    productImage: filteredItems[index].productImagePath,
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
