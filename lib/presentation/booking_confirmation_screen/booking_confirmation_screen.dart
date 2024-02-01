import 'package:customer_app/core/app_export.dart';
import 'package:customer_app/presentation/ServiceDetails/service_repair_screen.dart';
import 'package:customer_app/presentation/home_page_screen/home_page_screen.dart';
import 'package:customer_app/presentation/home_page_screen/widgets/homepagestaggered_item_widget.dart';
import 'package:customer_app/presentation/item_list/list.dart';
import 'package:customer_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:customer_app/widgets/app_bar/appbar_title.dart';
import 'package:customer_app/widgets/app_bar/appbar_trailing_image.dart';
import 'package:customer_app/widgets/app_bar/custom_app_bar.dart';
import 'package:customer_app/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray50,
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 24.h,
            vertical: 51.v,
          ),
          child: Column(
            children: [
              _buildBookingConfirmationFrame(context),
              SizedBox(height: 49.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recommended Services",
                  style: theme.textTheme.titleLarge,
                ),
              ),
              SizedBox(height: 30.v),
              _buildPage(context),
              Spacer(),
              SizedBox(height: 27.v),
              CustomElevatedButton(
                text: "Explore more services",
                buttonStyle: CustomButtonStyles.none,
                decoration: CustomButtonStyles
                    .gradientPrimaryToOnErrorContainerDecoration,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePageScreen(),
                    ),
                    (Route<dynamic> route) =>
                        false, // Removes all routes from the stack
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 68.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgFrame5140245,
        margin: EdgeInsets.only(
          left: 26.h,
          bottom: 6.v,
        ),
      ),
      title: AppbarTitle(
        text: "Booking Confirmation",
        margin: EdgeInsets.only(left: 7.h),
      ),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgGroup,
          margin: EdgeInsets.fromLTRB(32.h, 1.v, 32.h, 15.v),
        ),
      ],
      styleType: Style.bgGradientnameamber300nameamber600,
    );
  }

  /// Section Widget
  Widget _buildBookingConfirmationFrame(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 11.h),
      padding: EdgeInsets.symmetric(
        horizontal: 53.h,
        vertical: 29.v,
      ),
      decoration: AppDecoration.outlinePrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "We Have accepted Your Request, Thankyou for your Booking",
            textAlign: TextAlign.center,
            style: CustomTextStyles.titleMediumBlack900,
          ),
          SizedBox(height: 21.v),
          CustomImageView(
            imagePath: ImageConstant.imgImage42,
            height: 104.v,
            width: 103.h,
          ),
          SizedBox(height: 25.v),
          SizedBox(height: 22.v),
          SizedBox(
            width: 249.h,
            child: Text(
              "Our expert will get in touch with you soon",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: CustomTextStyles.bodyLargeGray700,
            ),
          ),
          SizedBox(height: 10.v),
        ],
      ),
    );
  }

  /// Section Widget
}

Widget _buildPage(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 24), // Adjusted padding
    child: StaggeredGridView.countBuilder(
      shrinkWrap: true,
      primary: false,
      crossAxisCount: 8,
      crossAxisSpacing: 16,
      mainAxisSpacing: 30,
      staggeredTileBuilder: (index) {
        return StaggeredTile.fit(2);
      },
      itemCount: confirmation.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> currentItem = confirmation[index];

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
    ),
  );
}
