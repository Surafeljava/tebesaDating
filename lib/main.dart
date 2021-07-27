import 'package:dating/Screens/Home/wrapper.dart';
import 'package:dating/Screens/authenticate/AuthState.dart';
import 'package:dating/Screens/home/mainScroll/datesState.dart';
import 'package:dating/Screens/home/mainScroll/mainHomeState.dart';
import 'package:dating/Screens/home/mainScroll/matchState.dart';
import 'package:dating/Screens/registration/RegistrationState.dart';
import 'package:dating/Screens/registration/registration.dart';
import 'package:dating/Screens/registration/registrationDataState.dart';
import 'package:dating/Services/authService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
          create: (context) => AuthService().user,
          initialData: null,
        ),
        ChangeNotifierProvider(
          create: (context) => Registration(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthState(),
        ),
        ChangeNotifierProvider(
          create: (context) => RegistrationState(),
        ),
        ChangeNotifierProvider(
          create: (context) => RegistrationDataState(),
        ),
        ChangeNotifierProvider(
          create: (context) => MainHomeState(),
        ),
        ChangeNotifierProvider(
          create: (context) => DatesState(),
        ),
        ChangeNotifierProvider(
          create: (context) => MatchState(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.pink,
          ),
          home: Wrapper()),
    );
  }
}
