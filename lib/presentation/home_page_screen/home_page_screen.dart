import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app%20state/app_state.dart';
import 'package:customer_app/app%20state/serviceDetails.dart';
import 'package:customer_app/presentation/Backened%20Part/Notification.dart';
import 'package:customer_app/presentation/Backened%20Part/getNotification.dart';
import 'package:customer_app/presentation/home_page_screen/getNumber.dart';
import 'package:customer_app/presentation/item_list/list.dart';
import 'package:customer_app/presentation/home_page_screen/widgets/viewhierarchy_Item_widget.dart';
import 'package:customer_app/presentation/location/location.dart';
import 'package:customer_app/presentation/ServiceDetails/service_repair_screen.dart';
import 'package:customer_app/presentation/searchService/DetailsPage.dart';
import 'package:customer_app/presentation/user%20profile/profile.dart';
import 'package:customer_app/widgets/app_bar/appbar_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
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
    _initializePermission();
    PushNotificationSystem notificationSystem = PushNotificationSystem();
    notificationSystem.whenNotificationReceived(context);
  }

  Future<void> _initializePermission() async {
    bool isDenied = await Permission.notification.isDenied;
    if (isDenied) {
      print("Notification permission is denied. Requesting permission...");
      await Permission.notification.request();
      print("Notification permission requested.");
    } else {
      print("notification permission enabled");
    }
    String? phoneNumber = await getPhoneNumber();
    serviceDetails.userPhoneNumber = phoneNumber;
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
          setState(() {
            serviceDetails.userLocation =
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
                  SizedBox(height: 10),
                  _buildHomePageStaggered(context),
                  SizedBox(height: 5),

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
                  // SizedBox(height: 30),
                  // ViewhierarchyItemWidget(),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationPage(
                                          notifications: [],
                                        )),
                              );
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
      margin: EdgeInsets.symmetric(
          horizontal: 24, vertical: 12), // Adjusted padding
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        primary: false,
        crossAxisCount: 8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 30,
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

  Widget _buildHomePageRow(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25.h),
        decoration: AppDecoration.gradientOrangeAToErrorContainer.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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

            // Added a small space between the text and the image
            CustomImageView(
              imagePath: ImageConstant.imgImage52,
              height: 223.v,
              width: 123.h,
              // margin: EdgeInsets.only(left: 2.h), // Removed the margin
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildHomePageStack1(BuildContext context) {
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
        itemCount: otheritems.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> currentItem = otheritems[index];

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
    // Combine items and otheritems into a single list
    List<Map<String, dynamic>> allItems = [...items, ...otheritems];

    // Filter the combined list based on the user input
    List<Map<String, dynamic>> filteredItems = allItems
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
