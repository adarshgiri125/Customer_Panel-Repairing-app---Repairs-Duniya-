import 'dart:async';
import 'package:customer_app/app%20state/app_state.dart';
import 'package:customer_app/core/app_export.dart';
import 'package:customer_app/presentation/booking_confirmation_screen/booking_confirmation_screen.dart';
import 'package:customer_app/widgets/app_bar/appbar_leading_image.dart';
import 'package:customer_app/widgets/app_bar/appbar_title.dart';
import 'package:customer_app/widgets/app_bar/appbar_trailing_image.dart';
import 'package:customer_app/widgets/app_bar/custom_app_bar.dart';
import 'package:customer_app/widgets/custom_checkbox_button.dart';
import 'package:customer_app/widgets/custom_elevated_button.dart';
import 'package:customer_app/widgets/custom_outlined_button.dart';
import 'package:customer_app/widgets/custom_search_view.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class SelectAddressScreen extends StatefulWidget {
  SelectAddressScreen({Key? key}) : super(key: key);

  @override
  _SelectAddressScreenState createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  TextEditingController floatingTextFieldController = TextEditingController();
  String address = "";
  bool showAdditionalContent = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  DateTime? selectedDate;
  LatLng _initialCameraPosition =
      AppState.currentLocation ?? LatLng(12.9716, 77.5946);

  bool isChecked = false;
  String? selectedReason;
  String? userDescription;
  String? previousDescription;
  final TextEditingController descriptionController = TextEditingController();

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
                    // Additional content when checkbox is checked
                    // You can customize this part based on your requirements
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
                            SizedBox(height: 5.v),
                            Text(
                              "Additional charge of Rs.80/- after service completion",
                              style: CustomTextStyles.bodyLargeGray700.copyWith(
                                fontSize: 14.0,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(height: 5.v),
                            // Add DropdownButton or any other input widgets
                            // for selecting the reason
                            Center(
                              child: DropdownButton<String>(
                                hint: Text(
                                  selectedReason ??
                                      "Select Reason for urgent booking",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                items: [
                                  "Reason 1",
                                  "Reason 2",
                                  "Reason is Not listed",
                                  "Select Reason for urgent booking",
                                  // Add more options as needed
                                ].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Center(
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedReason = value;
                                  });
                                  // Handle the selected value
                                },
                              ),
                            ),
                            SizedBox(height: 5.v),
                            // Add Description with text field
                            GestureDetector(
                              onTap: () {
                                _openDescriptionDialog();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Add Description",
                                    style: CustomTextStyles.bodyLargeGray700
                                        .copyWith(
                                      fontSize: 14.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.v),
                            // Display the user's description
                            if (userDescription != null &&
                                userDescription!.isNotEmpty)
                              Text(
                                "Your Reason: $userDescription",
                                style:
                                    CustomTextStyles.bodyLargeGray700.copyWith(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                              ),
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

  void _openDescriptionDialog() async {
    String? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Description"),
          content: TextField(
            controller: descriptionController,
            decoration:
                InputDecoration(hintText: "Write your problem (max 40 words)"),
            maxLength: 90,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // Cancel
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(descriptionController.text); // OK
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        userDescription = result;
        previousDescription = result;
      });
    } else {
      // User canceled, clear the previous description
      setState(() {
        userDescription = previousDescription;
      });
    }
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
        final GoogleMapController controller = await _mapController.future;
        controller.animateCamera(CameraUpdate.newLatLng(
          AppState.currentLocation ?? LatLng(0.0, 0.0),
        ));
      },
    );
  }

  Widget _buildFrame(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          CustomSearchView(
            controller: floatingTextFieldController,
            hintText: "Search other Location",
            onChanged: (value) {
              // Update the text of the controller
              floatingTextFieldController.text = value;
            },
            onSubmitted: (value) {
              _updateMapWithSearch(value);
            },
            autofocus: false,
          ),
          SizedBox(
            height: 400.v,
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
                  onCameraMove: (CameraPosition position) {},
                  onCameraIdle: () async {
                    final GoogleMapController controller =
                        await _mapController.future;
                    _updateCameraPosition(controller);
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

  void _updateCameraPosition(GoogleMapController controller) async {
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
    }

    AppState.userLocation = newPosition;
    AppState.address = address;
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
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
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
    bool isLocationSelected = AppState.userLocation != null;
    bool isDateSelected = selectedDate != null;
    bool isTimeSelected = selectedTimeIndex != -1;
    bool isReasonSelected = isChecked ? selectedReason != null : true;

    bool isButtonEnabled = isLocationSelected &&
        ((isChecked && isReasonSelected) ||
            (!isChecked && isDateSelected && isTimeSelected));

    return CustomElevatedButton(
      text: isButtonEnabled
          ? "Confirm Booking"
          : "Please fill all required fields",
      margin: EdgeInsets.only(left: 24.h, right: 24.h, bottom: 34.v),
      buttonStyle: isButtonEnabled
          ? const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.black))
          : const ButtonStyle(),
      onPressed: isButtonEnabled
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookingConfirmationScreen()),
              );
            }
          : null,
    );
  }

  onTapImage(BuildContext context) {
    Navigator.pop(context);
  }
}
