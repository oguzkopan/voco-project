import 'package:dio/dio.dart';

class LoginService {
  final Dio _dio;

  LoginService(this._dio);

  Future<LoginResponse?> fetchLogin(UserRequestModel user) async {
    try {
      final response = await _dio.post('https://reqres.in/api/login', data: {
        'email': user.email,
        'password': user.password,
      });

      // Parse the response and return a LoginResponse object
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      // Handle errors, e.g., network issues or server errors
      print('Error during login request: $e');
      return null;
    }
  }
}

class UserRequestModel {
  final String email;
  final String password;

  UserRequestModel({required this.email, required this.password});
}

class LoginResponse {
  final String? token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(token: json['token']);
  }
}
