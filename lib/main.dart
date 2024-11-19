import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'signup.dart';
import 'home.dart';
import 'splash_screen.dart';
import 'message_boards.dart'; // New Screen for displaying message boards
import 'profile.dart'; // New Profile Screen
import 'settings.dart'; // New Settings Screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message Board App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: SplashScreen(), // This will show the splash screen initially
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/register': (context) => SignUpPage(),
        '/message_boards': (context) => MessageBoardsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}



