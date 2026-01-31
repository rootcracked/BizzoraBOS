import 'package:bizzora_mobile/features/workers/controller/LoginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bizzora_mobile/widget/pulse_dot.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bizzora_mobile/features/auth/presentation/widgets/Input.dart';
import 'package:toastification/toastification.dart';

class WorkerLoginScreen extends ConsumerStatefulWidget {
  const WorkerLoginScreen({super.key});

  @override
  ConsumerState<WorkerLoginScreen> createState() => _WorkerLoginScreenState();
}

class _WorkerLoginScreenState extends ConsumerState<WorkerLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // Reinstating the local state to manage loading when the provider doesn't.
  bool _isLoading = false; 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // 1. Validate form and check mounted status early
    if (!_formKey.currentState!.validate() || !mounted) {
      return;
    }

    // 2. Start Loading
    setState(() => _isLoading = true);

    final workerLogin = ref.read(LoginProvider.notifier);

    try {
      // 3. Attempt Login
      final user = await workerLogin.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Check mounted again before showing toast or navigating
      if (!mounted) return;

      // 4. Success Toast
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

      // 5. Navigate
      GoRouter.of(context).go("/worker-main");
    } catch (e) {
      // 6. Error Toast
      if (!mounted) return;
      
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: const Text("Login Failed!"),
        // Show the error message for more detail
        description: Text(e.toString()), 
        alignment: Alignment.topLeft,
        autoCloseDuration: const Duration(seconds: 4), // Increased duration for error
        animationBuilder: (context, animation, alignment, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        primaryColor: const Color(0xFFFF0000),
        backgroundColor: const Color(0xFFFF0000),
        foregroundColor: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: highModeShadow,
        closeButton: const ToastCloseButton(showType: CloseButtonShowType.onHover),
        applyBlurEffect: true,
        showIcon: false,
      );
    } finally {
      // 7. STOP Loading - CRUCIAL to always run this, even on error or navigation
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the local _isLoading state for UI logic
    final bool isLoading = _isLoading; 

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
                    // 
                    Image.asset(
                      'assets/bizzoralogo.png',
                      width: 80.w,
                      height: 80.h,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Hey Welcome to Bizzora!",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Join and work for your business!.",
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
                      // Disable input while loading
                       
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
                       // Disable input while loading
                       
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
                        // Button is disabled when loading is true
                        onPressed: isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1172D4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          disabledBackgroundColor: const Color(0xFF1172D4).withOpacity(0.5),
                        ),
                        child: isLoading
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Use PulsingDot as loading indicator
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
                          // Disable registration button while loading
                          onPressed: isLoading ? null : () {
                            GoRouter.of(context).go("/register");
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                               // Dim text color if disabled
                              color: isLoading ? Colors.blue.withOpacity(0.5) : null,
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
