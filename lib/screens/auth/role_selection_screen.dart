import 'package:e/screens/buyer/home_screen.dart';
import 'package:e/screens/seller/request_screen.dart';
import 'package:e/services/auth_service.dart';
import 'package:e/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoleSelectionScreen extends StatefulWidget {
  static const String routeName = '/role-selection';

  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _selectedRole;

  Future<void> _selectRole(String role) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _authService.updateUserRole(user.uid, role);
        if (role == 'buyer') {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        } else if (role == 'seller') {
          Navigator.pushReplacementNamed(context, RequestScreen.routeName);
        }
      } else {
        throw Exception('No user logged in');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to select role: ${e.toString()}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPadding),
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
                // Title
                Text(
                  'Choose Your Role',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: kLargePadding),
                // Role Selection Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleCard(
                      context,
                      role: 'Buyer',
                      icon: Icons.shop,
                      isSelected: _selectedRole == 'buyer',
                      onTap: () {
                        setState(() {
                          _selectedRole = 'buyer';
                        });
                        _selectRole('buyer');
                      },
                    ),
                    const SizedBox(width: kDefaultPadding),
                    _buildRoleCard(
                      context,
                      role: 'Seller',
                      icon: Icons.store,
                      isSelected: _selectedRole == 'seller',
                      onTap: () {
                        setState(() {
                          _selectedRole = 'seller';
                        });
                        _selectRole('seller');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: kLargePadding),
                // Loading Indicator
                if (_isLoading)
                  const CircularProgressIndicator(color: kPrimaryColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String role,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Card(
        elevation: isSelected ? 8 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          side: BorderSide(
            color: isSelected ? kPrimaryColor : kBorderColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 50,
                color: isSelected ? kPrimaryColor : kTextColorSecondary,
              ),
              const SizedBox(height: kSmallPadding),
              Text(
                role,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: isSelected ? kPrimaryColor : kTextColor,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
