import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              LoginHeader(),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends ConsumerWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginControllerProvider);
    final hidePasswordNotifier = ref.watch(hidePasswordProvider);
    final rememberMeNotifier = ref.watch(rememberMeProvider);
    final invalidCredentials = ref.watch(invalidCredentialsProvider);

    return Form(
      key: controller.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_rounded),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 10),

            TextFormField(
              obscureText: hidePasswordNotifier,
              controller: controller.password,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.enhanced_encryption),
                suffixIcon: IconButton(
                  onPressed: () => ref.read(hidePasswordProvider.notifier).toggle(),
                  icon: const Icon(Icons.remove_red_eye),
                ),
              ),
            ),
            const SizedBox(height: 5),

            if (invalidCredentials)
              const Text(
                'Invalid credentials. Please check your email and password.',
                style: TextStyle(color: Colors.red),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: rememberMeNotifier,
                      onChanged: (value) => ref.read(rememberMeProvider.notifier).toggle(),
                    ),
                    const Text('Remember Me'),
                  ],
                ),

                TextButton(onPressed: () => {}, child: const Text('Forget Password')),
              ],
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.emailAndPasswordSignIn(context, ref),
                child: const Text('Sign In'),
              ),
            ),
            const SizedBox(height: 5),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(onPressed: () => {}, child: const Text('Create Account')),
            ),
          ],
        ),
      ),
    );
  }
}





class LoginHeader extends StatelessWidget {
  const LoginHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: const Column(
        children: [
          // Add your header widgets here
          Text(
            'Welcome to VOCO',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Please enter your login information',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
