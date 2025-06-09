// Welcome Screen
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../main/main_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  _checkAuthState() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  // Mobile Layout
  Widget _buildMobileLayout() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              'Search & Discover Movies',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            SvgPicture.asset("assets/svg/logo.svg"),
            const Spacer(),
            _buildMobileButtons(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Web Layout
  Widget _buildWebLayout() {
    return Row(
      children: [
        // Left Side - Branding & Logo
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.all(60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Search & Discover Movies',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 1200 ? 48 : 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width > 1200 ? 400 : 300,
                    maxHeight: MediaQuery.of(context).size.width > 1200 ? 400 : 300,
                  ),
                  child: SvgPicture.asset(
                    "assets/svg/logo.svg",
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Right Side - Authentication Panel
        Expanded(
          flex: 4,
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.yellow[600]!.withOpacity(0.15),
                  Colors.yellow[800]!.withOpacity(0.1),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(40),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.grey[900]!.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.yellow.withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[600],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Join our community of movie enthusiasts',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[300],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),
                            _buildWebButtons(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Mobile Buttons
  Widget _buildMobileButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[600],
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Register',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.yellow[600],
              side: BorderSide(color: Colors.yellow[600]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Web Buttons
  Widget _buildWebButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[600],
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
              shadowColor: Colors.yellow[600]!.withOpacity(0.4),
            ),
            child: const Text(
              'Register',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.yellow[600],
              side: BorderSide(color: Colors.yellow[600]!, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Already have an account? Sign in to continue',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // For Web Layout
          if (constraints.maxWidth > 800) {
            return _buildWebLayout();
          } else {
            // For Mobile Layout
            return _buildMobileLayout();
          }
        },
      ),
    );
  }
}