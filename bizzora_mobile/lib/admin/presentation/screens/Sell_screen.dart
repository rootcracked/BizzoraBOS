import 'package:bizzora_mobile/features/auth/State/authProvider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bizzora_mobile/features/product/Controller/productProvider.dart';
import 'package:bizzora_mobile/features/product/Models/product_response.dart';
import 'package:bizzora_mobile/features/sales/sale_request.dart';
import 'package:bizzora_mobile/features/sales/service.dart';
import 'package:toastification/toastification.dart';


class WorkerDashboardScreen extends ConsumerStatefulWidget {
  const WorkerDashboardScreen({super.key});

  @override
  ConsumerState<WorkerDashboardScreen> createState() =>
      _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends ConsumerState<WorkerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch products when screen loads
    final productNotifier = ref.read(productProvider.notifier);
    productNotifier.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(375, 812));
    final productState = ref.watch(productProvider);
    final products = productState.products;

    final adminState = ref.watch(authProvider);
    final admin = adminState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          admin?.businessName ?? "Unknown",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xFFfafaff),
        elevation: 2.0,
      ),
      body: products.isEmpty
          ? const Center(child: Text("No products found"))
          : Padding(
              padding: EdgeInsets.all(12.w),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product: product, ref: ref);
                },
              ),
            ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductResponse product;
  final WidgetRef ref;

  const ProductCard({super.key, required this.product, required this.ref});

  @override
  Widget build(BuildContext context) {
    final name = product.productName ?? 'Unnamed';
    final price = product.sellingPrice?.toDouble() ?? 0.0;
    final stock = product.quantity ?? 0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 80.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const Icon(
                Icons.shopping_bag,
                size: 50,
                color: Colors.grey,
              ),
            ),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
            Text(
              "Ksh ${price.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: Color(0xFF00A300),
              ),
            ),
            Text(
              "Stock: $stock",
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2065E6),
                fixedSize: Size(200, 30),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: stock > 0 ? () => _showSellBottomSheet(context) : null,
              child: Text("Sell", style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSellBottomSheet(BuildContext context) {
    int quantity = 1;
    double total = product.sellingPrice?.toDouble() ?? 0.0;
    final stock = product.quantity ?? 0;
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 20.h,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50.w,
                      height: 5.h,
                      margin: EdgeInsets.only(bottom: 15.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    Text(
                      "Sell Product",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      product.productName ?? '',
                      style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                    ),
                    SizedBox(height: 8.h),
                    Text("Price: Ksh ${total.toStringAsFixed(2)}"),
                    Text(
                      "Stock: $stock",
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: quantity > 1
                              ? () {
                                  setState(() {
                                    quantity--;
                                    total =
                                        (product.sellingPrice?.toDouble() ??
                                            0.0) *
                                        quantity;
                                  });
                                }
                              : null,
                        ),
                        Text(
                          quantity.toString(),
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: quantity < stock
                              ? () {
                                  setState(() {
                                    quantity++;
                                    total =
                                        (product.sellingPrice?.toDouble() ??
                                            0.0) *
                                        quantity;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Total: Ksh ${total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton.icon(
                      icon: isLoading
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.check),
                      label: isLoading
                          ? const Text("Processing...")
                          : const Text("Confirm Sale"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() => isLoading = true);
                              final request = SaleRequest(
                                productId: product.id ?? '',
                                quantity: quantity,
                              );
                              final salesService = SalesService();
                              try {
                                await salesService.sellProduct(request);
                                Navigator.pop(context);
                                toastification.show(
                                  context: context,
                                  type: ToastificationType.success,
                                  alignment: Alignment.topLeft,
                                  title: Text(
                                    "${product.productName} Sold SuccessFully",
                                  ),
                                  style: ToastificationStyle.flat,
                                  autoCloseDuration: const Duration(seconds: 2),
                                  backgroundColor: const Color(0XFF199F19),
                                  foregroundColor: const Color(0xFFFFFFFF),
                                  boxShadow: highModeShadow,
                                  borderRadius: BorderRadius.circular(12.0),
                                  showIcon: false,
                                  animationBuilder:
                                      (context, animation, alignment, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                );
                                await ref
                                    .read(productProvider.notifier)
                                    .getProducts();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e")),
                                );
                              } finally {
                                if (context.mounted) {
                                  setState(() => isLoading = false);
                                }
                              }
                            },
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
