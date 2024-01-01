import 'package:customer_app/core/utils/image_constant.dart';
import 'package:customer_app/presentation/repair_service/service_repair_screen.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final List<Map<String, dynamic>> filteredItems;

  DetailsPage(this.filteredItems);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services'),
      ),
      body: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(filteredItems[index]["itemName"]),
            // You can customize the ListTile as needed
            onTap: () {
              // Navigate to a detailed view or perform other actions
              _navigateToDetailPage(context, filteredItems[index]);
            },
          );
        },
      ),
    );
  }

  void _navigateToDetailPage(BuildContext context, Map<String, dynamic> item) {
    // Access the "itemName" and "imagePath" from the selected item
    String itemName = item["itemName"];
    String imagePath = item["imagePath"];

    // Navigate to the detailed page with the selected item's details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcServiceRepairScreen(
          imagePath: imagePath,
          itemName: itemName,
        ),
      ),
    );
  }
}
