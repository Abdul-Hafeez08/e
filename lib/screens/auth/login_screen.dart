import 'package:e/screens/admin/request_approval_screen.dart';
import 'package:e/screens/auth/role_selection_screen.dart';
import 'package:e/screens/auth/signup_screen.dart';
import 'package:e/screens/buyer/home_screen.dart';
import 'package:e/screens/seller/request_screen.dart';
import 'package:e/services/auth_service.dart';
import 'package:e/utils/constants.dart';
import 'package:e/utils/validators.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final user = await _authService.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (user != null) {
          final userData = await _authService.getUserData(user.uid);
          if (userData != null) {
            if (userData['role'] == 'buyer') {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            } else if (userData['role'] == 'seller') {
              Navigator.pushReplacementNamed(context, RequestScreen.routeName);
            } else {
              Navigator.pushReplacementNamed(
                  context, RoleSelectionScreen.routeName);
            }
          } else {
            Navigator.pushReplacementNamed(
                context, RoleSelectionScreen.routeName);
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login failed: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: kErrorColor,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  const Icon(
                    Icons.shopping_bag,
                    size: 80,
                    color: kPrimaryColor,
                  ),
                  const SizedBox(height: kSmallPadding),
                  Text(
                    kAppName,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: kLargePadding * 2),
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: kPrimaryColor),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: kDefaultPadding),
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock, color: kPrimaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: kTextColorSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: Validators.validatePassword,
                  ),
                  const SizedBox(height: kLargePadding),
                  // Login Button
                  _isLoading
                      ? const CircularProgressIndicator(color: kPrimaryColor)
                      : ElevatedButton(
                          onPressed: _login,
                          child: const Text('Login'),
                        ),
                  const SizedBox(height: kDefaultPadding),
                  // Signup Link

                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignupScreen.routeName);
                    },
                    child: const Text(
                      'Don’t have an account? Sign Up',
                      style: TextStyle(color: kPrimaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RequestApprovalScreen.routeName);
                    },
                    child: const Text(
                      'Requests',
                      style: TextStyle(color: kPrimaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
