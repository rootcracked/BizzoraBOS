import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';



class ManageMenu extends StatelessWidget {
  const ManageMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 26),
                      color: Colors.grey,
                      onPressed: () {
                        GoRouter.of(context).go("/main");
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Manage Products",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 48.w), // balance for centering title
                                      ],
                ),
              ),
              SizedBox(height: 24.h),

              // Menu cards
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _MenuCard(
                        icon: Icons.add_box_outlined,
                        title: "Manage Products",
                        subtitle: "View products in business",
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFF7E0), Color(0xFFFFEDD5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        iconColor: const Color(0xFFF9A406),
                        onTap: () {
                          GoRouter.of(context).go("/manage-products");
                        },
                      ),
                      SizedBox(height: 20.h),
                      _MenuCard(
                        icon: Icons.person_rounded,
                        title: "Manage Workers",
                        subtitle: "Edit or delete workers in system",
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE0F2FF), Color(0xFFEEF2FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        iconColor: Colors.blue.shade600,
                        onTap: () {
                          GoRouter.of(context).go("/manage-workers");
                        },
                      ),
                      SizedBox(height: 20.h),
                      _MenuCard(
                        icon: Icons.money,
                        title: "Manage Expenses",
                        subtitle: "Modify Expenses",
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE6F9E6), Color(0xFFD1FAE5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        iconColor: Colors.teal.shade600,
                        onTap: () {},
                      ),
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

class _MenuCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final Color iconColor;
  final VoidCallback onTap;
  

  const _MenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.iconColor,
    required this.onTap,
    
  });

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
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
                blurRadius: _pressed ? 5 : 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
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
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: 32.sp,
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              // Title
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 6.h),
              // Subtitle + arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, size: 30),
                    onPressed: widget.onTap,
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
