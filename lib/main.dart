
import 'package:customer_app/presentation/Buy%20Appliance%20code/screens/home.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/provider/addressProvider.dart';
import 'package:customer_app/presentation/Buy%20Appliance%20model/provider/cartProvider.dart';
import 'package:customer_app/presentation/home_page_screen/home_page_screen.dart';
import 'package:customer_app/presentation/log_in_two_screen/log_in_two_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:customer_app/theme/theme_helper.dart';
import 'package:customer_app/routes/app_routes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  // Please update theme as per your need if required.
  ThemeHelper().changeTheme('primary');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddressProvider(),
        ),
      ],
      child: MaterialApp(
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
  routes: {
   
    '/homebuy': (context) => HomeScreen(),
    // Add more routes as needed
  },
    ));
  
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
