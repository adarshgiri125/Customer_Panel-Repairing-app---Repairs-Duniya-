import 'package:flutter/material.dart';
import 'package:customer_app/presentation/select_address_screen/select_address_screen.dart';
import 'package:customer_app/presentation/home_page_screen/home_page_screen.dart';
import 'package:customer_app/presentation/log_in_two_screen/log_in_two_screen.dart';
import 'package:customer_app/presentation/otp_one_screen/otp_one_screen.dart';


class AppRoutes {
  static const String selectAddressScreen = '/select_address_screen';

  static const String homePageScreen = '/home_page_screen';

  static const String logInTwoScreen = '/log_in_two_screen';

  static const String otpOneScreen = '/otp_one_screen';


  static Map<String, WidgetBuilder> routes = {
    selectAddressScreen: (context) => SelectAddressScreen(),
    homePageScreen: (context) => HomePageScreen(),
    logInTwoScreen: (context) =>LogInOneScreen(),
  };
}
