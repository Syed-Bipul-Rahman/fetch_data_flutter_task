import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/product_model.dart';
import 'product_image_with_badge.dart';
import 'star_rating_widget.dart';
import 'price_display_widget.dart';

class FoodCampaign extends StatelessWidget {
  final ProductModel product;

  const FoodCampaign({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.w,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side - Product Image with Discount Badge
              Align(
                alignment: Alignment.center,
                child: ProductImageWithBadge(
                  imageUrl: product.imageFullUrl,
                  discount: product.discount,
                  discountType: product.discountType,
                ),
              ),

              // Right side - Product Information
              SizedBox(
                width: 120.w,
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Product Name
                      Text(
                        product.name ?? 'Unknown Product',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000743),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),

                      // Restaurant Name
                      if (product.restaurantName != null)
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                product.restaurantName!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF868686),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                      if (product.restaurantName != null) SizedBox(height: 4.h),

                      // Rating
                      StarRatingWidget(rating: product.rating ?? 0.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // + Icon in bottom right corner
          Positioned(
            bottom: 8.h,
            right: 8.w,
            child: Row(
              children: [
                PriceDisplayWidget(
                  originalPrice: product.price,
                  discount: product.discount,
                  discountType: product.discountType,
                ),
                Icon(Icons.add, color: const Color(0xFF000743), size: 30.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
