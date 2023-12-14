import 'package:customer_app/presentation/home_page_screen/home_page_screen.dart';
import 'package:customer_app/presentation/log_in_two_screen/log_in_two_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:customer_app/theme/theme_helper.dart';
import 'package:customer_app/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp();

  ///Please update theme as per your need if required.
  ThemeHelper().changeTheme('primary');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      title: 'customer_app',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: checkLoginStatus(), // Check login status asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Return the appropriate screen based on the login status
            return snapshot.data == true ? HomePageScreen() : LogInOneScreen();
          } else {
            // Return a loading indicator or splash screen while checking login status
            return CircularProgressIndicator();
          }
        },
      ),
      routes: AppRoutes.routes,
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('user_token');
    String? expirationDateString = prefs.getString('expiration_date');

    if (token != null && expirationDateString != null) {
      DateTime expirationDate = DateTime.parse(expirationDateString);

      if (DateTime.now().isBefore(expirationDate)) {
        // Token is still valid, return true
        return true;
      }
    }

    // Token is not valid or not present, return false
    return false;
  }
}
