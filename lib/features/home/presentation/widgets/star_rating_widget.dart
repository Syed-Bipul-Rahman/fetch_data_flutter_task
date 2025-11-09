import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import 'half_clipper.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;

  const StarRatingWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    final List<Widget> stars = [];

    // Calculate full stars, half star, and empty stars
    final fullStars = rating.floor();
    final hasHalfStar = (rating - fullStars) >= 0.5;

    // Add full stars
    for (int i = 0; i < fullStars && i < 5; i++) {
      stars.add(Icon(Icons.star, color: AppColors.primary, size: 15.sp));
    }

    // Add half star if needed
    if (hasHalfStar && fullStars < 5) {
      stars.add(
        Stack(
          children: [
            Icon(Icons.star, color: Colors.grey[300], size: 15.sp),
            ClipRect(
              clipper: HalfClipper(),
              child: Icon(Icons.star, color: AppColors.primary, size: 15.sp),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }
}
