import 'dart:async';
import 'package:customer_app/app%20state/serviceDetails.dart';
import 'package:customer_app/core/app_export.dart';
import 'package:customer_app/presentation/Backened%20Part/sendNotification.dart';
import 'package:customer_app/presentation/booking_confirmation_screen/booking_confirmation_screen.dart';
import 'package:customer_app/presentation/select_address_screen/SearchPage.dart';
import 'package:customer_app/presentation/select_address_screen/sendData_Firebase.dart';
import 'package:customer_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:customer_app/widgets/app_bar/appbar_title.dart';
import 'package:customer_app/widgets/app_bar/appbar_trailing_image.dart';
import 'package:customer_app/widgets/app_bar/custom_app_bar.dart';
import 'package:customer_app/widgets/custom_checkbox_button.dart';
import 'package:customer_app/widgets/custom_elevated_button.dart';
import 'package:customer_app/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class SelectAddressScreen extends StatefulWidget {
  SelectAddressScreen({Key? key}) : super(key: key);

  @override
  _SelectAddressScreenState createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  TextEditingController floatingTextFieldController = TextEditingController();
  String address = "";
  bool showAdditionalContent = false;
  late String pincode = "";

  final List<String> codes = [
    // kadapa
    '516001',
    '516002',
    '516003',
    '516004',

    //Banglore
    '560076',
    '560102',
    '560068',
    '560066',
    '560100',

    //Delhi
    '110030',
    '110029',
    '110052',
    '110070',
    '110020',

    //Hyderabad
    '500033',
    '500004',
    '500035',
    '500002',

    //Mumbai
    '400054',
    '400053',
    '400058',
    '400069',
  ];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  DateTime? selectedDate;
  LatLng _initialCameraPosition =
      serviceDetails.userLocation ?? LatLng(12.9716, 77.5946);

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  _buildFrame(context),
                  SizedBox(height: 23.v),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 7.0),
                      ),
                      CustomCheckboxButton(
                        value: isChecked,
                        onChange: (newValue) {
                          setState(() {
                            isChecked = newValue;
                            showAdditionalContent = newValue;
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.0),
                        child: Text(
                          "Urgent Booking",
                          style: CustomTextStyles.bodyLargeGray700.copyWith(
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 9.v),
                  if (showAdditionalContent) ...[
                    SizedBox(height: 10.v),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 22.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Technician reaches your doorstep within 1 hour from successful booking completion",
                              style: CustomTextStyles.bodyLargeGray700.copyWith(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 15.v),
                            Text(
                              "Additional charge of Rs.80/- after service completion",
                              style: CustomTextStyles.bodyLargeGray700.copyWith(
                                fontSize: 14.0,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 5.v),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 22.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 14.v, bottom: 15.v),
                              child: Text(
                                "Choose Date:",
                                style: CustomTextStyles.bodyLargeGray700,
                              ),
                            ),
                            _buildButton1(context),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.v),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24.h),
                        child: Text(
                          "Choose Preferred time slot:",
                          style: CustomTextStyles.bodyLargeGray700,
                        ),
                      ),
                    ),
                    SizedBox(height: 15.v),
                    _buildFrame3(context),
                    SizedBox(height: 5.v),
                    _buildFrame4(context),
                    SizedBox(height: 5.v),
                  ],
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: _buildButton2(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 68.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgFrame5140245,
        margin: EdgeInsets.only(left: 26.h, bottom: 6.v),
        onTap: () {
          onTapImage(context);
        },
      ),
      title: AppbarTitle(
        text: "Select Address",
        margin: EdgeInsets.only(left: 7.h),
      ),
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgGroup,
          margin: EdgeInsets.only(left: 37.h, right: 37.h, bottom: 18.v),
        )
      ],
      styleType: Style.bgGradientnameamber300nameerrorContainer,
    );
  }

  Widget _buildUseMyCurrentLocation(BuildContext context) {
    return CustomOutlinedButton(
      text: "Use my current location",
      leftIcon: Container(
        margin: EdgeInsets.only(right: 8.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgVector,
          height: 22.v,
          width: 20.h,
        ),
      ),
      textStyle: TextStyle(
        color: Colors.black,
      ),
      onPressed: () async {
        // Check if the user has granted location permission
        var status = await Permission.location.status;

        if (status == PermissionStatus.granted) {
          // User has granted location permission, proceed to get the current location
          await _getCurrentLocation();
        } else if (status == PermissionStatus.denied) {
          // Location permission is denied, show a dialog with an option to open app settings
          showLocationPermissionDialog(context);
        } else {
          // User has not yet been asked for permission, request it
          await Permission.location.request();
        }
      },
    );
  }

  void showLocationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Permission"),
          content: Text("Turn on the location permission"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // Open app settings
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "Open Settings",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude,
          position.longitude))); // Move camera to current location

      await _updateMarkerPosition(
          LatLng(position.latitude, position.longitude));

      // Fetch address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.isNotEmpty ? placemarks[0] : Placemark();

      address =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";

      if (address != null) {
        floatingTextFieldController.text = address;
      } else {
        floatingTextFieldController.text = "choose correct location";
      }

      serviceDetails.userLocation =
          LatLng(position.latitude, position.longitude);
      serviceDetails.address = address;
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  bool shouldUpdateCameraPosition = true;

  Widget _buildFrame(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          TextField(
            onTap: () async {
              final searchValue = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );

              if (searchValue != null && searchValue.isNotEmpty) {
                setState(() {
                  address = searchValue;
                });
                _updateMapWithSearch(searchValue);
              }
            },
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Ping your Location',
              suffixIcon: Icon(Icons.search),
              // Set the text color here
              labelStyle: TextStyle(color: Colors.black),
              // Set the cursor color
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: TextStyle(
                color: Colors.black), // Set the text color of the entered text
            controller: TextEditingController(text: address),
          ),
          SizedBox(
            height: 325.v,
            width: double.maxFinite,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: _initialCameraPosition,
                    zoom: 16.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                    _updateCameraPosition(controller);
                  },
                  markers: _createMarkers(),
                  onCameraMove: (CameraPosition position) {
                    setState(() {
                      _initialCameraPosition = position.target;
                    });
                  },
                  onCameraIdle: () async {
                    final GoogleMapController controller =
                        await _mapController.future;
                    _updateCameraPosition(controller);
                  },
                  onTap: (LatLng tappedPoint) {
                    _updateMarkerPosition(tappedPoint);
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 76.h, right: 76.h, bottom: 9.v),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildUseMyCurrentLocation(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateCameraPosition(GoogleMapController controller) async {
    LatLngBounds visibleRegion = await controller.getVisibleRegion();
    LatLng center = LatLng(
      (visibleRegion.southwest.latitude + visibleRegion.northeast.latitude) / 2,
      (visibleRegion.southwest.longitude + visibleRegion.northeast.longitude) /
          2,
    );

    setState(() {
      _initialCameraPosition = center;
    });
    await _updateMarkerPosition(center);
  }

  Future<void> _updateMapWithSearch(String searchInput) async {
    if (searchInput.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(searchInput);

        if (locations.isNotEmpty) {
          Location location = locations[0];
          final GoogleMapController controller = await _mapController.future;
          double zoomLevel = 18.0;

          controller.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(location.latitude!, location.longitude!),
            zoomLevel,
          ));
        } else {
          print("No locations found for the entered address");
        }
      } catch (e) {
        print("Error during geocoding: $e");
      }
    } else {
      print("Search input is empty");
    }
  }

  void _performSearch() {
    String searchInput = floatingTextFieldController.text;
    if (searchInput.isNotEmpty) {
      _updateMapWithSearch(searchInput);
    }
  }

  Set<Marker> _createMarkers() {
    return <Marker>{
      Marker(
        markerId: MarkerId("currentLocation"),
        position: _initialCameraPosition,
        draggable: true,
        onDragEnd: (LatLng newPosition) {
          _updateMarkerPosition(newPosition);
        },
      ),
    };
  }

  Future<void> _updateMarkerPosition(LatLng newPosition) async {
    try {
      setState(() {
        _initialCameraPosition = newPosition;
      });

      List<Placemark> placemarks = await placemarkFromCoordinates(
        newPosition.latitude,
        newPosition.longitude,
      );

      Placemark place = placemarks.isNotEmpty ? placemarks[0] : Placemark();

      address =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";

      if (address != null) {
        floatingTextFieldController.text = address;
      } else {
        floatingTextFieldController.text = "choose correct location";
      }

      serviceDetails.userLocation = newPosition;
      serviceDetails.address = address;
    } catch (e) {
      // Handle the exception, for example, print the error message
      print("Error in _updateMarkerPosition: $e");
      // You can also throw the exception again if you want to propagate it further
      throw e;
    }
  }

  Widget _buildButton1(BuildContext context) {
    return CustomOutlinedButton(
      height: 52.v,
      width: 165.h,
      text: selectedDate != null
          ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
          : "DD/MM/YYYY",
      margin: EdgeInsets.only(left: 21.h),
      buttonStyle: selectedDate != null
          ? CustomButtonStyles.outlinePrimaryTL5
          : CustomButtonStyles.outlineBlueGray,
      buttonTextStyle: TextStyle(
        fontSize: 16.0,
        color: selectedDate != null ? Colors.black : Colors.blue,
      ),
      onPressed: () {
        _selectDate(context);
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime lastSelectableDate = currentDate.add(Duration(days: 3));

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: lastSelectableDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black, // OK button text color
            hintColor: Color.fromARGB(255, 4, 169, 228), // Selection color
            colorScheme: ColorScheme.light(primary: Colors.black),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
      // textButtonStyle: TextButton.styleFrom(
      //   primary: Colors.black, // CANCEL button text color
      // ),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        print(selectedDate);
      });
    }
  }

  Widget _buildFrame3(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 23.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimeOption("Morning", 0, context),
          _buildTimeOption("Afternoon", 1, context),
          _buildTimeOption("Evening", 2, context),
        ],
      ),
    );
  }

  int selectedTimeIndex = -1;
  Widget _buildTimeOption(String time, int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTimeIndex = index;
          print("Selected time: $time");
        });
      },
      child: Container(
        width: 110.h,
        margin: EdgeInsets.only(left: 10.h),
        padding: EdgeInsets.symmetric(vertical: 19.v),
        decoration: BoxDecoration(
          color: selectedTimeIndex == index ? Colors.black : Colors.transparent,
          borderRadius: BorderRadiusStyle.roundedBorder10,
          border: Border.all(
            color: selectedTimeIndex == index ? Colors.black : Colors.blue,
            width: 2.h,
          ),
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              fontSize: 14.0,
              color: selectedTimeIndex == index ? Colors.white : Colors.blue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrame4(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 43.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("8:00 am - 12:00 pm", style: theme.textTheme.bodySmall),
          Spacer(flex: 50),
          Text("12:00 pm - 5:00 pm", style: theme.textTheme.bodySmall),
          Spacer(flex: 49),
          Text("5:00 pm - 8:00 pm", style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildButton2(BuildContext context) {
    bool isLocationSelected = serviceDetails.userLocation != null;
    bool isDateSelected = selectedDate != null;
    bool isTimeSelected = selectedTimeIndex != -1;
    bool isReasonSelected = isChecked;

    bool isButtonEnabled = isLocationSelected &&
        ((isChecked && isReasonSelected) ||
            (!isChecked && isDateSelected && isTimeSelected));

    bool isLoading = false;

    return Stack(
      children: [
        CustomElevatedButton(
          text: isButtonEnabled
              ? "Confirm Booking"
              : "Please fill all required fields",
          margin: EdgeInsets.only(left: 24.h, right: 24.h, bottom: 34.v),
          buttonStyle: isButtonEnabled
              ? const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.black))
              : const ButtonStyle(),
          onPressed: isButtonEnabled
              ? () async {
                  setState(() {
                    isLoading = true;
                  });
                  bool isServiceable = await checkServiceability(address);
                  print("pincode : $pincode");
                  if (pincode == '516001' ||
                      pincode == '516002' ||
                      pincode == '516003' ||
                      pincode == '516004') {
                    serviceDetails.city = "KADAPA";
                  }

                  if (pincode == '500033' ||
                      pincode == '500004' ||
                      pincode == '500035' ||
                      pincode == '500002') {
                    serviceDetails.city = "HYDERABAD";
                  }

                  if (pincode == '560076' ||
                      pincode == '560102' ||
                      pincode == '560068' ||
                      pincode == '560066' ||
                      pincode == '560100') {
                    serviceDetails.city = "BANGLORE";
                  }
                  if (pincode == '110030' ||
                      pincode == '110029' ||
                      pincode == '110052' ||
                      pincode == '110070' ||
                      pincode == '110020') {
                    serviceDetails.city = "DELHI";
                  }
                  if (pincode == '400054' ||
                      pincode == '400053' ||
                      pincode == '400058' ||
                      pincode == '400069') {
                    serviceDetails.city = "MUMBAI";
                  }
                  print("city : ${serviceDetails.city}");
                  serviceDetails.address = address;
                  serviceDetails.serviceDate = selectedDate;
                  serviceDetails.timeIndex = selectedTimeIndex;
                  serviceDetails.userLocation = serviceDetails.userLocation;
                  serviceDetails.userPhoneNumber =
                      serviceDetails.userPhoneNumber;
                  serviceDetails.urgentBooking = isChecked;

                  if (isServiceable && codes.contains(pincode)) {
                    String documentName =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    DateTime time = DateTime.now();
                    deleteOldServiceDetails();
                    await storeServiceDetails(documentName, time);

                    sendNotificationsToNearbyTechnicians(
                        serviceName!,
                        serviceDetails.userLocation!.latitude,
                        serviceDetails.userLocation!.longitude,
                        documentName);

                    // await Future.delayed(Duration(seconds: 5));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingConfirmationScreen(),
                      ),
                    );
                  } else {
                    // Address is not serviceable, show a message to the user
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Not Serviceable"),
                          content:
                              Text("We are not serviceable at this location."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Colors.black, // Set the background color
                              ),
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  color: Colors.white, // Set the text color
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  setState(() {
                    isLoading = false;
                  });
                }
              : null,
        ),
        if (isLoading)
          Positioned.fill(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
      ],
    );
  }

  onTapImage(BuildContext context) {
    Navigator.pop(context);
  }

  Future<bool> checkServiceability(String address) async {
    // Extract pincode from the address
    pincode = await getPincodeFromAddress(address);

    // Check if the pincode is in the list of serviceable codes
    return codes.contains(pincode);
  }

  Future<String> getPincodeFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations[0];
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        if (placemarks.isNotEmpty) {
          return placemarks[0].postalCode ?? "";
        }
      }
    } catch (e) {
      print("Error getting pincode: $e");
    }
    return "";
  }
}
