import 'package:book/models/sitter.dart';
import 'package:book/services/auth_services.dart';
import 'package:book/views/sitter/dashboard.dart';
import 'package:book/views/sitter/sitter_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../views/auth/login.dart';
import '../views/auth/register.dart';
import '../views/home/home_screen.dart';
import '../views/root_screen.dart';
import '../views/sitter/sitter_screen.dart';
import '../views/splash/splash_screen.dart';

class RouterServices {
  GoRouter _goRouter(AuthServices authServices) => GoRouter(
        initialLocation: '/splash',
        // redirect: (context, state) {
        //   final isAuthenticated = authServices.isAuth;

        //   final isGoingToLogin = state.path == '/login';
        //   final isGoingToRegister = state.path == '/register';

        //   if (!isAuthenticated && !isGoingToLogin && !isGoingToRegister) {
        //     // If not authenticated, redirect to login page for protected routes.
        //     return '/login';
        //   } else if (isAuthenticated && (isGoingToLogin || isGoingToRegister)) {
        //     // If authenticated and trying to access login/register, redirect to home.
        //     return '/root';
        //   }

        //   return null;
        // },
        routes: [
          GoRoute(
            path: '/splash',
            name: 'splash',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const SplashScreen(),
            ),
          ),
          GoRoute(
            path: '/sregister',
            name: 'sregister',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const SitterRegisterScreen(),
            ),
          ),
          GoRoute(
            path: '/register',
            name: 'register',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const RegisterScreen(),
            ),
          ),
          GoRoute(
            path: '/login',
            name: 'login',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const LoginScreen(),
            ),
          ),
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) {
              return MaterialPage(
                key: state.pageKey,
                child: HomePageScreen(),
              );
            },
          ),
          GoRoute(
            path: '/root',
            name: 'root',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const RootScreen(),
            ),
          ),
          GoRoute(
            path: '/sitter',
            name: 'sitter',
            pageBuilder: (context, state) {
              final Sitter user = state.extra as Sitter;
              return MaterialPage(
                key: state.pageKey,
                child: SitterScreen(
                  sitter: user,
                ),
              );
            },
          ),
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) {
              // final Sitter user = state.extra as Sitter;
              return MaterialPage(
                key: state.pageKey,
                child: SitterDashboard(
                    // sitter: user,
                    ),
              );
            },
          ),
        ],
      );

  GoRouter getRouter(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context, listen: false);
    return _goRouter(authServices);
  }
}
