import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';

class ProductImageWithBadge extends StatelessWidget {
  final String? imageUrl;
  final double? discount;
  final String? discountType;

  const ProductImageWithBadge({
    super.key,
    this.imageUrl,
    this.discount,
    this.discountType,
  });

  String _getDiscountText() {
    if (discount == null || discount == 0) return '';
    if (discountType == 'percent') {
      return '${discount?.toInt()}% off';
    } else {
      return '\$${discount?.toInt()} off';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: imageUrl ?? '',
              height: 120.h,
              width: 120.w,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 140.h,
                  width: 120.w,
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 140.h,
                width: 120.w,
                color: Colors.grey[200],
                child: const Icon(
                  Icons.fastfood,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        // Discount Badge Overlay
        if (discount != null && discount! > 0)
          Positioned(
            top: 32.h,
            left: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 8.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.r),
                  bottomRight: Radius.circular(8.r),
                ),
              ),
              child: Text(
                _getDiscountText(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
