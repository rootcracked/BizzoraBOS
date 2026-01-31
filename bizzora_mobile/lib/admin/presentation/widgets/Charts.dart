import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Ultra-modern, professional Line Chart widget with smooth animations
class RevenueChart extends StatefulWidget {
  final String title;
  final List<FlSpot> chartData;
  final Color stripColor;

  const RevenueChart({
    Key? key,
    required this.title,
    required this.chartData,
    required this.stripColor,
  }) : super(key: key);

  @override
  State<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chartData.isEmpty) {
      return _buildEmptyState();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: widget.stripColor.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 24.h),
                SizedBox(height: 280.h, child: _buildChart()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: widget.stripColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.trending_up,
                color: widget.stripColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Performance overview',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: widget.stripColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Icon(Icons.circle, size: 8.sp, color: widget.stripColor),
              SizedBox(width: 6.w),
              Text(
                'Live',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.stripColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 350.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.insert_chart_outlined_rounded,
                size: 48.sp,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'No data available',
              style: TextStyle(
                color: const Color(0xFF1A1A1A),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Chart will appear once data is added',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart() {
    final maxY =
        widget.chartData.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.2;
    final interval = (maxY / 5).ceilToDouble();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (widget.chartData.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey[200]!,
            strokeWidth: 1.5.w,
            dashArray: [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32.h,
              interval: 1,
              getTitlesWidget: (value, meta) => Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 55.w,
              interval: interval,
              getTitlesWidget: (value, meta) => Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Text(
                  'Ksh ${_formatNumber(value.toInt())}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: widget.chartData
                .map((spot) => FlSpot(spot.x, spot.y * _animation.value))
                .toList(),
            isCurved: true,
            curveSmoothness: 0.35,
            color: widget.stripColor,
            barWidth: 3.5.w,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                final isActive = _touchedIndex == index;
                return FlDotCirclePainter(
                  radius: isActive ? 6.5.r : 5.r,
                  color: Colors.white,
                  strokeWidth: isActive ? 3.5.w : 3.w,
                  strokeColor: widget.stripColor,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  widget.stripColor.withOpacity(0.25),
                  widget.stripColor.withOpacity(0.05),
                  widget.stripColor.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchCallback:
              (FlTouchEvent event, LineTouchResponse? touchResponse) {
                setState(() {
                  if (touchResponse == null ||
                      touchResponse.lineBarSpots == null) {
                    _touchedIndex = null;
                    return;
                  }
                  _touchedIndex = touchResponse.lineBarSpots!.first.spotIndex;
                });
              },
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            tooltipMargin: 8.h,
            getTooltipColor: (touchedSpot) => const Color(0xFFffe7d4),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItems: (touchedSpots) => touchedSpots
                .map(
                  (spot) => LineTooltipItem(
                    'Ksh ${spot.y.toStringAsFixed(2)}',
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                      letterSpacing: -0.3,
                    ),
                  ),
                )
                .toList(),
          ),
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((spotIndex) {
              return TouchedSpotIndicatorData(
                FlLine(
                  color: widget.stripColor.withOpacity(0.3),
                  strokeWidth: 2.w,
                  dashArray: [5, 5],
                ),
                FlDotData(
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 7.r,
                      color: Colors.white,
                      strokeWidth: 3.w,
                      strokeColor: widget.stripColor,
                    );
                  },
                ),
              );
            }).toList();
          },
        ),
      ),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}
