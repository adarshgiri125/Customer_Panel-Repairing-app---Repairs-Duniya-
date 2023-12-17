import 'package:customer_app/core/app_export.dart';
import 'package:customer_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:customer_app/widgets/app_bar/appbar_title.dart';
import 'package:customer_app/widgets/app_bar/appbar_trailing_image.dart';
import 'package:customer_app/widgets/app_bar/custom_app_bar.dart';
import 'package:customer_app/widgets/custom_elevated_button.dart';
import 'package:customer_app/widgets/custom_floating_text_field.dart';
import 'package:customer_app/widgets/custom_outlined_button.dart';
import 'package:customer_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class SelectAddressScreen extends StatelessWidget {
  SelectAddressScreen({Key? key}) : super(key: key);

  TextEditingController enterHouseFlatNumberController =
      TextEditingController();

  TextEditingController enterStreetController = TextEditingController();

  TextEditingController floatingTextFieldController = TextEditingController();

  TextEditingController inputField3Controller = TextEditingController();

  TextEditingController inputField4Controller = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final List<bool> selectedItems =
        ModalRoute.of(context)!.settings.arguments as List<bool>;
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _buildAppBar(context),
            body: Form(
                key: _formKey,
                child: SizedBox(
                    width: double.maxFinite,
                    child: Column(children: [
                      _buildFrame(context),
                      SizedBox(height: 14.v),
                      _buildInputField1(context),
                      SizedBox(height: 8.v),
                      _buildInputField2(context),
                      SizedBox(height: 16.v),
                      _buildFrame2(context),
                      SizedBox(height: 23.v),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.only(left: 22.h),
                              child: Row(children: [
                                Container(
                                    height: 32.adaptSize,
                                    width: 32.adaptSize,
                                    decoration: BoxDecoration(
                                        color: theme.colorScheme.onError,
                                        borderRadius:
                                            BorderRadius.circular(10.h),
                                        border: Border.all(
                                            color: appTheme.gray900,
                                            width: 1.h))),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 11.h, top: 6.v, bottom: 3.v),
                                    child: Text("Urgent Booking",
                                        style:
                                            CustomTextStyles.bodyLargeGray700))
                              ]))),
                      SizedBox(height: 9.v),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.only(left: 22.h),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 14.v, bottom: 15.v),
                                        child: Text("Choose Date:",
                                            style: CustomTextStyles
                                                .bodyLargeGray700)),
                                    _buildButton1(context)
                                  ]))),
                      SizedBox(height: 20.v),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.only(left: 24.h),
                              child: Text("Choose Preferred time slot:",
                                  style: CustomTextStyles.bodyLargeGray700))),
                      SizedBox(height: 15.v),
                      _buildFrame3(context),
                      SizedBox(height: 5.v),
                      _buildFrame4(context),
                      SizedBox(height: 5.v)
                    ]))),
            bottomNavigationBar: _buildButton2(context)));
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: 68.h,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgFrame5140245,
            margin: EdgeInsets.only(left: 26.h, bottom: 6.v),
            onTap: () {
              onTapImage(context);
            }),
        title: AppbarTitle(
            text: "Select Address", margin: EdgeInsets.only(left: 7.h)),
        actions: [
          AppbarTrailingImage(
              imagePath: ImageConstant.imgGroup,
              margin: EdgeInsets.only(left: 37.h, right: 37.h, bottom: 18.v))
        ],
        styleType: Style.bgGradientnameamber300nameerrorContainer);
  }

  /// Section Widget
  Widget _buildUseMyCurrentLocation(BuildContext context) {
    return CustomOutlinedButton(
        text: "Use my current location",
        leftIcon: Container(
            margin: EdgeInsets.only(right: 8.h),
            child: CustomImageView(
                imagePath: ImageConstant.imgVector,
                height: 22.v,
                width: 20.h)));
  }

  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return SizedBox(
        height: 201.v,
        width: double.maxFinite,
        child: Stack(alignment: Alignment.bottomCenter, children: [
          CustomImageView(
              imagePath: ImageConstant.imgScreenshot116,
              height: 201.v,
              width: 430.h,
              alignment: Alignment.center),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 76.h, right: 76.h, bottom: 9.v),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    CustomImageView(
                        imagePath: ImageConstant.imgVector,
                        height: 31.v,
                        width: 28.h,
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 43.h)),
                    SizedBox(height: 78.v),
                    _buildUseMyCurrentLocation(context)
                  ])))
        ]));
  }

  /// Section Widget
  Widget _buildEnterHouseFlatNumber(BuildContext context) {
    return CustomTextFormField(
        controller: enterHouseFlatNumberController,
        hintText: "Enter your house/flat number",
        textInputType: TextInputType.number);
  }

  /// Section Widget
  Widget _buildInputField1(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("House/Flat Number",
              style: CustomTextStyles.bodyMediumGray700_1),
          SizedBox(height: 10.v),
          _buildEnterHouseFlatNumber(context)
        ]));
  }

  /// Section Widget
  Widget _buildEnterStreet(BuildContext context) {
    return CustomTextFormField(
        controller: enterStreetController, hintText: "Enter your street ");
  }

  /// Section Widget
  Widget _buildInputField2(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Sector/Street", style: CustomTextStyles.bodyMediumGray700_1),
          SizedBox(height: 10.v),
          _buildEnterStreet(context)
        ]));
  }

  /// Section Widget
  Widget _buildFloatingTextField(BuildContext context) {
    return CustomFloatingTextField(
        width: 121.h,
        controller: floatingTextFieldController,
        labelText: "City",
        labelStyle: theme.textTheme.bodyLarge!,
        hintText: "City");
  }

  /// Section Widget
  Widget _buildInputField3(BuildContext context) {
    return CustomTextFormField(
        width: 121.h, controller: inputField3Controller, hintText: "e.g Goa");
  }

  /// Section Widget
  Widget _buildInputField4(BuildContext context) {
    return CustomTextFormField(
        width: 121.h,
        controller: inputField4Controller,
        hintText: "Enter Pin",
        textInputAction: TextInputAction.done);
  }

  /// Section Widget
  Widget _buildFrame2(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 21.h),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _buildFloatingTextField(context),
          Padding(
              padding: EdgeInsets.only(left: 12.h),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("State", style: CustomTextStyles.bodyMediumGray700),
                    SizedBox(height: 1.v),
                    _buildInputField3(context)
                  ])),
          Padding(
              padding: EdgeInsets.only(left: 12.h),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Pincode", style: CustomTextStyles.bodyMediumGray700),
                    SizedBox(height: 1.v),
                    _buildInputField4(context)
                  ]))
        ]));
  }

  /// Section Widget
  Widget _buildButton1(BuildContext context) {
    return CustomOutlinedButton(
        height: 52.v,
        width: 165.h,
        text: "DD/MM/YYYY",
        margin: EdgeInsets.only(left: 21.h),
        buttonStyle: CustomButtonStyles.outlineBlueGray,
        buttonTextStyle: theme.textTheme.bodyLarge!);
  }

  /// Section Widget
  Widget _buildFrame3(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 23.h),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 121.h,
              padding: EdgeInsets.symmetric(horizontal: 27.h, vertical: 13.v),
              decoration: AppDecoration.outlineErrorContainer
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
              child: Text("Morning",
                  style: CustomTextStyles.bodyLargeErrorContainer)),
          Container(
              width: 121.h,
              margin: EdgeInsets.only(left: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 22.h, vertical: 14.v),
              decoration: AppDecoration.outlineErrorContainer
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
              child: Text("Afternoon",
                  style: CustomTextStyles.bodyLargeErrorContainer)),
          Container(
              width: 121.h,
              margin: EdgeInsets.only(left: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 13.v),
              decoration: AppDecoration.outlineErrorContainer
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
              child: Text("Evening",
                  style: CustomTextStyles.bodyLargeErrorContainer))
        ]));
  }

  /// Section Widget
  Widget _buildFrame4(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 43.h),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("8:00 am - 12:00 pm", style: theme.textTheme.bodySmall),
          Spacer(flex: 50),
          Text("12:00 pm - 5:00 pm", style: theme.textTheme.bodySmall),
          Spacer(flex: 49),
          Text("5:00 pm - 8:00 pm", style: theme.textTheme.bodySmall)
        ]));
  }

  /// Section Widget
  Widget _buildButton2(BuildContext context) {
    return CustomElevatedButton(
        text: "Confirm Booking",
        margin: EdgeInsets.only(left: 24.h, right: 24.h, bottom: 34.v));
  }

  /// Navigates to the homePageScreen when the action is triggered.
  onTapImage(BuildContext context) {
    Navigator.pop(context);
  }
}
