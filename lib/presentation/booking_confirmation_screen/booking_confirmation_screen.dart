import 'package:customer_app/core/app_export.dart';
import 'package:customer_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:customer_app/widgets/app_bar/appbar_title.dart';
import 'package:customer_app/widgets/app_bar/appbar_trailing_image.dart';
import 'package:customer_app/widgets/app_bar/custom_app_bar.dart';
import 'package:customer_app/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

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
              _buildSpaRow(context),
              Spacer(),
              SizedBox(height: 27.v),
              CustomElevatedButton(
                text: "Explore more services",
                buttonStyle: CustomButtonStyles.none,
                decoration: CustomButtonStyles
                    .gradientPrimaryToOnErrorContainerDecoration,
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
            "Your Booking is Confirmed!",
            style: CustomTextStyles.titleLargeGray700,
          ),
          SizedBox(height: 21.v),
          CustomImageView(
            imagePath: ImageConstant.imgImage42,
            height: 104.v,
            width: 103.h,
          ),
          SizedBox(height: 25.v),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Booking ID:",
                  style: CustomTextStyles.bodyLargeOpenSansGray700,
                ),
                TextSpan(
                  text: " ",
                ),
                TextSpan(
                  text: "BL00967",
                  style: CustomTextStyles.titleMediumBlack900,
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 22.v),
          SizedBox(
            width: 249.h,
            child: Text(
              "An assigned technician will reach your address in 1 hour",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyLargeGray700,
            ),
          ),
          SizedBox(height: 10.v),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSpaRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 8.h),
            child: Column(
              children: [
                Container(
                  height: 83.adaptSize,
                  width: 83.adaptSize,
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.h,
                    vertical: 16.v,
                  ),
                  decoration: AppDecoration.outlinePrimary.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder7,
                  ),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgImage41,
                    height: 48.v,
                    width: 69.h,
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(height: 1.v),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 27.h),
                    child: Text(
                      "Spa",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            child: Column(
              children: [
                Container(
                  height: 83.adaptSize,
                  width: 83.adaptSize,
                  padding: EdgeInsets.all(2.h),
                  decoration: AppDecoration.outlinePrimary.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder7,
                  ),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgImage40,
                    height: 76.adaptSize,
                    width: 76.adaptSize,
                    alignment: Alignment.center,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 18.h),
                    child: Text(
                      "Salon",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            child: Column(
              children: [
                Container(
                  height: 83.adaptSize,
                  width: 83.adaptSize,
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.h,
                    vertical: 15.v,
                  ),
                  decoration: AppDecoration.outlinePrimary.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder7,
                  ),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgImage62,
                    height: 50.v,
                    width: 80.h,
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(height: 1.v),
                Text(
                  "Painting",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 8.h),
            child: Column(
              children: [
                Container(
                  height: 83.adaptSize,
                  width: 83.adaptSize,
                  padding: EdgeInsets.symmetric(
                    horizontal: 21.h,
                    vertical: 37.v,
                  ),
                  decoration: AppDecoration.outlinePrimary.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder7,
                  ),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgFrame5140235,
                    height: 6.v,
                    width: 39.h,
                    alignment: Alignment.center,
                  ),
                ),
                Text(
                  "More",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
