// ignore_for_file: file_names

import 'package:customer_app/presentation/Buy%20Appliance%20model/provider/addressProvider.dart';
import 'package:customer_app/presentation/Buy%20Appliance/screens/SavedAddressScreen.dart';
import 'package:customer_app/presentation/Buy%20Appliance/widgets/commonTextField.dart';
import 'package:customer_app/presentation/Buy%20Appliance/widgets/containers/containerButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final postalCodeController = TextEditingController();
  final addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<bool> isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Repairs Duniya Enterprises'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.line_weight_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextForm(
                    controller: nameController,
                    hintText: 'Full Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonTextForm(
                    controller: phoneController,
                    hintText: 'Phone',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonTextForm(
                    controller: postalCodeController,
                    hintText: 'Postal Code',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your postal code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonTextForm(
                    controller: addressController,
                    hintText: 'Address',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CommonTextForm(
                    controller: emailController,
                    hintText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(
                              r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Save Address Type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ToggleButtons(
                    isSelected: isSelected,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                        }
                      });
                    },
                    borderColor: Colors.grey,
                    selectedBorderColor: Colors.black,
                    selectedColor: Colors.black,
                    fillColor: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5.0),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Home'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Office'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Others'),
                      ),
                    ],
                  ),
                ],
              ),

              // In this container button developer has to the details to Firebase.
              //I just take random using provider just for the testing purpose

              ContainerButton(
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Get the selected address type
                    String addressType = isSelected[0]
                        ? 'Home'
                        : isSelected[1]
                            ? 'Office'
                            : 'Others';

                    // Save address data using Provider
                    Provider.of<AddressProvider>(context, listen: false)
                        .saveAddress(
                      address: addressController.text,
                      name: nameController.text,
                      phoneNumber: phoneController.text,
                      emailAddress: emailController.text,
                      postal: postalCodeController.text,
                      type: addressType,
                    );

                    // Navigate to the saved address screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SavedAddressScreen()),
                    );
                  }
                },
                text: 'SAVE & PROCEED',
                fontWeight: FontWeight.bold,
                textColor: Colors.white,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
