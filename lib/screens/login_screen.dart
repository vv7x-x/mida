import 'package:flutter/material.dart';
import 'package:mobile_app/services/authentication_service.dart';
import 'package:mobile_app/utils/app_strings.dart';
import 'package:mobile_app/utils/localization.dart';
import 'package:mobile_app/widgets/custom_button.dart';
import 'package:mobile_app/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.translate(AppStrings.login)!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: _emailController,
              labelText: l.translate(AppStrings.email)!,
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _passwordController,
              labelText: l.translate(AppStrings.password)!,
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            CustomButton(
              onPressed: () async {
                final bool success = await _authService.login(
                  _emailController.text,
                  _passwordController.text,
                );
                if (success) {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.translate(AppStrings.loginFailed)!),
                    ),
                  );
                }
              },
              text: l.translate(AppStrings.login)!,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registration');
              },
              child: Text(l.translate(AppStrings.register)!),
            ),
          ],
        ),
      ),
    );
  }
}