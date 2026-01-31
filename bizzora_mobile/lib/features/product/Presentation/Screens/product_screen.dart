import 'dart:ui';
import 'package:bizzora_mobile/features/auth/presentation/widgets/Input.dart';
import 'package:bizzora_mobile/features/product/Controller/productNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bizzora_mobile/widget/pulse_dot.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import "package:toastification/toastification.dart";

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  final TextEditingController _productnameController = TextEditingController();
  final TextEditingController _buyingPriceController = TextEditingController();
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addProduct() async {
    setState(() => _isLoading = true);

    final ProductNotifier = ref.read(productProvider.notifier);

    final buyingPrice = int.tryParse(_buyingPriceController.text);
    final sellingPrice = int.tryParse(_sellingPriceController.text);
    final quantity = int.tryParse(_quantityController.text);

    try {
      final newProduct = await ProductNotifier.addProduct(
        _productnameController.text,
        buyingPrice,
        sellingPrice,
        quantity,
      );

      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: Text("${newProduct.productName} Added SuccessFully"),
        description: Text(" added to System"),
        alignment: Alignment.topLeft,
        autoCloseDuration: const Duration(seconds: 2),
        animationBuilder: (context, animation, alignment, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        primaryColor: Color(0xFFFF0000),
        backgroundColor: const Color(0xFF199F19),
        foregroundColor: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: highModeShadow,
        closeButton: ToastCloseButton(showType: CloseButtonShowType.onHover),
        applyBlurEffect: true,
        showIcon: false,
      );
      GoRouter.of(context).go("/main");
    } catch (e) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: Text("Adding of Product Failed!"),
        description: Text("check well"),
        alignment: Alignment.topLeft,
        autoCloseDuration: const Duration(seconds: 4),
        primaryColor: Color(0xFF000000),
        backgroundColor: Color(0xFFFF0000),
        foregroundColor: Color(0xFFFFFFFF),
        boxShadow: highModeShadow,
        dragToClose: true,
        applyBlurEffect: true,
        showIcon: false,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),

              // --- HEADING ---
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    Text(
                      "Add Products",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Fill details to add product to inventory",
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // --- FORM FIELDS ---
              TextInput(
                placeholder: "Enter Product Name",
                labelText: "Product Name",
                controller: _productnameController,
                icon: FontAwesomeIcons.box,
                type: TextInputType.text,
              ),
              SizedBox(height: 20.h),

              TextInput(
                placeholder: "Enter Buying Price",
                labelText: "Buying Price",
                controller: _buyingPriceController,
                icon: FontAwesomeIcons.moneyBill,
                type: TextInputType.number,
              ),
              SizedBox(height: 20.h),

              TextInput(
                placeholder: "Enter Selling Price",
                labelText: "Selling Price",
                controller: _sellingPriceController,
                icon: FontAwesomeIcons.moneyBill,
                type: TextInputType.number,
              ),
              SizedBox(height: 20.h),

              TextInput(
                placeholder: "Enter Quantity",
                labelText: "Quantity",
                controller: _quantityController,
                icon: FontAwesomeIcons.warehouse,
                type: TextInputType.number,
              ),
              SizedBox(height: 60.h),

              // --- ADD PRODUCT BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 60.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1172D4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PulsingDot(size: 15.w),
                            SizedBox(width: 8.w),
                            PulsingDot(size: 15.w),
                            SizedBox(width: 8.w),
                            PulsingDot(size: 15.w),
                          ],
                        )
                      : Text(
                          "Add Product",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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

