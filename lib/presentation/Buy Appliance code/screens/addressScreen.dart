import 'package:customer_app/presentation/Buy%20Appliance%20code/screens/SavedAddressScreen.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20code/widgets/commonTextField.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20code/widgets/containers/containerButton.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/provider/addressProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItemsDetails;

  const AddressScreen({Key? key, required this.cartItemsDetails})
      : super(key: key);

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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
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

              // Save & Proceed Button
              ContainerButton(
                onTap: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    String addressType = isSelected[0]
                        ? 'Home'
                        : isSelected[1]
                            ? 'Office'
                            : 'Others';

                    Map<String, dynamic> userDetails = {
                      'name': nameController.text,
                      'phone': phoneController.text,
                      'email': emailController.text,
                      'postalCode': postalCodeController.text,
                      'address': addressController.text,
                      'addressType': addressType,
                    };

                    Provider.of<AddressProvider>(context, listen: false)
                        .saveAddress(
                      address: addressController.text,
                      name: nameController.text,
                      phoneNumber: phoneController.text,
                      emailAddress: emailController.text,
                      postal: postalCodeController.text,
                      type: addressType,
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SavedAddressScreen(
                          cartItemsDetails: widget.cartItemsDetails,
                          userDetails: userDetails,
                        ),
                      ),
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
