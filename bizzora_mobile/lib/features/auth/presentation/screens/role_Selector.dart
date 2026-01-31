import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// --- 1. Custom Color Definitions and Card Styles (Responsive to ManageMenu) ---

// Screen Background (from your ManageMenu code)
const Color screenBackgroundColor = Color(0xFFF8F7F5);
const Color titleTextColor = Colors.black87;
const Color subtitleTextColor = Color(0xFF616161); // Darker grey for body text

// Gradient and Color definitions for the two specific roles
const Color primaryColor = Color(0xFFF9A406); // Orange accent

const LinearGradient ownerGradient = LinearGradient(
  colors: [Color(0xFFFFF7E0), Color(0xFFFFEDD5)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
const Color ownerIconColor = primaryColor;

const LinearGradient workerGradient = LinearGradient(
  colors: [Color(0xFFE0F2FF), Color(0xFFEEF2FF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
const Color workerIconColor = Color(0xFF3B82F6); // Blue Accent

// --- 2. Reusable Animated Role Card Widget (Adapted from your _MenuCard) ---
class RoleSelectionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final Color iconColor;
  final VoidCallback onTap;

  const RoleSelectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.iconColor,
    required this.onTap,
  });

  @override
  State<RoleSelectionCard> createState() => _RoleSelectionCardState();
}

class _RoleSelectionCardState extends State<RoleSelectionCard> {
  // State for the smooth press animation
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // The fixed and reliable gesture handlers
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap, // Executes navigation
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: _pressed ? 0.98 : 1.0,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: widget.iconColor.withOpacity(0.15),
                // Adjust blur based on press state
                blurRadius: _pressed ? 5.w : 15.w,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 56.h,
                  width: 56.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5.w,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: 32.sp, // Responsive icon size
                  ),
                ),
              ),
              SizedBox(height: 14.h), // Responsive vertical space
              // Title Text
              Text(
                widget.title,
                textAlign: TextAlign.start,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp, // Responsive font size
                  color: titleTextColor,
                ),
              ),
              SizedBox(height: 6.h), // Responsive vertical space
              // Subtitle + Forward Arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.subtitle,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp, // Responsive font size
                        color: subtitleTextColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 20.sp,
                    color: subtitleTextColor.withOpacity(0.6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 3. Role Selection Screen (Adapted from your ManageMenu structure) ---
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            // Changed alignment to center the header and text
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Custom Top Bar (Matching ManageMenu Header) ---
              // This Row remains left-aligned effectively because of the spacer
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: subtitleTextColor,
                      ),
                      iconSize: 26.sp,
                      onPressed: () {
                        // Uses your correct GoRouter style for navigation
                        GoRouter.of(context).go("/register");
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Select Your Role",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            color: titleTextColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 48.w), // Spacer for centering
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              // --- Main Headline Text ---
              Text(
                'Welcome! Let\'s get started.',
                // Added textAlign: TextAlign.center
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: titleTextColor,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Tell us who you are to personalize your experience.',
                // Added textAlign: TextAlign.center
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: subtitleTextColor,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(height: 48.h),

              // --- Role Selection Cards ---
              Expanded(
                child: SingleChildScrollView(
                  // The SingleChildScrollView's child Column should be full width
                  child: Column(
                    children: [
                      RoleSelectionCard(
                        icon: Icons.storefront_rounded,
                        title: 'I\'m a business owner',
                        subtitle:
                            'Manage your business, view revenue,profits etc.',
                        gradient: ownerGradient,
                        iconColor: ownerIconColor,
                        onTap: () {
                          // Uses your correct GoRouter style for navigation
                          GoRouter.of(context).go("/login");
                        },
                      ),
                      SizedBox(height: 30.h),
                      RoleSelectionCard(
                        icon: Icons.person_rounded,
                        title: 'I\'m a worker',
                        subtitle: 'Sell business products etc ',
                        gradient: workerGradient,
                        iconColor: workerIconColor,
                        onTap: () {
                          // Uses your correct GoRouter style for navigation
                          GoRouter.of(context).go("/worker-login");
                        },
                      ),
                      SizedBox(height: 16.h), // Bottom padding
                    ],
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
