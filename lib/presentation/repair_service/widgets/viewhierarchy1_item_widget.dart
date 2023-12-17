import 'package:customer_app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// ignore: must_be_immutable
class Viewhierarchy1ItemWidget extends StatelessWidget {
  const Viewhierarchy1ItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusStyle.roundedBorder7,
        ),
        child: Container(
          height: 159.v,
          width: 378.h,
          decoration:
              AppDecoration.gradientOnPrimaryContainerToOnError.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder7,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgImage49,
                height: 159.v,
                width: 378.h,
                alignment: Alignment.center,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 159.v,
                  width: 378.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
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
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 129.v),
                              padding: EdgeInsets.symmetric(
                                horizontal: 170.h,
                                vertical: 9.v,
                              ),
                              decoration: AppDecoration.fillOnError.copyWith(
                                borderRadius:
                                    BorderRadiusStyle.customBorderBL10,
                              ),
                              child: SizedBox(
                                height: 12.v,
                                child: AnimatedSmoothIndicator(
                                  activeIndex: 0,
                                  count: 2,
                                  effect: ScrollingDotsEffect(
                                    activeDotColor: Color(0X1212121D),
                                    dotHeight: 12.v,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            CustomImageView(
                              imagePath: ImageConstant.imgImage50,
                              height: 159.v,
                              width: 1.h,
                              margin: EdgeInsets.only(left: 22.h),
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgImage51,
                              height: 159.v,
                              width: 1.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
