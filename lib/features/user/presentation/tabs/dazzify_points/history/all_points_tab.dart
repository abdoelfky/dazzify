import 'package:dazzify/features/user/presentation/widgets/history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllPointsTab extends StatelessWidget {
  const AllPointsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16).r,
      child: ListView.separated(
        itemBuilder: (context, index) => const HistoryItem(
          dateTime: "Feb 12, 2024",
          pointsCount: "+200",
          isSpent: true,
        ),
        separatorBuilder: (context, index) => SizedBox(height: 16.r),
        itemCount: 5,
      ),
    );
  }
}
