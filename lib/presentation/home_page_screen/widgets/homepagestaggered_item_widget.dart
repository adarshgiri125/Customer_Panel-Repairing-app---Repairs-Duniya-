import 'package:customer_app/core/app_export.dart';
import 'package:flutter/material.dart';

class HomepagestaggeredItemWidget extends StatelessWidget {
  final String imagePath;
  final String itemName;

  const HomepagestaggeredItemWidget({
    Key? key,
    required this.imagePath,
    required this.itemName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            height: 80.v, // Adjust the height to display the image properly
            width: 80.h, // Adjust the width to display the image properly
            padding: EdgeInsets.symmetric(
              horizontal: 10.h,
              vertical: 10.v, // Adjust the vertical padding as needed
            ),
            decoration: AppDecoration.outlineBlueGray.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder7,
            ),
            child: CustomImageView(
              imagePath: imagePath,
              height: 120.v, // Adjust the height of the image
              width: 120.h, // Adjust the width of the image
              fit: BoxFit.contain, // Ensure the image fits within the container
              alignment: Alignment.center,
            ),
          ),
          SizedBox(height: 8.v), // Add some space between the image and text
          Text(
            itemName,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
