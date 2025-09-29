import 'package:absensi_app/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEvent extends StatelessWidget {
  const ShimmerEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.gray.withValues(alpha: 0.3),
          highlightColor: AppColors.gray.withValues(alpha: 0.1),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.gray),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 200, width: double.infinity, color: Colors.white),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(height: 16, width: 120, color: Colors.white),
                    Container(height: 16, width: 80, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
