// lib/models/revenue_data.dart

/// Represents one day's revenue data for charts
/// Matches the DailyRevenueData from your Go backend
class DailyRevenueData {
  final String date;       // "2025-11-15"
  final double revenue;    // 810.00
  final int sales;         // 16 sales

  DailyRevenueData({
    required this.date,
    required this.revenue,
    required this.sales,
  });

  /// Parse from JSON received from WebSocket
  /// Backend sends: {"date": "2025-11-15", "revenue": 810.0, "sales": 16}
  factory DailyRevenueData.fromJson(Map<String, dynamic> json) {
    return DailyRevenueData(
      date: json['date'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      sales: json['sales'] as int,
    );
  }

  /// Format date for display
  /// "2025-11-15" → "Nov 15"
  String get formattedDate {
    try {
      final dateTime = DateTime.parse(date);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dateTime.month - 1]} ${dateTime.day}';
    } catch (e) {
      return date.substring(5); // Fallback: "11-15"
    }
  }

  /// Short date for chart labels
  /// "2025-11-15" → "11/15"
  String get shortDate {
    return date.substring(5).replaceAll('-', '/');
  }
}

/// Complete revenue data received from WebSocket
/// Matches the RevenueUpdate struct from your Go backend
class RevenueData {
  final String type;              // "initial_revenue" or "revenue_update"
  final String businessId;        // Your business ID
  final double totalRevenue;      // All-time total revenue
  final double todayRevenue;      // Today's total
  final int todaySales;           // Today's sales count
  final List<DailyRevenueData> dailyRevenue;  // Last 7 days for chart
  final double? saleAmount;       // This specific sale (only on updates)
  final String timestamp;         // ISO timestamp

  RevenueData({
    required this.type,
    required this.businessId,
    required this.totalRevenue,
    required this.todayRevenue,
    required this.todaySales,
    required this.dailyRevenue,
    this.saleAmount,
    required this.timestamp,
  });

  /// Parse from JSON received from your Go backend
  /// Backend sends complete RevenueUpdate struct as JSON
  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      type: json['type'] as String,
      businessId: json['business_id'] as String,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
      todayRevenue: (json['today_revenue'] as num?)?.toDouble() ?? 0.0,
      todaySales: json['today_sales'] as int? ?? 0,
      dailyRevenue: (json['daily_revenue'] as List?)
              ?.map((item) => DailyRevenueData.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      saleAmount: (json['sale_amount'] as num?)?.toDouble(),
      timestamp: json['timestamp'] as String,
    );
  }

  /// Check if this is a sale update (vs initial data)
  /// Used to show notifications
  bool get isSaleUpdate => type == 'revenue_update' && saleAmount != null;

  /// Get the last day's revenue (for highlighting)
  DailyRevenueData? get lastDay {
    if (dailyRevenue.isEmpty) return null;
    return dailyRevenue.last;
  }
}
