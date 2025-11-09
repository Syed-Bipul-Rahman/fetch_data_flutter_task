import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/home_controller.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_content.dart';
import 'widgets/retry_widget.dart';
import 'widgets/shimmer_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HomeAppBar(),
      body: Obx(() {
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
    );
  }
}
