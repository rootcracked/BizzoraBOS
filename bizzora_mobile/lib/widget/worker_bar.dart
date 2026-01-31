import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkerBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const WorkerBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h, // safe height for bottom nav

      decoration: BoxDecoration(
        color: const Color(0xFFE7E7E7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
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
          backgroundColor: const Color(0xFFEDF0F4),
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
            _navItem(Icons.dashboard_rounded, 'Dashboard'),
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
          Icon(icon, size: 26.sp),
          SizedBox(height: 3.h),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      label: '',
    );
  }

  
}

