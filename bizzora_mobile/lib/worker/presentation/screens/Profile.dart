import 'package:bizzora_mobile/features/workers/controller/LoginProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workerState = ref.watch(LoginProvider);
    final worker = workerState.worker;
    
    final avatarUrl = "https://lh3.googleusercontent.com/aida-public/AB6AXuAygSbdu6c1mg3i04TZHm-RxuE3Z35CQ3kIP8ss6FnXqLV9fBBiwZWhfZno4GOTh5q68RbTZGph2IS91fR2v2-lWSzoZJjR1GpfiPESlyNpXuNpuEB85enz7pNR8Hwm0ZZiN--b9va4o4QKR_U59DOxFn-NG4skH2P7_tcuibZFjKs7qEn81Ij8KCAcNqG8xh4Ok57-FRV7HMrpeQFwmmB3QZDTgAwFgrrnpE8w88VkFVVOShmoE6moUZVJpDdQ4l1WF0CmvCaRBe8";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              children: [
                
                // Top App Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 40.w), // placeholder to balance the row
                  ],
                ),
                SizedBox(height: 20.h),

                // Profile Picture & Name
                Column(
                  children: [
                    Container(
                      height: 120.r,
                      width: 120.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3)),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(avatarUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      worker?.username ?? "No Username",
                      style: TextStyle(
                          fontSize: 24.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      worker?.role ?? "Sign in",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Contact Info Card
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Information",
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12.h),
                      _buildInfoRow(Icons.mail, "Email Address", worker?.email ?? "example@bizzora.com"),
                      Divider(),
                      _buildInfoRow(Icons.phone, "Phone Number", worker?.phoneNumber ?? "No phone"),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                _buildInfoCard("Personal Details", [
                _buildInfoRow(Icons.business, "Business Name",
                    worker?.businessName ?? "Unknown"),
                
              ]),
                SizedBox(height: 24.h,),

                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to edit profile screen
                    },
                    icon: Icon(Icons.edit),
                    label: Text("Edit Profile"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF1172D4),
                      textStyle: TextStyle(fontSize: 16.sp, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
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

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                    fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

