// lib/widgets/today_stats_card.dart

import 'package:bizzora_mobile/features/sales/models/realtime/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


/// Today's Statistics Card
/// Shows today's revenue and sales count
/// Updates in real-time
class TodayStatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RevenueWebSocketProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            // Today's Revenue
            Expanded(
              child: _StatCard(
                icon: Icons.today,
                iconColor: Color(0xFF10b981),
                label: 'Today\'s Revenue',
                value: '\$${provider.todayRevenue.toStringAsFixed(2)}',
                valueColor: Color(0xFF10b981),
              ),
            ),
            SizedBox(width: 16),
            // Today's Sales Count
            Expanded(
              child: _StatCard(
                icon: Icons.shopping_cart_outlined,
                iconColor: Color(0xFFf59e0b),
                label: 'Today\'s Sales',
                value: '${provider.todaySales}',
                valueColor: Color(0xFFf59e0b),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 36,
            ),
            SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
