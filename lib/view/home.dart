import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/login_controller.dart';
import 'login/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> userList = [];

  @override
  void initState() {
    super.initState();
    fetchUserList();
  }

  Future<void> fetchUserList() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> users = data['data'];

      setState(() {
        userList = List<Map<String, dynamic>>.from(users);
      });
    } else {
      // Handle error
      print('Failed to load user list');
    }
  }

  Future<void> logout() async {
    // Call your logout function from CacheManager
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(CacheManagerKey.TOKEN.toString());

    // Navigate to LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VOCO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                'User List',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (userList.isEmpty)
                const CircularProgressIndicator()
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: userList.map((user) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user['avatar']),
                        ),
                        title: Text('${user['first_name']} ${user['last_name']}'),
                        subtitle: Text(user['email']),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
