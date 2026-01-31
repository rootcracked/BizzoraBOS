import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bizzora_mobile/features/auth/State/authProvider.dart';
import 'package:bizzora_mobile/widget/pulse_dot.dart';
import 'package:go_router/go_router.dart';
import '../widgets/Input.dart';
import 'package:toastification/toastification.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _businessnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final authNotifier = ref.read(authProvider.notifier);

    try {
      final user = await authNotifier.register(
        _businessnameController.text,
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );

      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: Text("Registration SuccessFul"),
        description: Text("Welcome to Bizzora ${user.username}"),
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
      GoRouter.of(context).go("/main");
    } catch (e) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: Text("Registration Failed!"),
        description: Text("check credentials"),
        alignment: Alignment.topLeft,
        autoCloseDuration: const Duration(seconds: 4),
        primaryColor: Color(0xFF000000),
        backgroundColor: Color(0xFFFF0000),
        foregroundColor: Color(0xFFFFFFFF),
        boxShadow: highModeShadow,
        applyBlurEffect: true,
        showIcon: false,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // Base size (typical iPhone 12 screen)
      minTextAdapt: true,
      builder: (_, __) => Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
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
                        width: 90.w,
                        height: 90.h,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Start managing your business smartly.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 45.h),

                // --- INPUT FIELDS ---
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextInput(
                        controller: _businessnameController,
                        labelText: "Business Name",
                        placeholder: "Enter Business Name",
                        type: TextInputType.text,
                        icon: Icons.business,
                        validator: (value) => value == null || value.isEmpty
                            ? "Business Name is required"
                            : null,
                      ),
                      SizedBox(height: 22.h),
                      TextInput(
                        controller: _usernameController,
                        labelText: "Username",
                        placeholder: "Enter Username",
                        type: TextInputType.text,
                        icon: Icons.person,
                        validator: (value) => value == null || value.isEmpty
                            ? "Username is required"
                            : null,
                      ),
                      SizedBox(height: 22.h),
                      TextInput(
                        controller: _emailController,
                        labelText: "Email",
                        placeholder: "Enter Email Address",
                        type: TextInputType.emailAddress,
                        icon: Icons.email,
                        validator: (value) => value == null || value.isEmpty
                            ? "Email is required"
                            : null,
                      ),
                      SizedBox(height: 22.h),
                      TextInput(
                        controller: _passwordController,
                        labelText: "Password",
                        placeholder: "Enter Password",
                        type: TextInputType.visiblePassword,
                        icon: Icons.lock,
                        hideCharacters: true,
                        validator: (value) => value == null || value.isEmpty
                            ? "Password is required"
                            : null,
                      ),
                      SizedBox(height: 45.h),

                      // --- REGISTER BUTTON ---
                      SizedBox(
                        width: double.infinity,
                        height: 55.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1172D4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: _isLoading
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    PulsingDot(size: 10.w),
                                    SizedBox(width: 6.w),
                                    PulsingDot(size: 10.w),
                                    SizedBox(width: 6.w),
                                    PulsingDot(size: 10.w),
                                  ],
                                )
                              : Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 30.h),

                      // --- ALREADY HAVE ACCOUNT ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black54,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              GoRouter.of(context).go('/role-selector');
                            },
                            child: Text(
                              "Login",
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
      ),
    );
  }
}
