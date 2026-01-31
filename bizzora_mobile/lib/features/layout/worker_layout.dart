import 'package:bizzora_mobile/admin/presentation/screens/Sell_screen.dart';
import 'package:bizzora_mobile/worker/presentation/screens/Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bizzora_mobile/widget/worker_bar.dart';


class WorkermainScreen extends StatefulWidget {
  const WorkermainScreen({super.key});

  @override
  State<WorkermainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<WorkermainScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize persistent screens - only two screens now
    _screens = [
      const WorkerDashboardScreen(),
      
      const ProfileScreen()
    ];
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          bottomNavigationBar: WorkerBottomNav(
            selectedIndex: _selectedIndex,
            onTabSelected: _onTabSelected,
          ),
        ),
      ),
    );
  }
}
