import 'package:customer_app/presentation/repair_service/service_repair_screen.dart';

import '../home_page_screen/widgets/homepagestaggered_item_widget.dart';
import 'package:customer_app/core/app_export.dart';
import 'package:customer_app/widgets/custom_elevated_button.dart';
import 'package:customer_app/widgets/custom_search_view.dart';
import 'package:customer_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePageScreen extends StatelessWidget {
  HomePageScreen({Key? key}) : super(key: key);

  TextEditingController locationController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 165.v), // Placeholder for non-scrollable widget
                  Padding(
                    padding: EdgeInsets.only(left: 24.h),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "What’s Broken?",
                            style: CustomTextStyles.titleLargeBold,
                          ),
                          TextSpan(
                            text: " (Select Appliance)",
                            style: CustomTextStyles.titleLargeRegular_1,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 3.v),
                  _buildHomePageStaggered(context),
                  SizedBox(height: 1.v),
                  Container(
                    height: 83.adaptSize,
                    width: 83.adaptSize,
                    margin: EdgeInsets.only(left: 24.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 21.h,
                      vertical: 37.v,
                    ),
                    decoration: AppDecoration.outlineBlueGray.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder7,
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgFrame5140235,
                      height: 6.v,
                      width: 39.h,
                      alignment: Alignment.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 48.h),
                    child: Text(
                      "More",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 28.v),
                  _buildHomePageRow(context),
                  SizedBox(height: 33.v),
                  Padding(
                    padding: EdgeInsets.only(left: 24.h),
                    child: Text(
                      "Other Services",
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(height: 11.v),
                  _buildHomePageStack1(context),
                  SizedBox(height: 79.v),
                  _buildHomePageColumn(context),
                  SizedBox(height: 25.v),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildHomePageStack(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHomePageStack(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              decoration: AppDecoration.gradientAmberToErrorContainer,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 3.h,
                      right: 13.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgMenu,
                          height: 21.v,
                          width: 27.h,
                          margin: EdgeInsets.only(top: 6.v),
                        ),
                        Spacer(
                          flex: 86,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgGroup,
                          height: 24.adaptSize,
                          width: 24.adaptSize,
                        ),
                        Spacer(
                          flex: 13,
                        ),
                        CustomImageView(
                          imagePath: ImageConstant.imgGroup5139931,
                          height: 25.v,
                          width: 24.h,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.v),
                  CustomTextFormField(
                    controller: locationController,
                    hintText: "Pick Your Location",
                    hintStyle: CustomTextStyles.bodyMediumGray40002,
                    prefix: Container(
                      margin: EdgeInsets.fromLTRB(19.h, 9.v, 8.h, 9.v),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgVector,
                        height: 22.v,
                        width: 20.h,
                      ),
                    ),
                    prefixConstraints: BoxConstraints(
                      maxHeight: 40.v,
                    ),
                    suffix: Container(
                      margin: EdgeInsets.fromLTRB(30.h, 6.v, 12.h, 6.v),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgDownChevron,
                        height: 28.v,
                        width: 24.h,
                      ),
                    ),
                    suffixConstraints: BoxConstraints(
                      maxHeight: 40.v,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.v),
                  ),
                  SizedBox(height: 8.v),
                  CustomSearchView(
                    controller: searchController,
                    hintText: "Search an appliance or service",
                  ),
                  SizedBox(height: 12.v),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildHomePageStaggered(BuildContext context) {
    // Define a list of items with their respective image paths and names
    List<Map<String, dynamic>> items = [
      {"imagePath": ImageConstant.imgImage38, "itemName": "AC"},
      {"imagePath": ImageConstant.imgImage39, "itemName": "Lamp"},
      {"imagePath": ImageConstant.imgImage36, "itemName": "Fan"},
      {"imagePath": ImageConstant.imgImage34, "itemName": "Freeze"},
      {"imagePath": ImageConstant.imgImage33, "itemName": "Television"},
      {"imagePath": ImageConstant.imgImage32, "itemName": "Oven"},
      {"imagePath": ImageConstant.imgImage29, "itemName": "Microwave"},
      {"imagePath": ImageConstant.imgImage31, "itemName": "Washing Machine"},
      // Add more items as needed
    ];

    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      primary: false,
      crossAxisCount: 8,
      crossAxisSpacing: 16.h,
      mainAxisSpacing: 16.h,
      staggeredTileBuilder: (index) {
        return StaggeredTile.fit(2);
      },
      itemCount: items.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> currentItem = items[index];

        return GestureDetector(
          onTap: () {
            // Navigate to the AcServiceRepairScreen and pass the data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AcServiceRepairScreen(
                  imagePath: currentItem["imagePath"],
                  itemName: currentItem["itemName"],
                ),
              ),
            );
          },
          child: HomepagestaggeredItemWidget(
            imagePath: currentItem["imagePath"],
            itemName: currentItem["itemName"],
          ),
        );
      },
    );
  }

  /// Section Widget
  Widget _buildHomePageRow(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25.h),
        decoration: AppDecoration.gradientOrangeAToErrorContainer.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 17.h,
                top: 35.v,
                bottom: 20.v,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Control Your Device",
                    style: CustomTextStyles.titleLargeBold_1,
                  ),
                  SizedBox(height: 6.v),
                  SizedBox(
                    width: 174.h,
                    child: Text(
                      "Control your devices easily with the push of a button.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.bodyMediumGray50.copyWith(
                        height: 1.50,
                      ),
                    ),
                  ),
                  SizedBox(height: 37.v),
                  CustomElevatedButton(
                    height: 44.v,
                    width: 156.h,
                    text: "Get Started",
                    buttonStyle: CustomButtonStyles.none,
                    decoration: CustomButtonStyles
                        .gradientPrimaryToOnErrorContainerDecoration,
                  ),
                ],
              ),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgImage52,
              height: 215.v,
              width: 162.h,
              margin: EdgeInsets.only(left: 2.h),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHomePageStack1(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 104.v,
        width: 382.h,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 23.h,
                  bottom: 1.v,
                ),
                child: Text(
                  "More",
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 32.h),
                child: Text(
                  "Spa",
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 114.h),
                child: Text(
                  "Painting",
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 129.h,
                  bottom: 1.v,
                ),
                child: Text(
                  "Salon",
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 21.v),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 83.adaptSize,
                      width: 83.adaptSize,
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.h,
                        vertical: 16.v,
                      ),
                      decoration: AppDecoration.outlineBlueGray.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder7,
                      ),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgImage41,
                        height: 48.v,
                        width: 69.h,
                        alignment: Alignment.center,
                      ),
                    ),
                    Container(
                      height: 83.adaptSize,
                      width: 83.adaptSize,
                      padding: EdgeInsets.all(2.h),
                      decoration: AppDecoration.outlineBlueGray.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder7,
                      ),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgImage40,
                        height: 76.adaptSize,
                        width: 76.adaptSize,
                        alignment: Alignment.center,
                      ),
                    ),
                    Container(
                      height: 83.adaptSize,
                      width: 83.adaptSize,
                      padding: EdgeInsets.symmetric(
                        horizontal: 1.h,
                        vertical: 15.v,
                      ),
                      decoration: AppDecoration.outlineBlueGray.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder7,
                      ),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgImage62,
                        height: 50.v,
                        width: 80.h,
                        alignment: Alignment.center,
                      ),
                    ),
                    Container(
                      height: 83.adaptSize,
                      width: 83.adaptSize,
                      padding: EdgeInsets.symmetric(
                        horizontal: 21.h,
                        vertical: 37.v,
                      ),
                      decoration: AppDecoration.outlineBlueGray.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder7,
                      ),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgFrame5140235,
                        height: 6.v,
                        width: 39.h,
                        alignment: Alignment.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHomePageColumn(BuildContext context) {
    bool shouldShowExtraWidgets =
        true; // Set this condition based on your requirements

    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25.h),
        height: 130,
        decoration: AppDecoration.gradientOnPrimaryContainerToOnError.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder7,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadiusStyle.roundedBorder7,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 350.v,
                    width: 378.h,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgImage49,
                          height: 350.v,
                          width: 378.h,
                          alignment: Alignment.center,
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 60.h,
                              top: 18.v,
                              right: 60.h,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Rs. 500",
                                        style: CustomTextStyles
                                            .bodyMediumOtomanopeeOneOnPrimary,
                                      ),
                                      TextSpan(
                                        text: "  Free Gift Voucher",
                                        style: CustomTextStyles
                                            .bodyMediumOtomanopeeOne,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                CustomImageView(
                                  imagePath: ImageConstant.imgImage47,
                                  height: 61.v,
                                  width: 73.h,
                                ),
                                SizedBox(height: 5.v),
                                Text(
                                  "Order a Service and stand a chance to win a gift voucher",
                                  style: CustomTextStyles
                                      .bodySmallAvenirNextLTProPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (shouldShowExtraWidgets)
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              margin: EdgeInsets.only(top: 129.v),
                              padding: EdgeInsets.symmetric(
                                horizontal: 170.h,
                                vertical: 9.v,
                              ),
                              decoration: AppDecoration.fillOnError.copyWith(
                                borderRadius:
                                    BorderRadiusStyle.customBorderBL10,
                              ),
                              child: CustomImageView(
                                imagePath: ImageConstant.imgFrame5140267,
                                height: 12.v,
                                width: 37.h,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (shouldShowExtraWidgets)
                    CustomImageView(
                      imagePath: ImageConstant.imgImage50,
                      height: 350.v,
                      width: 378.h,
                      margin: EdgeInsets.only(left: 22.h),
                    ),
                  if (shouldShowExtraWidgets)
                    CustomImageView(
                      imagePath: ImageConstant.imgImage51,
                      height: 350.v,
                      width: 378.h,
                      margin: EdgeInsets.only(left: 22.h),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
