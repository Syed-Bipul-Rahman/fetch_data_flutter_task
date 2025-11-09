import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'diagonal_strikethrough_painter.dart';

class PriceDisplayWidget extends StatelessWidget {
  final double? originalPrice;
  final double? discount;
  final String? discountType;

  const PriceDisplayWidget({
    super.key,
    this.originalPrice,
    this.discount,
    this.discountType,
  });

  double _calculateFinalPrice() {
    if (originalPrice == null) return 0.0;
    if (discount == null || discount == 0) {
      return originalPrice!;
    }

    if (discountType == 'percent') {
      // Calculate percentage discount
      final discountAmount = (originalPrice! * discount!) / 100;
      return originalPrice! - discountAmount;
    } else {
      // Fixed amount discount
      return originalPrice! - discount!;
    }
  }

  bool _hasDiscount() {
    return discount != null && discount! > 0;
  }

  String _formatPrice(double price) {
    // Check if the price has decimal part
    if (price % 1 == 0) {
      // No decimal part, return without .00
      return price.toInt().toString();
    } else {
      // Has decimal part, return with 2 decimal places
      return price.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Final Price (after discount)
        Text(
          '\$${_formatPrice(_calculateFinalPrice())}',
          style: TextStyle(
            color: const Color(0xFF000743),
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Original Price with Strikethrough (only show if there's a discount)
        if (_hasDiscount()) ...[
          SizedBox(width: 6.w),
          Stack(
            alignment: Alignment.center,
            children: [
              // Original price text
              Text(
                '\$${originalPrice != null ? _formatPrice(originalPrice!) : '0'}',
                style: TextStyle(
                  color: const Color(0xFF868686),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Diagonal strikethrough line
              Positioned.fill(
                child: CustomPaint(
                  painter: DiagonalStrikeThroughPainter(),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
