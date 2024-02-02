import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voco_riverpod/view/home.dart'; // Import your home page
import 'package:voco_riverpod/view/login/login.dart';

import 'controller/login_controller.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Riverpod Session Management',
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: Colors.amberAccent,
          centerTitle: true,
        ),
      ),
      home: const AppWrapper(),
    );
  }
}

class AppWrapper extends ConsumerWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if the user is already logged in
    final token = ref.watch(tokenProvider);

    // Print the token
    print("Here is the token: $token");

    if (token != null) {
      // If the token exists, navigate to the Home page
      return const HomePage();
    } else {
      // If the token does not exist, show the Login page
      return const LoginScreen();
    }
  }
}

