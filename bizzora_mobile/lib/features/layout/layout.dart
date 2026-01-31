import 'package:bizzora_mobile/admin/presentation/screens/Sell_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bizzora_mobile/widget/navbar.dart';
import 'package:bizzora_mobile/admin/presentation/screens/dashboard.dart';
import 'package:bizzora_mobile/admin/presentation/screens/manage_menu.dart';

import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize persistent screens
    _screens = [
      const DashboardScreen(),
      const WorkerDashboardScreen(),
      const SizedBox.shrink(), // center (+) placeholder
      const ManageMenu(),
      const SizedBox.shrink(), // optional Profile placeholder
    ];
  }

  void _onTabSelected(int index) {
    if (index == 2) {
      _showAddMenu();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 90.h, // adds space from phone bottom bar
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Wrap(
              children: [
                // ... inside a Column widget ...

                // --- Add Worker Card ---
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/add-worker');
                  },
                  child: Card(
                    // High-level professionalism: Use a slightly higher elevation and subtle border
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16.0,
                      ), // More rounded, modern corners
                      side: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1.0,
                      ), // Subtle light border
                    ),
                    margin: EdgeInsets.only(
                      bottom: 12.0.h,
                    ), // Add vertical spacing between cards
                    child: Container(
                      width: double
                          .infinity, // **Fill the available width (Column optimization)**
                      padding: EdgeInsets.symmetric(
                        vertical: 18.0.h,
                        horizontal: 20.0.w,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // 1. Impactful Icon Area
                          Container(
                            padding: EdgeInsets.all(
                              10.0.w,
                            ), // Responsive padding
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(
                                0.12,
                              ), // Deeper accent background
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Icon(
                              Icons
                                  .person_add_alt_1_rounded, // Use a rounded/filled version for polish
                              size: 22.0.sp, // Larger, responsive icon size
                              color: Colors.blue[700], // Darker accent color
                            ),
                          ),
                          SizedBox(
                            width: 16.0.w,
                          ), // Responsive horizontal spacing
                          // 2. Title and Subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Add New Worker',
                                  style: TextStyle(
                                    fontSize:
                                        16.0.sp, // Clear, responsive title size
                                    fontWeight: FontWeight
                                        .w700, // **Extra Bold for professional impact**
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SizedBox(height: 3.0.h),
                                Text(
                                  'Onboard new employee profiles and details.',
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors
                                        .grey[600], // Muted, informative subtitle
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 3. Trailing Action Indicator
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16.0.sp,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // --- Add Product Card ---
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/add-product');
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(color: Colors.grey.shade200, width: 1.0),
                    ),
                    margin: EdgeInsets.only(bottom: 12.0.h),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 18.0.h,
                        horizontal: 20.0.w,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // 1. Impactful Icon Area
                          Container(
                            padding: EdgeInsets.all(10.0.w),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Icon(
                              Icons
                                  .inventory_2_rounded, // Rounded version for polish
                              size: 28.0.sp,
                              color: Colors.green[700],
                            ),
                          ),
                          SizedBox(width: 16.0.w),

                          // 2. Title and Subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Register New Product',
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                SizedBox(height: 3.0.h),
                                Text(
                                  'Update inventory and stock database.',
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 3. Trailing Action Indicator
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16.0.sp,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (_, __) => SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: IndexedStack(
            index: _selectedIndex,
            children: _screens.map((screen) {
              // Wrap each screen to prevent overflow
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        ScreenUtil().screenHeight -
                        78.h, // leave space for bottom nav
                  ),
                  child: IntrinsicHeight(child: screen),
                ),
              );
            }).toList(),
          ),
          bottomNavigationBar: PremiumBottomNav(
            selectedIndex: _selectedIndex,
            onTabSelected: _onTabSelected,
          ),
        ),
      ),
    );
  }
}
