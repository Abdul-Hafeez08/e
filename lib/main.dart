import 'package:e/Widets/Bottom_Bar.dart';
import 'package:e/routes.dart';
import 'package:e/screens/auth/login_screen.dart';
import 'package:e/screens/buyer/Provider/cart_provider.dart';
import 'package:e/screens/seller/provider/orderprovider.dart';

import 'package:e/screens/seller/request_screen.dart';
import 'package:e/screens/seller/seller_dashboard_screen.dart';
import 'package:e/services/auth_service.dart';
import 'package:e/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => OrdersProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
    )
  ], child: const EcommerceApp()));
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fresh Cart',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
        ),
        // fontFamily: 'Roboto',
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          secondary: kSecondaryColor,
          surface: kBackgroundColor,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: kTextColor,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: kTextColor,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: kTextColorSecondary,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kBackgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kPrimaryColor, width: 2),
          ),
          labelStyle: const TextStyle(color: kTextColorSecondary),
          hintStyle: const TextStyle(color: kTextColorSecondary),
        ),
        useMaterial3: true,
      ),
      // home: const SplashScreen(),
      home: const SplashScreen(),
      onGenerateRoute: RouteGenerator.generateRoute,

      // onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        return;
      }

      final authService = AuthService();
      final userData = await authService.getUserData(user.uid);

      if (!mounted) return; // check again before navigating

      if (userData != null) {
        if (userData['role'] == 'buyer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const BottomBar()),
          );
        } else if (userData['role'] == 'seller') {
          if (userData['shopId'] != null && userData['shopId'].isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const SellerDashboardScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RequestScreen()),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      debugPrint("Auth check failed: $e");
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  // Future<void> _checkAuthState() async {
  //   await Future.delayed(const Duration(seconds: 2)); // Simulate splash delay
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user == null) {
  //     Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  //   } else {
  //     final authService = AuthService();
  //     final userData = await authService.getUserData(user.uid);
  //     if (userData != null) {
  //       if (userData['role'] == 'buyer') {
  //         Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  //       } else if (userData['role'] == 'seller') {
  //         if (userData['shopId'] != null && userData['shopId'].isNotEmpty) {
  //           Navigator.pushReplacementNamed(
  //               context, SellerDashboardScreen.routeName);
  //         } else {
  //           Navigator.pushReplacementNamed(context, RequestScreen.routeName);
  //         }
  //       } else {
  //         Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  //       }
  //     } else {
  //       Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              'E-commerce App',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Colors.white),
            ).animate().fade(duration: 500.ms).scale(delay: 500.ms)
            // .moveY(begin: 50, end: 0, duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
