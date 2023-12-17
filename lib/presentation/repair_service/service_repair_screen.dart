import 'package:customer_app/core/app_export.dart';
import 'package:customer_app/presentation/repair_service/widgets/list_item_widget.dart';
import 'package:customer_app/presentation/repair_service/widgets/viewhierarchy1_item_widget.dart';
import 'package:customer_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:customer_app/widgets/app_bar/appbar_title.dart';
import 'package:customer_app/widgets/app_bar/appbar_trailing_image.dart';
import 'package:customer_app/widgets/app_bar/custom_app_bar.dart';
import 'package:customer_app/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AcServiceRepairScreen extends StatelessWidget {
  final String imagePath;
  final String itemName;

  AcServiceRepairScreen({required this.imagePath, required this.itemName});

  int sliderIndex = 1;
  List<bool> selectedItems = []; // Declare selectedItems here

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 15.v),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 20.h, right: 24.h, bottom: 5.v),
                  child: Column(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgImage38126x382,
                        height: 126.v,
                        width: 382.h,
                      ),
                      SizedBox(height: 3.v),
                      _buildSlider(context),
                      SizedBox(height: 52.v),
                      _buildList(context),
                      SizedBox(height: 20.v),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 64.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgFrame5140245,
        margin: EdgeInsets.only(left: 22.h, bottom: 6.v),
        onTap: () {
          onTapImage(context);
        },
      ),
      title: AppbarTitle(
        text: "AC Service/Repair",
        margin: EdgeInsets.only(left: 9.h),
      ),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgGroup,
          margin: EdgeInsets.only(left: 37.h, right: 37.h, bottom: 18.v),
        ),
      ],
      styleType: Style.bgGradientnameamber300nameerrorContainer,
    );
  }

  Widget _buildSlider(BuildContext context) {
    return SizedBox(
      height: 159.v,
      width: 378.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              height: 159.v,
              initialPage: 0,
              autoPlay: true,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                sliderIndex = index;
              },
            ),
            itemCount: 1,
            itemBuilder: (context, index, realIndex) {
              return Viewhierarchy1ItemWidget();
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 12.v,
              margin: EdgeInsets.only(bottom: 9.v),
              child: AnimatedSmoothIndicator(
                activeIndex: sliderIndex,
                count: 1,
                axisDirection: Axis.horizontal,
                effect: ScrollingDotsEffect(
                  spacing: 4.5,
                  activeDotColor: theme.colorScheme.errorContainer,
                  dotColor: appTheme.blueGray10002,
                  activeDotScale: 1.5,
                  dotHeight: 8.v,
                  dotWidth: 8.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 2.h, top: 17.v, right: 3.h),
        child: SizedBox(
          width: double.infinity,
          child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 8.v);
            },
            itemCount: 1, // Adjust the itemCount as needed
            itemBuilder: (context, index) {
              return ListItemWidget(
                onSelectionChanged: (selected) {
                  selectedItems = selected;
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(20.h),
        child: CustomElevatedButton(
          text: "Proceed",
          onPressed: () {
            // Proceed to the next screen with the selected services
            Navigator.pushNamed(
              context,
              AppRoutes.selectAddressScreen,
              arguments: selectedItems,
            );
          },
          buttonStyle: CustomButtonStyles.none,
          decoration: CustomButtonStyles
              .gradientPrimaryToOnErrorContainerTL16Decoration,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  onTapImage(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.homePageScreen);
  }
}
