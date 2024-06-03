// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

class AddressProvider extends ChangeNotifier {
  String? fullName;
  String? phone;
  String? email;
  String? postalCode;
  String? address;
  String? addressType;

  void saveAddress({
    required String name,
    required String phoneNumber,
    required String emailAddress,
    required String postal,
    required String address,
    required String type,
  }) {
    fullName = name;
    phone = phoneNumber;
    email = emailAddress;
    postalCode = postal;
    this.address = address;
    addressType = type;
    notifyListeners();
  }
}
