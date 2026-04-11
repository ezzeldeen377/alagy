import 'package:alagy/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticsChart extends StatelessWidget {
  final int pendingCount;
  final int approvedCount;
  final int rejectedCount;

  const StatisticsChart({
    super.key,
    required this.pendingCount,
    required this.approvedCount,
    required this.rejectedCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = pendingCount + approvedCount + rejectedCount;
    
    if (total == 0) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Container(
          height: 200.h,
          padding: EdgeInsets.all(20.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pie_chart_outline,
                  size: 48.sp,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16.h),
                Text(
                  context.l10n.noDataAvailable,
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final pendingPercentage = (pendingCount / total) * 100;
    final approvedPercentage = (approvedCount / total) * 100;
    final rejectedPercentage = (rejectedCount / total) * 100;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Simple Bar Chart
            Container(
              height: 120.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBar(
                    context.l10n.pending,
                    pendingCount,
                    pendingPercentage,
                    Colors.amber,
                    total,
                  ),
                  _buildBar(
                    context.l10n.approved,
                    approvedCount,
                    approvedPercentage,
                    Colors.green,
                    total,
                  ),
                  _buildBar(
                    context.l10n.rejected,
                    rejectedCount,
                    rejectedPercentage,
                    Colors.red,
                    total,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(context.l10n.pending, Colors.amber, pendingCount),
                _buildLegendItem(context.l10n.approved, Colors.green, approvedCount),
                _buildLegendItem(context.l10n.rejected, Colors.red, rejectedCount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(
    String label,
    int count,
    double percentage,
    Color color,
    int total,
  ) {
    final maxHeight = 80.h;
    final barHeight = total > 0 ? (count / total) * maxHeight : 0.0;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 40.w,
          height: barHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(4.r),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}