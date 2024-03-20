import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_mobile/components/navbar.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'pages/login.dart';
import 'pages/workzone.dart';
import 'pages/workzone_timer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainPageProvider()),
        ChangeNotifierProvider(
          create: (context) => TimerStepperProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      // initialRoute: '/',
      // routes: {
      //   Navbar.roueName: (context) => const Navbar(),
      // },
    );
  }
}
