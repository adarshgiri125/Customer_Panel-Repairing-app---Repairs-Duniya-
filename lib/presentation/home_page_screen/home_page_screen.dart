import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_app/app%20state/app_state.dart';
import 'package:customer_app/app%20state/serviceDetails.dart';
import 'package:customer_app/presentation/Backened%20Part/Notification.dart';
import 'package:customer_app/presentation/Backened%20Part/getNotification.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/lists/itemcatalog.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20code/screens/home.dart';
import 'package:customer_app/presentation/customer_Rating/customer_rating.dart';
import 'package:customer_app/presentation/home_page_screen/getNumber.dart';
import 'package:customer_app/presentation/item_list/list.dart';
import 'package:customer_app/presentation/home_page_screen/widgets/viewhierarchy_Item_widget.dart';
import 'package:customer_app/presentation/location/location.dart';
import 'package:customer_app/presentation/ServiceDetails/service_repair_screen.dart';
import 'package:customer_app/presentation/log_in_two_screen/log_in_two_screen.dart';
import 'package:customer_app/presentation/searchService/DetailsPage.dart';
import 'package:customer_app/presentation/user%20profile/profile.dart';
import 'package:customer_app/toast/toast.dart';
import 'package:customer_app/widgets/app_bar/appbar_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../home_page_screen/widgets/homepagestaggered_item_widget.dart';
import 'package:customer_app/core/app_export.dart';
import 'package:customer_app/widgets/custom_elevated_button.dart';
import 'package:customer_app/widgets/custom_search_view.dart';
import 'package:customer_app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class HomePageScreen extends StatefulWidget {
  HomePageScreen({Key? key}) : super(key: key);

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  TextEditingController locationController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  late bool showHalfPage;

  late bool showLocation;
  late GoogleMapController mapController;
  LocationService locationService = LocationService();
  LatLng? currentLocation;
  User? _user;
  String userID = "";

  bool isLocationFetched = false;

  String userInput = "";

  @override
  void initState() {
    super.initState();
    showHalfPage = false;
    showLocation = false;
    // addItemExample();

    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;

        if (_user == null) {
          // User is not authenticated, navigate to login screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LogInOneScreen(),
            ),
          );
          return;
        }

        userID = user!.uid;
        _fetchUnratedServices(userID);
        PushNotificationSystem notificationSystem = PushNotificationSystem();
        notificationSystem.whenNotificationReceived(context);
        _getCurrentLocation();
      });
    });

    _initializePermission();
    setupDeviceToken();
  }

  void addItemExample() async {
    try {
      // Copy the asset to the local file system
      File imageFile = await getLocalFileFromAsset('assets/images/remote.jpg');
      String imageName = path.basename(imageFile.path);

      // Upload the image and get the URL
      String imageUrl = await uploadImage(imageFile, imageName);
      print("Image URL: $imageUrl");

      // Create the item model
      ItemsModel item = ItemsModel(
        productId: '2',
        productPrice: 150,
        productImagePath: imageUrl,
        productName: 'Remote',
        available: true,
      );

      // Add the item to Firestore
      await addItemToFirestore(item);
      print("Item added to Firestore");
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  Future<File> getLocalFileFromAsset(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final file = File(
        '${(await getTemporaryDirectory()).path}/${path.basename(assetPath)}');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  Future<String> uploadImage(File imageFile, String imageName) async {
    try {
      // Create a reference to the location you want to upload the file
      Reference ref =
          FirebaseStorage.instance.ref().child('ApplianceImages/$imageName');
      print("Starting upload for $imageName");

      // Upload the file
      UploadTask uploadTask = ref.putFile(imageFile);

      // Wait until the upload completes
      TaskSnapshot snapshot = await uploadTask;
      print("Upload complete for $imageName");

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Download URL: $downloadUrl");

      return downloadUrl;
    } catch (e) {
      print('Error occurred during upload: $e');
      rethrow;
    }
  }

  Future<void> addItemToFirestore(ItemsModel item) async {
    CollectionReference itemsCatalog =
        FirebaseFirestore.instance.collection('itemsCatalog');

    await itemsCatalog.add(item.toJson());
  }

  Future<void> _fetchUnratedServices(String user) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(user)
          .collection('serviceDetails')
          .where('workStatus', isEqualTo: 'Complete Working')
          .where('rating', isEqualTo: false)
          .limit(1) // Limit to only fetch the first unrated service
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot firstService = querySnapshot.docs.first;
        String technicianNumber = firstService['userPhoneNumber'];
        print("$technicianNumber");

        String technicianName = "not-available";
        String profilePictureUrl = "";
        String technicianUserId = "";

        FirebaseFirestore.instance
            .collection('technicians')
            .where('phone', isEqualTo: technicianNumber)
            .limit(1)
            .get()
            .then((techniciansSnapshot) {
          if (techniciansSnapshot.docs.isNotEmpty) {
            print("inside");
            technicianName = techniciansSnapshot.docs.first['technicianName'];
            technicianUserId = techniciansSnapshot.docs.first['userId'];
            profilePictureUrl = techniciansSnapshot.docs.first
                    .data()
                    .containsKey('technicianProfilePicture')
                ? techniciansSnapshot.docs.first['technicianProfilePicture']
                : "";
            print("${techniciansSnapshot.docs.first['technicianName']}");
            print("inside : $technicianName");
          }

          print("outside : $technicianName");

          String lastService = firstService[
              'serviceName']; // Replace with the actual field name in your document

          // Store the context outside the builder function
          BuildContext context = this.context;
          // https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500
          // Display the BottomRateButton, for example in a modal bottom sheet
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              final backgroundImage = profilePictureUrl != null &&
                      profilePictureUrl.isNotEmpty
                  ? NetworkImage(
                      profilePictureUrl) // Use the retrieved URL if available
                  : NetworkImage(
                      'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'); // Default image URL
              return SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: backgroundImage,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name : $technicianName',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Last Service: $lastService',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          // Add the cancel button
                          style: ElevatedButton.styleFrom(
                            elevation: 10, // Adjust the elevation as needed
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Adjust the border radius as needed
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            backgroundColor:
                                Colors.red, // Set the background color to red

                            // Set the background color to red
                          ),
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('customers')
                                .doc(_user!.uid)
                                .collection('serviceDetails')
                                .doc(firstService
                                    .id) // Assuming you have the Document ID of the service
                                .update({'rating': true});
                            Navigator.pop(
                                context); // Close the bottom sheet when cancel is pressed
                            // Close the bottom sheet when cancel is pressed
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.all(8), // Add padding to the text
                            child: Text(
                              'cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 10, // Adjust the elevation as needed
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Adjust the border radius as needed
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            backgroundColor:
                                Colors.green, // Add padding to the button
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            await FirebaseFirestore.instance
                                .collection('customers')
                                .doc(_user!.uid)
                                .collection('serviceDetails')
                                .doc(firstService
                                    .id) // Assuming you have the Document ID of the service
                                .update({'rating': true});

                            // Navigate to the rating screen and pass service details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerRatingScreen(
                                  technicianName: technicianName,
                                  lastService: lastService,
                                  serviceId: firstService.id,
                                  userId: technicianUserId,
                                  profilePictureUrl: profilePictureUrl,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.all(8), // Add padding to the text
                            child: Text(
                              'Give Rating',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),

                        // Add some space between the buttons
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
      } else {
        // No unrated services found
        print('No unrated services found.');
      }
    } catch (e) {
      print('Error fetching unrated service: $e');
      // Handle errors, e.g., show a snackbar or retry fetching
    }
  }

  Future<void> setupDeviceToken() async {
    String? token = await _messaging.getToken();
    _uploadToken(token!);
    _messaging.onTokenRefresh.listen(_uploadToken);
  }

  Future<void> _uploadToken(String token) async {
    try {
      await _firestore
          .collection('customers')
          .doc(_user!.uid)
          .set({'device_token': token}, SetOptions(merge: true));
    } catch (e) {}
  }

  Future<void> _initializePermission() async {
    String? phoneNumber = await getPhoneNumber(context);
    print("hey this is the number $phoneNumber");
    serviceDetails.userPhoneNumber = phoneNumber;
    bool isDenied = await Permission.notification.isDenied;
    if (isDenied) {
      print("Notification permission is denied. Requesting permission...");
      await Permission.notification.request();
      print("Notification permission requested.");
    } else {
      print("notification permission enabled");
    }
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
                  SizedBox(height: 8),
                  _buildHomePageStaggered(context),
                  SizedBox(height: 5),
                  _buildHomePageRow2(context),

                  SizedBox(height: 33),

                  // _buildHomePageRow(context),
                  SizedBox(height: 10),

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

  Widget _buildHomePageRow2(BuildContext context) {
    TextEditingController pincodeController = TextEditingController();

    Future<bool> validatePincode(String pincode) async {
      List<String> validPincodes = ['516001', '516002', '516003', '516004'];
      return validPincodes.contains(pincode);
    }

    void showPincodeDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter Your Area Code'),
            content: TextField(
              controller: pincodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter your pincode',
              ),
              style: TextStyle(
                  color: Colors.black), // Ensuring the input text is black
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  String enteredPincode = pincodeController.text;
                  bool isValid = await validatePincode(enteredPincode);
                  if (isValid) {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();
                    ToastService.sendAlert(
                      context: context,
                      message: "Not available in your location",
                      toastStatus: "ERROR",
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.h),
        decoration: AppDecoration.gradientOrangeAToErrorContainer.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20.h,
                top: 35.v,
                bottom: 20.v,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BUY APPLIANCES",
                    style: CustomTextStyles.titleLargeBold_1,
                  ),
                  SizedBox(height: 6.v),
                  SizedBox(
                    width: 174.h,
                    child: Text(
                      "BUY HOME APPLIANCES IN MINIMUM COST",
                      maxLines: 3,
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
                    text: "BUY NOW",
                    buttonStyle: CustomButtonStyles.none,
                    decoration: CustomButtonStyles
                        .gradientPrimaryToOnErrorContainerDecoration,
                    onPressed: showPincodeDialog,
                  ),
                ],
              ),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgImage52,
              height: 223.v,
              width: 195.h,
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
