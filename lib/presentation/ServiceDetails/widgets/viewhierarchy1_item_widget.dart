import 'package:customer_app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Viewhierarchy1ItemWidget extends StatefulWidget {
  const Viewhierarchy1ItemWidget({Key? key}) : super(key: key);

  @override
  _Viewhierarchy1ItemWidgetState createState() =>
      _Viewhierarchy1ItemWidgetState();
}

class _Viewhierarchy1ItemWidgetState extends State<Viewhierarchy1ItemWidget> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0; // Set the initial page to 0

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
              PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgImage40,
                    height: 159.v,
                    width: 378.h,
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgImage38,
                    height: 159.v,
                    width: 378.h,
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgImage39,
                    height: 159.v,
                    width: 378.h,
                  ),
                ],
              ),
              Positioned(
                bottom: 10.v,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 3, // Adjust the count based on the number of images
                    effect: ScrollingDotsEffect(
                      activeDotColor: Color.fromARGB(18, 3, 3, 255),
                      dotHeight: 12.v,
                    ),
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
