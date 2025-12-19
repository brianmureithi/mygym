import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:my_gym/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../state/auth_store.dart';
import 'home_screen.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '641884523038-4a0297g8t2q4jm8ugglke2f867snk657.apps.googleusercontent.com',
  );

  bool _loading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _loading = true);

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) throw Exception('No ID token');

      final names = googleUser.displayName?.split(' ') ?? ['', ''];

      final response = await http.post(
        Uri.parse('https://f2bfcfc56799.ngrok-free.app/api/login/google'),
        headers: {'Accept': 'application/json'},
        body: {
          'email': googleUser.email,
          'first_name': names.first,
          'last_name': names.skip(1).join(' '),
          'google_id': idToken,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Backend auth failed');
      }

      final data = jsonDecode(response.body);
      final token = data['token'];
      final user = data['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      if (!mounted) return;

      context.read<AuthStore>().setAuth(token: token, user: user);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MyHomePage()),
      );
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google sign-in failed')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo / Name
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontFamily: theme.textTheme.bodyLarge?.fontFamily,
                  ),
                  children: [
                    TextSpan(
                      text: 'my',
                      style: TextStyle(color: isDark ? Colors.white : Colors.black),
                    ),
                    const TextSpan(
                      text: 'GYM',
                      style: TextStyle(color: Colors.deepOrangeAccent),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Tagline
              Text(
                'Train smart. Stay consistent.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 48),

              // Google Sign In Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _loading ? null : _handleGoogleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.deepOrangeAccent)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Google Icon
                            Image.asset('lib/assets/google-small.png', height: 22),
                            const SizedBox(width: 12),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Terms & Privacy
              Text(
                'By continuing, you agree to our Terms & Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
