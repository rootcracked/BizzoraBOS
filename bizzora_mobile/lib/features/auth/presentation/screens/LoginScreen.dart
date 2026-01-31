import 'package:bizzora_mobile/features/auth/State/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizzora_mobile/widget/pulse_dot.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/Input.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authProvider.notifier);

    try {
      final user = await authNotifier.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        title: Text("Welcome back ${user.username}! "),
        alignment: Alignment.topLeft,
        autoCloseDuration: const Duration(seconds: 4),
        backgroundColor: const Color(0xFF199F19),
        foregroundColor: const Color(0xFFFFFFFF),
        boxShadow: highModeShadow,
        applyBlurEffect: true,
        borderRadius: BorderRadius.circular(12.0),
        showIcon: false,
        animationBuilder: (context, animation, alignment, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );

      GoRouter.of(context).go("/main");
    } catch (e) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: const Text("Login Failed!"),
        description: Text("Check your Credentials"),
        alignment: Alignment.topLeft,
        autoCloseDuration: const Duration(seconds: 2),
        animationBuilder: (context, animation, alignment, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        primaryColor: Color(0xFFFF0000),
        backgroundColor: Color(0xFFFF0000),
        foregroundColor: Color(0xFFFFFFFF),

        borderRadius: BorderRadius.circular(12.0),
        boxShadow: highModeShadow,
        closeButton: ToastCloseButton(showType: CloseButtonShowType.onHover),
        applyBlurEffect: true,
        showIcon: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),

              // --- LOGO AND HEADING ---
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/bizzoralogo.png',
                      width: 80.w,
                      height: 80.h,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Start managing your business smartly.",
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextInput(
                      controller: _emailController,
                      labelText: "Email",
                      placeholder: "Enter Email Address",
                      type: TextInputType.emailAddress,
                      icon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is Required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),

                    TextInput(
                      controller: _passwordController,
                      labelText: "Password",
                      placeholder: "Enter Password",
                      type: TextInputType.visiblePassword,
                      icon: Icons.lock,
                      hideCharacters: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is Required";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 40.h),

                    // --- LOGIN BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: 60.h,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1172D4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: authState.isLoading
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  PulsingDot(size: 10.w),
                                  SizedBox(width: 5.w),
                                  PulsingDot(size: 10.w),
                                  SizedBox(width: 5.w),
                                  PulsingDot(size: 10.w),
                                ],
                              )
                            : Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // --- Don't have an account? ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Create an Account? ",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14.sp,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).go("/register");
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
