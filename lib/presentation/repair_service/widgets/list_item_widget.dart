import 'package:customer_app/core/app_export.dart';
import 'package:flutter/material.dart';

class ListItemWidget extends StatefulWidget {
  const ListItemWidget({Key? key, required Null Function(dynamic selected) onSelectionChanged}) : super(key: key);

  @override
  _ListItemWidgetState createState() => _ListItemWidgetState();
  
  void onSelectionChanged(List<bool> isCircleBlankList) {}
}

class _ListItemWidgetState extends State<ListItemWidget> {
  List<bool> isCircleBlankList = [true, true, true, true, true, true];
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      buildItem("AC Servicing", ImageConstant.imgImage53, 0),
      buildItem("AC Cooling Issue", ImageConstant.imgImage54, 1),
      buildItem("AC not turning on", ImageConstant.imgImage55, 2),
      buildItem("Bad smell from AC", ImageConstant.imgImage56, 3),
      buildItem("Bad smell from AC", ImageConstant.imgImage56, 4),
      buildItem("Bad smell from AC", ImageConstant.imgImage56, 5),
    ];

    return Align(
      alignment: Alignment.center,
      child: Column(children: items),
    );
  }

  Widget buildItem(String title, String imagePath, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCircleBlankList[index] = !isCircleBlankList[index];
          widget.onSelectionChanged(isCircleBlankList);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.h,
          vertical: 7.v,
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
                  Padding(
                    padding: EdgeInsets.only(left: 8.h),
                    child: Text(
                      title,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
            CustomImageView(
              imagePath: imagePath,
              height: 88.v,
              width: 124.h,
            ),
          ],
        ),
      ),
    );
  }
}
