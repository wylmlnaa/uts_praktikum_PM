import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../views/mobile/login_screen.dart';
import '../views/mobile/signup_screen.dart';
import '../views/mobile/otp_verification_screen.dart';
import '../views/layouts/responsive_layout.dart';
import '../views/mobile/mobile_dashboard.dart';
import '../views/web/web_dashboard.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isLoggingIn = state.matchedLocation == '/login' ||
        state.matchedLocation == '/signup' ||
        state.matchedLocation == '/otp-verification';

    if (authProvider.isLoading) {
      return null;
    }

    if (!authProvider.isAuthenticated) {
      // Redirect to login if trying to access a protected page
      return isLoggingIn ? null : '/login';
    }

    // Redirect to home if logged in and trying to access login/signup
    if (isLoggingIn) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return OtpVerificationScreen(email: email);
      },
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const ResponsiveLayout(
        mobileBody: MobileDashboard(),
        webBody: WebDashboard(),
      ),
    ),
  ],
);
