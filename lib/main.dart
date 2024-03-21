import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_messenger/Signup.dart';
import 'package:whatsapp_messenger/firebase_options.dart';
import 'package:whatsapp_messenger/page1.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
 Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.contacts.request();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
//Remove this method to stop OneSignal Debugging 
OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

OneSignal.initialize("c41ac4b7-944e-42b4-9071-4abe12bf2fca");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
OneSignal.Notifications.requestPermission(true);
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp',
      home: const Signup(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/page1', page: () => const Page1()),
      ],
    );
  }
}
