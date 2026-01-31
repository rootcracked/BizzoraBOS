import 'package:bizzora_mobile/admin/presentation/widgets/Charts.dart';
import 'package:bizzora_mobile/admin/presentation/widgets/RevenueCard.dart';
import 'package:bizzora_mobile/features/sales/models/realtime/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = RevenueWebSocketProvider();
        provider.init(); // automatically fetch token & connect
        return provider;
      },
      child: Consumer<RevenueWebSocketProvider>(
        builder: (context, provider, child) {
          // Build dashboard once data is available
          final chartData = provider.dailyRevenue
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.revenue))
              .toList();

          print(chartData);

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Dashboard",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.sp),
              ),
              backgroundColor: const Color(0xFFfafaff),
              elevation: 2.0,
            ),
            backgroundColor: const Color(0xFFf5f7fa),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Revenue & Profit Cards
                      Row(
                        children: [
                          Expanded(
                            child: RevenueCard(
                              title: "Revenue",

                              amount: 10000,
                              icon: Icons.account_balance_wallet,
                              iconColor: Colors.greenAccent,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: RevenueCard(
                              title: "Gross Profit",
                              amount: 6000, // example
                              icon: Icons.money,
                              iconColor: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      Row(
                        children: [
                          Expanded(
                            child: RevenueCard(
                              title: "Profit",

                              amount: 200,
                              icon: Icons.account_balance_wallet,
                              iconColor: Colors.greenAccent,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: RevenueCard(
                              title: "Expense",
                              amount: 2000, // example
                              icon: Icons.money,
                              iconColor: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      // Revenue Chart
                      RevenueChart(
                        title: "Revenue",
                        stripColor: Colors.greenAccent,
                        chartData: chartData,
                      ),

                      SizedBox(height: 20.h),

                      // Revenue Chart
                      RevenueChart(
                        title: "Profit",
                        stripColor: Colors.blueAccent,
                        chartData: chartData,
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
