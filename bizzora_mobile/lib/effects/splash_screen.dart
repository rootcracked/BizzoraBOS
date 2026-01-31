import 'package:bizzora_mobile/features/workers/controller/LoginProvider.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizzora_mobile/features/auth/State/authProvider.dart';

import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation: scale & fade
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _logoAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _logoController.forward();

    // Check authentication after a short delay to allow animation to play
    _confirmAuth();
  }

  Future<void> _confirmAuth() async {
    final authNotifier = ref.read(authProvider.notifier);
    final workerLogin = ref.read(LoginProvider.notifier);

    // Initialize auth (fetch token from storage)
    await authNotifier.checkAuth();
    await workerLogin.checkWorker();

    final authState = ref.read(authProvider);
    final workerstate = ref.read(LoginProvider);

    // Delay to let animation finish
    await Future.delayed(const Duration(seconds: 2));

    // Navigate admin based on authentication
    if (authState.isAuthenticated) {
      GoRouter.of(context).go('/main');
    } else {
      GoRouter.of(context).go('/register');
    }

    if (workerstate.isAuthenticated) {
      GoRouter.of(context).go("/worker-main");    

      }else{
      GoRouter.of(context).go("/worker-login");
      }
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // You can set a gradient if you like
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            ScaleTransition(
              scale: _logoAnimation,
              child: FadeTransition(
                opacity: _logoAnimation,
                child: SizedBox(
                  width: 150.w,
                  height: 150.h,
                  child: Image.asset('assets/bizzoralogo.png'),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Animated Business Name
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 38.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 1.2,
              ),
              child: AnimatedTextKit(
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 300),
                animatedTexts: [
                  TyperAnimatedText(
                    'Bizorra',
                    speed: const Duration(milliseconds: 150),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
