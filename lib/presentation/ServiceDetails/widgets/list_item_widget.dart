import 'package:customer_app/core/app_export.dart';
import 'package:flutter/material.dart';

class ListItemWidget extends StatefulWidget {
  final String itemName; // Add itemName property
  final List<dynamic> items;
  final void Function(List<String> selected) onSelectionChanged;

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
  late List<bool> isCircleBlankList;

  @override
  void initState() {
    super.initState();
    isCircleBlankList = List.generate(widget.items.length, (index) => false);
  }

  String getItemTitle(int index) {
    return widget.items[index]['title'];
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
          // Clear selection for all items
          isCircleBlankList =
              List.generate(widget.items.length, (index) => false);

          // Set the selected item
          isCircleBlankList[index] = true;

          // Use the widget.onSelectionChanged to update the selectedItems
          widget.onSelectionChanged(
            isCircleBlankList
                .asMap()
                .entries
                .where((entry) => entry.value)
                .map((entry) => getItemTitle(entry.key))
                .toList(),
          );
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.h,
              vertical: 15.v,
            ),
            decoration: AppDecoration.outlineErrorContainer.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 215.h,
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
                                ? theme.colorScheme.primary.withOpacity(1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(9.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.h),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                // Icon(
                //   Icons.select_all,
                //   size: 24,
                //   color: Colors.black,
                // ),
              ],
            ),
          ),
          SizedBox(height: 20.v),
        ],
      ),
    );
  }
}
