import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:bizzora_mobile/features/product/Controller/productProvider.dart';

class AllProductsScreen extends ConsumerWidget {
  const AllProductsScreen({super.key});

  // Define the primary brand color
  static const Color primaryColor = Color(0xFF2065E6);
  // Define a subtle background color
  static const Color lightBackgroundColor = Color(0xFFF7F9FC);
  // Define a card background color
  static const Color cardColor = Colors.white;
  // Define a color for out-of-stock items
  static const Color outOfStockColor = Color(0xFFEF5350);
  // Define a color for in-stock text
  static const Color inStockColor = Color(0xFF388E3C);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider);
    final productNotifier = ref.read(productProvider.notifier);

    // Fetch products only once when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (productState.products.isEmpty) {
        productNotifier.getProducts();
      }
    });

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          // Using the modern, subtle background color
          backgroundColor: lightBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.w),
              color: Colors.black87,
              onPressed: () => GoRouter.of(context).go('/main-menu'),
              tooltip: 'Go back to main menu',
            ),
            backgroundColor: lightBackgroundColor,
            elevation: 0, // Modern apps often use a flat AppBar
            centerTitle: true,
            title: Text(
              'Product Inventory', // A slightly more professional title
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            // Adding a bottom line for separation instead of elevation
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.0),
              child: Container(color: Colors.grey.shade200, height: 1.0),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: productState.products.isEmpty
                ? _buildShimmer()
                : _buildProductList(productState),
          ),
        );
      },
    );
  }

  
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        
        cacheExtent: 500.0,
        itemCount: 8, // Increase count for a fuller screen look
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: cardColor, // Use white for the shimmering box
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Placeholder for an image/icon
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: Colors.white, // Shimmer will fill this
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title line
                        Container(
                          height: 18.h,
                          width: double.infinity,
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: 8.h),
                        ),
                        // Price line
                        Container(
                          height: 14.h,
                          width: 120.w,
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: 6.h),
                        ),
                        // Stock line
                        Container(
                          height: 12.h,
                          width: 70.w,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---  Modern Product list view with Cache Extent ---
  Widget _buildProductList(productState) {
    if (productState.products.isEmpty) {
      // Return a message if product list is empty after loading
      return Center(
        child: Text(
          'No products found.',
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      //  Performance Tip 2: Add cacheExtent for the main list 🌟
      cacheExtent: 500.0,
      itemCount: productState.products.length,
      itemBuilder: (context, index) {
        final product = productState.products[index];
        final inStock = product.quantity > 0;

        // Performance Tip 3: Use const where possible 🌟
        // (Ensured within the original design elements where static)

        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: InkWell(
            // Use InkWell for a nice tap effect on the entire card
            onTap: inStock
                ? () {
                    // TODO: Navigate to product details
                    print('Navigate to details for ${product.productName}');
                  }
                : null,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12.r),
                // Modern subtle shadow
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                // Add a slightly different border for out-of-stock items
                border: Border.all(
                  color: inStock
                      ? Colors.transparent
                      : outOfStockColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // Simple icon placeholder for visual interest
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 28.w,
                    color: inStock
                        ? primaryColor.withOpacity(0.8)
                        : Colors.grey.shade400,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName,
                          style: TextStyle(
                            fontSize: 16.sp, // Reduced size for a cleaner look
                            fontWeight: FontWeight.w600,
                            color: inStock
                                ? Colors.black87
                                : Colors.grey.shade500,
                            // Added slight text decoration for out of stock
                            decoration: inStock
                                ? TextDecoration.none
                                : TextDecoration.lineThrough,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'KES ${product.sellingPrice}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            // Use a deep grey/black for price for contrast
                            color: inStock
                                ? Colors.black87
                                : Colors.grey.shade400,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        // Stock status with color coding
                        Row(
                          children: [
                            Icon(
                              inStock
                                  ? Icons.check_circle_rounded
                                  : Icons.cancel_rounded,
                              size: 14.sp,
                              color: inStock ? inStockColor : outOfStockColor,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              inStock
                                  ? 'In Stock: ${product.quantity}'
                                  : 'Out of Stock',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: inStock ? inStockColor : outOfStockColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Details Button
                  SizedBox(
                    height: 40.h, // Fixed height for a neater look
                    child: ElevatedButton.icon(
                      onPressed: inStock
                          ? () {
                              // TODO: Navigate to product details
                              print('Details for: ${product.productName}');
                            }
                          : null,
                      icon: Icon(Icons.info_outline_rounded, size: 16.w),
                      label: Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            primaryColor, // Use the required primary color
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        elevation: 0, // Flat button design
                      ),
                    ),
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
