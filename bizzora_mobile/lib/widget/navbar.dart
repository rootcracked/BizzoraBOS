import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PremiumBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const PremiumBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h, // safe height for bottom nav

      decoration: BoxDecoration(
        color: const Color(0xFFEDF0F4),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onTabSelected,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFFEDF0F4).withValues(alpha: 0.5),
          elevation: 0,

          selectedItemColor: const Color(0xFF0066FF),
          unselectedItemColor: Colors.grey[700],
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          items: [
            _navItem(Icons.dashboard_rounded, 'Home'),
            _navItem(Icons.sell, 'Sell'),
            _addButtonItem(), // center add button inside the bar
            _navItem(Icons.business_center_rounded, 'Manage'),
            _navItem(Icons.person_rounded, 'Profile'),
          ],
        ),
      ),
    );
  }

  /// --- Regular nav items ---
  BottomNavigationBarItem _navItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min, // important: shrink to content
        mainAxisAlignment: MainAxisAlignment.center, // center vertically
        children: [
          Icon(icon, size: 22.sp),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      label: '',
    );
  }

  /// --- Center add button (inside bar) ---
  BottomNavigationBarItem _addButtonItem() {
    return BottomNavigationBarItem(
      icon: Container(
        height: 46.h, // smaller than bar height
        width: 46.w,
        decoration: BoxDecoration(
          color: const Color(0xFF2065E6),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0066FF).withValues(alpha: 0.3),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Icon(Icons.add, color: Colors.white, size: 28.sp),
      ),
      label: '', // no label for center button
    );
  }
}
