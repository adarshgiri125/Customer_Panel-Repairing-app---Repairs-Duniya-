import 'package:customer_app/core/utils/image_constant.dart';
import 'package:customer_app/theme/app_decoration.dart';
import 'package:customer_app/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ViewhierarchyItemWidget extends StatefulWidget {
  const ViewhierarchyItemWidget({Key? key}) : super(key: key);

  @override
  _ViewhierarchyItemWidgetState createState() =>
      _ViewhierarchyItemWidgetState();
}

class _ViewhierarchyItemWidgetState extends State<ViewhierarchyItemWidget> {
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
          height: 159,
          width: 378,
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
                    imagePath: ImageConstant.imgFrame5140235,
                    height: 159,
                    width: 378,
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgFrame5140245,
                    height: 159,
                    width: 378,
                  ),
                  CustomImageView(
                    imagePath: ImageConstant.imgFrame5140267,
                    height: 159,
                    width: 378,
                  ),
                ],
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 3, // Adjust the count based on the number of images
                    effect: ScrollingDotsEffect(
                      activeDotColor: Color.fromARGB(18, 3, 3, 255),
                      dotHeight: 12,
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
