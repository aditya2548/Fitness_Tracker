import 'package:Fitness_Tracker/screens/home_screen.dart';

import './models/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/signup_screen.dart';

import 'screens/login_screen.dart';
import './screens/welcome_screen.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //  multiprovider with several childs change notifier for changes in
    //  ->  ProdutsProvider(list of products)
    //  -> CartProvider (list of cart-items)

    return MultiProvider(
      providers: [
        Provider<AuthProvider>(
          create: (_) => AuthProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (ctx) => ctx.read<AuthProvider>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Fitness Tracker",
        theme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.dark,
          accentColor: Colors.pink[300],
          primaryColor: Colors.teal[900],
          fontFamily: "QuickSand",
          highlightColor: Colors.white,
          textTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
        ),
        themeMode: ThemeMode.dark,
        home: AuthenticationWrapper(),
        routes: {
          Home.routeName: (ctx) => Home(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          SignUpScreen.routeName: (ctx) => SignUpScreen(),
          WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
        },
      ),
    );
  }
}

//  Wrapper to check whether user is authenticated while splash screen is shown
//  Admin screen is visible only for admin
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //  To check whether user is logged in before or not
    final _firebaseUser = context.watch<User>();
    if (_firebaseUser == null)
      return WelcomeScreen();
    else
      return Home();
  }
}
