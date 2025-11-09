import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarWidget extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final bool showShadow;

  const SearchBarWidget({super.key, this.padding, this.showShadow = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(16.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search food or restaurant here...',
            suffixIcon: const Icon(
              Icons.search_outlined,
              color: Color(0xff9b9b9b),
            ),
            filled: true,
            hintStyle: TextStyle(color: Color(0xff9f9f9f)),
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 12.h,
            ),
          ),
        ),
      ),
    );
  }
}
