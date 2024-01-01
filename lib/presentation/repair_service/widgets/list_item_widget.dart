import 'package:customer_app/core/app_export.dart';
import 'package:flutter/material.dart';

class ListItemWidget extends StatefulWidget {
  final String itemName; // Add itemName property
  final List<dynamic> items;
  final Null Function(dynamic selected) onSelectionChanged;

  const ListItemWidget({
    Key? key,
    required this.itemName, // Add this line
    required this.items,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _ListItemWidgetState createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  late List<bool> isCircleBlankList; // Declare isCircleBlankList as late

  @override
  void initState() {
    super.initState();
    // Initialize isCircleBlankList based on the details fetched dynamically
    isCircleBlankList = fetchDetails(widget.itemName);
  }

  List<bool> fetchDetails(String itemName) {
    // Use the appropriate list based on the itemName
    if (itemName == 'AC') {
      return List.generate(widget.items.length, (index) => true);
    } else if (itemName == 'Lamp') {
      return List.generate(widget.items.length, (index) => true);
    } else if (itemName == 'Fan') {
      return List.generate(widget.items.length, (index) => true);
    } else if (itemName == 'Freeze') {
      return List.generate(widget.items.length, (index) => true);
    } else if (itemName == 'Television') {
      return List.generate(widget.items.length, (index) => true);
    } else if (itemName == 'Oven') {
      return List.generate(widget.items.length, (index) => true);
    } else if (itemName == 'Microwave') {
      return List.generate(widget.items.length, (index) => true);
    } else if (itemName == 'Washing Machine') {
      return List.generate(widget.items.length, (index) => true);
    }
    // Add more conditions for other itemNames if needed

    // Default return if the itemName is not recognized
    return [];
  }

  String getItemTitle(int index) {
    // Use the appropriate list based on the itemName
    if (widget.itemName == 'AC') {
      return widget.items[index]['title'];
    } else if (widget.itemName == 'Lamp') {
      // Change 'Lamp' to 'lamp'
      return widget.items[index]['title'];
    } else if (widget.itemName == 'Fan') {
      return widget.items[index]['title'];
    } else if (widget.itemName == 'Freeze') {
      return widget.items[index]['title'];
    } else if (widget.itemName == 'Television') {
      return widget.items[index]['title'];
    } else if (widget.itemName == 'Oven') {
      return widget.items[index]['title'];
    } else if (widget.itemName == 'Microwave') {
      return widget.items[index]['title'];
    } else if (widget.itemName == 'Washing Machine') {
      return widget.items[index]['title'];
    }
    // Add more conditions for other itemNames if needed

    // Default return if the itemName is not recognized
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: List.generate(
          isCircleBlankList.length,
          (index) => buildItem(index),
        ),
      ),
    );
  }

  Widget buildItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCircleBlankList[index] = !isCircleBlankList[index];
          widget.onSelectionChanged(isCircleBlankList);
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.h,
              vertical: 15.v, // Adjusted vertical padding
            ),
            decoration: AppDecoration.outlineBluegray10001.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 136.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(1.h),
                        decoration: AppDecoration.outlineGray.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder10,
                        ),
                        child: Container(
                          height: 15.adaptSize,
                          width: 15.adaptSize,
                          decoration: BoxDecoration(
                            color: isCircleBlankList[index]
                                ? Colors.white
                                : theme.colorScheme.primary.withOpacity(1),
                            borderRadius: BorderRadius.circular(9.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.h), // Adjusted spacing
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Center text vertically
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getItemTitle(index),
                              style: CustomTextStyles.bodyLargeBluegray700
                                  .copyWith(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.select_all, // Provide a default icon for each item
                  size: 24, // Adjust the size as needed
                  color: Colors.black, // Adjust the color as needed
                ),
              ],
            ),
          ),
          SizedBox(height: 10.v), // Add spacing between items
        ],
      ),
    );
  }
}
