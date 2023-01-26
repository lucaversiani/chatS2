import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/presenter/core/authorization_controller.dart';
import 'package:get/get.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

import 'app/presenter/core/initial_bindings.dart';
import 'app/presenter/core/user_controller.dart';
import 'app/presenter/routes/my_pages.dart';
import 'app/presenter/routes/my_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBApIMaHGSi2UI4oqvrZIqMtljdwJ661SM",
        authDomain: "chatgpt-ed4c7.firebaseapp.com",
        projectId: "chatgpt-ed4c7",
        storageBucket: "chatgpt-ed4c7.appspot.com",
        messagingSenderId: "759693049422",
        appId: "1:759693049422:web:56a2c5c084687973e40d1f",
        measurementId: "G-GBJQZ8HSZ8"),
  );

  InitialBinding().dependencies();

  Get.find<FirebaseFirestore>().settings =
      const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  await Get.find<FirebaseAuth>().setPersistence(Persistence.LOCAL);

  if (Get.find<FirebaseAuth>().currentUser != null &&
      Get.find<UserController>().user.value.id == null) {
    await Get.find<UserController>().waitForUser();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionConfig = SessionConfig(
        invalidateSessionForAppLostFocus: const Duration(minutes: 15),
        invalidateSessionForUserInactiviity: const Duration(minutes: 15));

    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        if (FirebaseAuth.instance.currentUser != null) {
          Get.find<AuthorizationController>().signOut();
        }
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        if (FirebaseAuth.instance.currentUser != null) {
          Get.find<AuthorizationController>().signOut();
        }
      }
    });

    return SessionTimeoutManager(
      sessionConfig: sessionConfig,
      child: GetMaterialApp(
        defaultTransition: Transition.noTransition,
        transitionDuration: const Duration(milliseconds: 1000),
        debugShowCheckedModeBanner: false,
        title: 'ChatS2',
        theme: ThemeData(
            fontFamily: 'Trueno',
            toggleableActiveColor: Colors.grey.shade600,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
                .copyWith(
                    secondary: Colors.grey.shade600,
                    brightness: Brightness.dark)),
        getPages: AppPages.pages,
        initialRoute: Routes.ROOT,
      ),
    );
  }
}
