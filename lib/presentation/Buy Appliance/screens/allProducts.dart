// ignore_for_file: file_names

import 'package:customer_app/presentation/Buy%20Appliance%20model/class/itemModel.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/lists/ItemsCatelog.dart';
import 'package:customer_app/presentation/Buy%20Appliance/widgets/ListContainer.dart';
import 'package:customer_app/presentation/Buy%20Appliance/widgets/appBar.dart';
import 'package:customer_app/presentation/Buy%20Appliance/widgets/commonTextField.dart';
import 'package:flutter/material.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final TextEditingController searchController = TextEditingController();
  List<ItemsModel> filteredItems = [];

  @override
  void initState() {
    filteredItems =
        allItemsCatalog; // Initialize filteredItems with allItemsCatalog
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniversalAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              CommonTextForm(
                controller: searchController,
                hintText: 'Search',
                icon: Icons.search,
                onChanged: (p0) {
                  setState(() {
                    // Filter items whose name contains the search query
                    filteredItems = allItemsCatalog
                        .where((item) => item.productName
                            .toLowerCase()
                            .contains(p0.toLowerCase()))
                        .toList();
                  });
                  return null;
                }, // Call filterItems when text changes
              ),
              const SizedBox(
                height: 30,
              ),
              GridView.builder(
                itemCount: filteredItems
                    .length, // Use filteredItems instead of allItemsCatalog
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
                    productId:
                        filteredItems[index].productId, // Pass the productId
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
