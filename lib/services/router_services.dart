import 'package:book/views/auth/login.dart';
import 'package:book/views/auth/register.dart';
import 'package:book/views/home/home_screen.dart';
import 'package:book/views/root_screen.dart';
import 'package:book/views/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterServices {
  final GoRouter _goRouter = GoRouter(
    initialLocation: '/splash',
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
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const HomePageScreen(),
        ),
      ),
      GoRoute(
        path: '/root',
        name: 'root',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const RootScreen(),
        ),
      ),
    ],
  );

  GoRouter get goRouter => _goRouter;
}
