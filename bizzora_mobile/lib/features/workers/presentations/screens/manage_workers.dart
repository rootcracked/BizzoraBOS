import 'package:bizzora_mobile/features/workers/controller/WorkerNotifier.dart';
import 'package:bizzora_mobile/features/workers/controller/WorkerState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
// Note: Assuming 'workerProvider' is available from the WorkerNotifier file if not defined elsewhere.
// Assuming your provider is defined as 'workerProvider' in a file accessible to the UI.

class AllWorkersScreen extends ConsumerWidget {
  const AllWorkersScreen({super.key});

  // 🎨 Ultra-Professional Color Palette (Refined Neutral & Deep)
  static const Color primaryColor = Color(
    0xFF1F2937,
  ); // Dark Slate/Almost Black for text/brand
  static const Color lightBackgroundColor = Color(
    0xFFF9FAFB,
  ); // Near-white, very subtle background
  static const Color cardColor = Colors.white;
  static const Color accentColor = Color(
    0xFF3B82F6,
  ); // Standard Blue for Actions/Brand Highlights
  static const Color secondaryTextColor = Color(
    0xFF6B7280,
  ); // Mid-gray for secondary details
  // Dedicated color for the universal 'Worker' role tag
  static const Color workerTagColor = Color(
    0xFF4B5563,
  ); // Darker, professional gray for the role badge

  // Fixed width for the phone number column to ensure full visibility
  static const double _fixedPhoneWidth = 95.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workerState = ref.watch(workerProvider);
    final Workernotifier workerNotifier = ref.read(workerProvider.notifier);

    // Fetch workers only once when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (workerState.workers.isEmpty) {
        workerNotifier.getWorkers();
      }
    });

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: lightBackgroundColor,
          // --- Professional AppBar (Flat, Clean, Minimalist) ---
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.w),
              color: primaryColor,
              onPressed: () => GoRouter.of(context).go('/main-menu'),
              tooltip: 'Go back to main menu',
            ),
            backgroundColor: cardColor,
            elevation: 1, // Minimal elevation for a premium feel
            shadowColor: primaryColor.withOpacity(0.05), // Subtle shadow
            centerTitle: true,
            title: Text(
              'Team Directory',
              style: TextStyle(
                fontSize: 19.sp,
                fontWeight: FontWeight.w700,
                color: primaryColor,
                letterSpacing: -0.2,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  size: 24.w,
                  color: secondaryTextColor,
                ),
                onPressed: () {
                  // TODO: Implement search logic
                },
              ),
              SizedBox(width: 8.w),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: workerState.workers.isEmpty
                ? _buildShimmer() // Show shimmer if the list is empty (and we are likely fetching)
                : _buildWorkerList(workerState),
          ),
          // --- Modern Floating Action Button (Primary Action) ---
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              // TODO: Navigate to Add Worker screen
              GoRouter.of(context).go("/add-worker");
            },
            label: Text(
              'Add Member',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: cardColor,
              ),
            ),
            icon: Icon(
              Icons.person_add_alt_1_rounded,
              color: cardColor,
              size: 22.w,
            ),
            backgroundColor: accentColor,
            elevation: 6,
          ),
        );
      },
    );
  }

  // --- 🎨 Modern Shimmer Loader ---
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        cacheExtent: 500.0,
        itemCount: 8,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Container(
              height: 70.h,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- 👤 Ultra-Professional Worker List View ---
  Widget _buildWorkerList(WorkerStoreState workerState) {
    if (workerState.workers.isEmpty) {
      return Center(
        child: Text(
          'No team members found. Tap "Add Member" to begin.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            color: secondaryTextColor,
            height: 1.5,
          ),
        ),
      );
    }

    return ListView.builder(
      cacheExtent: 500.0,
      itemCount: workerState.workers.length,
      padding: EdgeInsets.only(bottom: 80.h),
      itemBuilder: (context, index) {
        final worker = workerState.workers[index];
        const workerRole = 'Worker'; // Universal label

        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: InkWell(
            onTap: () {
              // TODO: Navigate to worker details screen
              print('Navigate to details for ${worker.username}');
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  // Subtle, high-quality shadow
                  BoxShadow(
                    color: primaryColor.withOpacity(0.04),
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200, width: 1.0),
              ),
              child: Row(
                children: [
                  // --- Avatar/Initials Circle (Using Accent Color for Brand Identity) ---
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withOpacity(
                        0.1,
                      ), // Light brand blue background
                    ),
                    child: Center(
                      child: Text(
                        worker.username.isNotEmpty
                            ? worker.username[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                          color: accentColor, // Brand blue text
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // --- Worker Details (Name/Role/Email) - **Adjusted for full name visibility** ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Full Name (Most Prominent - now allows multiple lines if needed)
                        Text(
                          // **Displaying Full Name clearly and boldly**
                          worker.username,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700, // **Highest emphasis**
                            color: primaryColor,
                          ),
                          maxLines: 2, // Allow name to wrap if necessary
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),

                        // 2. Email + Role Tag Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                // **Displaying Email clearly**
                                worker.email,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      secondaryTextColor, // Subtle contrast to the name
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // --- Role Tag (Secondary Info) ---
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: workerTagColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                workerRole,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: workerTagColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),

                  // --- Phone Number (Actionable Info - **Fixed Width for full number**) ---
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement direct phone call action using url_launcher
                      print('Initiating call to ${worker.phoneNumber}');
                    },
                    child: Container(
                      width: _fixedPhoneWidth
                          .w, // Ensure the phone number has enough space
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            // **Displaying Full Phone Number**
                            worker.phoneNumber,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow
                                .ellipsis, // Fallback, but size should prevent this
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: 2.h),
                          // Action-suggesting icon
                          Icon(
                            Icons.phone_in_talk_rounded,
                            size: 16.w,
                            color: accentColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w),

                  // --- Navigation Indicator ---
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16.w,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
