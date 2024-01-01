import 'package:customer_app/app%20state/app_state.dart';
import 'package:customer_app/presentation/item_list/list.dart';
import 'package:customer_app/presentation/home_page_screen/widgets/viewhierarchy_Item_widget.dart';
import 'package:customer_app/presentation/location/location.dart';
import 'package:customer_app/presentation/repair_service/service_repair_screen.dart';
import 'package:customer_app/presentation/searchService/DetailsPage.dart';
import 'package:customer_app/presentation/user%20profile/profile.dart';
import 'package:customer_app/widgets/app_bar/appbar_menu.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../home_page_screen/widgets/homepagestaggered_item_widget.dart';
import 'package:customer_app/core/app_export.dart';
import 'package:customer_app/widgets/custom_elevated_button.dart';
import 'package:customer_app/widgets/custom_search_view.dart';
import 'package:customer_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  TextEditingController locationController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  late bool showHalfPage;

  late bool showLocation;
  late GoogleMapController mapController;
  LocationService locationService = LocationService();
  LatLng? currentLocation;

  bool isLocationFetched = false;

  String userInput = "";

  @override
  void initState() {
    super.initState();
    showHalfPage = false;
    showLocation = false;
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationData? locationData = await locationService.getCurrentLocation();
    if (locationData != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          locationData.latitude!,
          locationData.longitude!,
        );

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          String address =
              "${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}";

          setState(() {
            AppState.currentLocation =
                LatLng(locationData.latitude!, locationData.longitude!);
            // locationController.text = address;
            isLocationFetched = true;
          });
        }
      } catch (e) {
        print("Error fetching address: $e");
      }
    }
  }

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
                    height: 130,
                  ), // Placeholder for non-scrollable widget
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24), // Adjusted padding
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
                  SizedBox(height: 6),
                  _buildHomePageStaggered(context),
                  SizedBox(height: 0),
                  Container(
                    height: 75,
                    width: 75,
                    margin: EdgeInsets.symmetric(
                        horizontal: 24), // Adjusted padding
                    padding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                    decoration: AppDecoration.outlineBlueGray.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder7,
                    ),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgFrame5140235,
                      height: 7,
                      width: 42,
                      alignment: Alignment.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24), // Adjusted padding
                    child: Text(
                      "More",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(height: 28),
                  _buildHomePageRow(context),
                  SizedBox(height: 33),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24), // Adjusted padding
                    child: Text(
                      "Other Services",
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(height: 11),
                  _buildHomePageStack1(context),
                  SizedBox(height: 79),
                  ViewhierarchyItemWidget(),
                  SizedBox(height: 25),
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
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: AppDecoration.gradientAmberToErrorContainer,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 3,
                        right: 13,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle the tap event for this image
                              if (showHalfPage) {
                                _hideHalfPage(context);
                              } else {
                                _showHalfPage(context);
                              }
                            },
                            child: CustomImageView(
                              imagePath: showHalfPage
                                  ? ImageConstant
                                      .imgDelete // New image when HalfPage is visible
                                  : ImageConstant.imgMenu,
                              height: 21,
                              width: 27,
                              margin: EdgeInsets.only(top: 6),
                            ),
                          ),
                          Spacer(
                            flex: 86,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()),
                              );
                            },
                            child: CustomImageView(
                              imagePath: ImageConstant.imgGroup,
                              height: 24,
                              width: 24,
                            ),
                          ),
                          Spacer(
                            flex: 13,
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle the tap event for this image
                            },
                            child: CustomImageView(
                              imagePath: ImageConstant.imgGroup5139931,
                              height: 25,
                              width: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14),
                    // CustomTextFormField(
                    //   controller: locationController,
                    //   hintText: "Pick Your Location",
                    //   hintStyle: CustomTextStyles.bodyMediumGray40002,
                    //   prefix: Container(
                    //     margin: EdgeInsets.fromLTRB(19, 9, 8, 9),
                    //     child: CustomImageView(
                    //       imagePath: ImageConstant.imgVector,
                    //       height: 22,
                    //       width: 20,
                    //     ),
                    //   ),
                    //   prefixConstraints: BoxConstraints(
                    //     maxHeight: 40,
                    //   ),
                    //   suffix: Container(
                    //     margin: EdgeInsets.fromLTRB(30, 6, 12, 6),
                    //     child: CustomImageView(
                    //       imagePath: ImageConstant.imgDownChevron,
                    //       height: 28,
                    //       width: 24,
                    //     ),
                    //   ),
                    //   suffixConstraints: BoxConstraints(
                    //     maxHeight: 40,
                    //   ),
                    //   contentPadding: EdgeInsets.symmetric(vertical: 10),
                    //   onChanged: (value) {},
                    //   readOnly: isLocationFetched,
                    // ),
                    SizedBox(height: 8),

                    CustomSearchView(
                      controller: searchController,
                      hintText: "Search an appliance or service",
                      onChanged: (value) {
                        setState(() {
                          userInput = value;
                        });
                      },
                      onSubmitted: (value) {
                        _showDetailsPage(value);
                      },
                      autofocus: false,
                    ),

                    SizedBox(height: 12),
                  ],
                ),
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

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24), // Adjusted padding
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        primary: false,
        crossAxisCount: 8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
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
      ),
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
                    text: "Coming soon",
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

  void _showHalfPage(BuildContext context) {
  Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (context, animation, secondaryAnimation) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, -1.0),
          end: Offset.zero,
        ).animate(animation),
        child: HalfPage(
          onClose: () {
            // Callback function to be invoked when the half page is closed
            _hideHalfPage(context);
          },
        ),
      );
    },
  ));
}

  void _hideHalfPage(BuildContext context) {
    // Use Navigator.pop(context) to remove the topmost route
    Navigator.pop(context);
    // Update the state or perform other actions as needed
    setState(() {
      showHalfPage = false;
    });
  }

  void _showDetailsPage(String itemName) {
    // Filter the items based on the user input
    List<Map<String, dynamic>> filteredItems = items
        .where((item) =>
            item["itemName"].toLowerCase().contains(userInput.toLowerCase()))
        .toList();

    // Navigate to a new page and pass the filtered items
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(filteredItems),
      ),
    );
  }
}
