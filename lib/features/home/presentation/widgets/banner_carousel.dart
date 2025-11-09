import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import '../../data/models/banner_model.dart';
import 'shimmer_widgets.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerModel> banners;

  const BannerCarousel({super.key, required this.banners});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late PageController _pageController;
  Timer? _timer;
  late int _currentPage;

  // Calculate a reasonable middle page for infinite scrolling
  // Using banner count * 1000 to provide enough pages for smooth infinite scrolling
  int get _initialPage => widget.banners.isEmpty ? 0 : widget.banners.length * 1000;
  int get _totalItemCount => widget.banners.isEmpty ? 0 : widget.banners.length * 2000;

  @override
  void initState() {
    super.initState();
    _currentPage = _initialPage;
    _pageController = PageController(
      viewportFraction: 0.75,
      initialPage: _initialPage,
    );
    _startAutoPlay();
  }

  void _startAutoPlay() {
    if (widget.banners.length <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _currentPage++;

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 130.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _totalItemCount,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final bannerIndex = index % widget.banners.length;
              final banner = widget.banners[bannerIndex];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: banner.imageFullUrl ?? '',
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        ShimmerWidgets.buildBannerShimmer(),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.h),
        _buildIndicators(),
      ],
    );
  }

  Widget _buildIndicators() {
    final activeIndex = _currentPage % widget.banners.length;

    return SizedBox(
      height: 12.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.banners.length,
          (index) => Container(
            width: 12.w,
            height: 12.h,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            alignment: Alignment.center,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: activeIndex == index ? 12.w : 8.w,
              height: activeIndex == index ? 12.h : 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activeIndex == index
                    ? AppColors.primary
                    : const Color(0xFFF8CCAD),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
