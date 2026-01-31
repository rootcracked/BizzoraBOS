import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// --- Reusable Revenue / Stats Card (Responsive) - Modern Outlined Style with CountUp Animation ---
class RevenueCard extends StatefulWidget {
  final String title;
  final double amount;
  final IconData icon;
  final Color iconColor;
  final Duration animationDuration;

  const RevenueCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<RevenueCard> createState() => _RevenueCardState();
}

class _RevenueCardState extends State<RevenueCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Currency Formatter: Uses 'en_KES' locale for clean Kenyan Shilling formatting
  static final currencyFormatter = NumberFormat.currency(
    locale: 'en_KES',
    name: 'Ksh ',
    decimalDigits: 2,
  );

  // Format amount with K for thousands
  static String formatAmount(double amount) {
    if (amount >= 1000000) {
      // For millions (e.g., 1.5M)
      double millions = amount / 1000000;
      return 'Ksh ${millions.toStringAsFixed(millions % 1 == 0 ? 0 : 1)}M';
    } else if (amount >= 1000) {
      // For thousands (e.g., 1.5K)
      double thousands = amount / 1000;
      return 'Ksh ${thousands.toStringAsFixed(thousands % 1 == 0 ? 0 : 1)}K';
    } else {
      // For amounts less than 1000, show normal format
      return currencyFormatter.format(amount);
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Create a curved animation from 0 to the target amount
    _animation = Tween<double>(
      begin: 0,
      end: widget.amount,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Start the animation
    _controller.forward();
  }

  @override
  void didUpdateWidget(RevenueCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the amount changes, restart the animation with the new value
    if (oldWidget.amount != widget.amount) {
      _animation = Tween<double>(begin: oldWidget.amount, end: widget.amount)
          .animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          );

      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the transparent background color for the icon circle
    final Color circleBackgroundColor = widget.iconColor.withOpacity(0.15);

    return Card.outlined(
      // Use Card.outlined for a modern, flat, bordered look
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- ICON and TITLE (Horizontal Row) ---
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The Icon in the Translucent Circle
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: circleBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                // The Title Text
                Flexible(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // --- VALUE (Animated Formatted Money) ---
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final String formattedAmount = formatAmount(_animation.value);

                return FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formattedAmount,
                    style: GoogleFonts.gideonRoman(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: -0.5.sp,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
