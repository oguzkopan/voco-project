import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../services/login_service.dart';
import '../view/home.dart';

final tokenProvider = StateProvider<String?>((ref) => null);

enum CacheManagerKey { TOKEN }

final rememberMeProvider = StateNotifierProvider<RememberMeNotifier, bool>((ref) {
  return RememberMeNotifier();
});

final hidePasswordProvider = StateNotifierProvider<HidePasswordNotifier, bool>((ref) {
  return HidePasswordNotifier();
});

final invalidCredentialsProvider = StateNotifierProvider<InvalidCredentialsNotifier, bool>((ref) {
  return InvalidCredentialsNotifier();
});

class RememberMeNotifier extends StateNotifier<bool> {
  RememberMeNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

class HidePasswordNotifier extends StateNotifier<bool> {
  HidePasswordNotifier() : super(true);

  void toggle() {
    state = !state;
  }
}

class InvalidCredentialsNotifier extends StateNotifier<bool> {
  InvalidCredentialsNotifier() : super(false);

  void setInvalidCredentials(bool value) {
    state = value;
  }
}

mixin CacheManager {
  Future<bool> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(CacheManagerKey.TOKEN.toString(), token);
    return true;
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(CacheManagerKey.TOKEN.toString());
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(CacheManagerKey.TOKEN.toString());
  }
}

class LoginController with CacheManager {
  late final LoginService loginService;
  final email = TextEditingController();
  final password = TextEditingController();

  final loginFormKey = GlobalKey<FormState>();
  final rememberMe = RememberMeNotifier();
  final hidePassword = HidePasswordNotifier();

  LoginController() {
    final dio = Dio();
    loginService = LoginService(dio);
  }

  Future<void> emailAndPasswordSignIn(BuildContext context, WidgetRef ref) async {
    // Validate email and password
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    // Get user input
    final user = User(email: email.text, password: password.text);

    // Make login request
    final token = await makeLoginRequest(user, ref);
    print("TOKEN: $token");

    if (token != null) {
      // Save token using CacheManager
      await saveToken(token);

      // If token is not null, navigate to HomePage
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    } else {
      // Set invalidCredentials to true if login fails
      ref.read(invalidCredentialsProvider.notifier).setInvalidCredentials(true);
    }
  }


  Future<String?> makeLoginRequest(User user, WidgetRef ref) async {
    try {
      final response = await loginService.fetchLogin(UserRequestModel(email: user.email, password: user.password));

      if (response != null) {
        return response.token ?? '';
      } else {
        // Handle unsuccessful login
        // Set invalidCredentials to true
        ref.read(invalidCredentialsProvider.notifier).setInvalidCredentials(true);
        return null;
      }
    } catch (e) {
      // Handle network errors
      // Set invalidCredentials to true
      ref.read(invalidCredentialsProvider.notifier).setInvalidCredentials(true);
      return null;
    }
  }

}

final loginControllerProvider = Provider((ref) => LoginController());
