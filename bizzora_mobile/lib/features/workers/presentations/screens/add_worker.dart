import 'package:bizzora_mobile/features/auth/State/authNotifier.dart';
import 'package:bizzora_mobile/features/auth/State/authProvider.dart';
import 'package:bizzora_mobile/features/auth/presentation/widgets/Input.dart';
import 'package:bizzora_mobile/features/workers/controller/workerProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:bizzora_mobile/widget/pulse_dot.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddworkerScreen extends ConsumerStatefulWidget {
  const AddworkerScreen({super.key});

  @override
  ConsumerState<AddworkerScreen> createState() => _AddWorkerScreenState();
}

class _AddWorkerScreenState extends ConsumerState<AddworkerScreen> {
  final TextEditingController _workernameController = TextEditingController();
  final TextEditingController _workernumberController = TextEditingController();
  final TextEditingController _workeremailController = TextEditingController();
  final TextEditingController _workerpasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _addWorker() async {
    setState(() => _isLoading = true);

    final Workernotifier = ref.read(workerProvider.notifier);

    try {
      final newWorker = await Workernotifier.addWorker(
        _workernameController.text,
        _workernumberController.text,
        _workeremailController.text,
        _workerpasswordController.text,
      );

      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: Text("${newWorker.username} Added SuccessFully"),
        description: Text(" added to ${newWorker.businessName}"),
        alignment: Alignment.topLeft,
        autoCloseDuration: const Duration(seconds: 2),
        animationBuilder: (context, animation, alignment, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        primaryColor: Color(0xFFFF0000),
        backgroundColor: const Color(0xFF199F19),
        foregroundColor: const Color(0xFFFFFFFF),
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
        title: Text("Adding of Product Failed!"),
        description: Text("check well $e"),
        alignment: Alignment.topLeft,
        autoCloseDuration: const Duration(seconds: 4),
        primaryColor: Color(0xFF000000),
        backgroundColor: Color(0xFFFF0000),
        foregroundColor: Color(0xFFFFFFFF),
        boxShadow: highModeShadow,
        dragToClose: true,
        applyBlurEffect: true,
        showIcon: false,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),

              // --- HEADING ---
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    Text(
                      "Add Worker",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Fill details to add worker to business",
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // --- FORM FIELDS ---
              TextInput(
                placeholder: "Enter Worker Name",
                labelText: "UserName",
                controller: _workernameController,
                icon: Icons.person,
                type: TextInputType.text,
              ),
              SizedBox(height: 20.h),

              TextInput(
                placeholder: "Enter Phone Number",
                labelText: "Phone Number",
                controller: _workernumberController,
                icon: FontAwesomeIcons.phone,
                type: TextInputType.number,
              ),
              SizedBox(height: 20.h),

              TextInput(
                placeholder: "Enter Email Address",
                labelText: "Email",
                controller: _workeremailController,
                icon: Icons.mail,
                type: TextInputType.emailAddress,
              ),
              SizedBox(height: 20.h),

              TextInput(
                placeholder: "Enter Password",
                labelText: "Password",
                controller: _workerpasswordController,
                icon: Icons.password,
                type: TextInputType.text,
              ),
              SizedBox(height: 60.h),

              // --- ADD PRODUCT BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 60.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addWorker,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1172D4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PulsingDot(size: 15.w),
                            SizedBox(width: 8.w),
                            PulsingDot(size: 15.w),
                            SizedBox(width: 8.w),
                            PulsingDot(size: 15.w),
                          ],
                        )
                      : Text(
                          "Add Worker",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
