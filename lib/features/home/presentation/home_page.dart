import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'controllers/home_controller.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_content.dart';
import 'widgets/retry_widget.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/shimmer_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content with top padding for the fixed header area
          Padding(
            padding: EdgeInsets.only(top: statusBarHeight + 56.h),
            child: Obx(() {
              switch (controller.loadingState) {
                case LoadingState.initial:
                case LoadingState.loading:
                  return ShimmerWidgets.buildLoadingShimmer();

                case LoadingState.offline:
                case LoadingState.error:
                  return RetryWidget(
                    message: controller.errorMessage,
                    onRetry: controller.retry,
                    isOffline: controller.loadingState == LoadingState.offline,
                  );

                case LoadingState.loaded:
                  return HomeContent(controller: controller);
              }
            }),
          ),

          // Animated AppBar
          Obx(() {
            final showAppBar = controller.showAppBar;
            return AnimatedSlide(
              offset: showAppBar ? Offset.zero : const Offset(0, -1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: showAppBar ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  height: 56.h,
                  color: Colors.white,
                  child: const HomeAppBar(),
                ),
              ),
            );
          }),

          // Animated SearchBar Overlay
          Obx(() {
            final showAppBar = controller.showAppBar;
            return AnimatedSlide(
              offset: showAppBar ? const Offset(0, -1) : Offset.zero,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: showAppBar ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  padding: EdgeInsets.only(top: statusBarHeight),
                  height: statusBarHeight + 56.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: SearchBarWidget(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 4.h,
                    ),
                    showShadow: false,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
