import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/home_controller.dart';
import 'banner_carousel.dart';
import 'category_item.dart';
import 'food_campaign.dart';
import 'food_card.dart';
import 'restaurant_card.dart';
import 'search_bar_widget.dart';
import 'section_header.dart';

class HomeContent extends StatelessWidget {
  final HomeController controller;

  const HomeContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          // Search Bar
          SliverToBoxAdapter(
            child: SearchBarWidget(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            ),
          ),

          SliverToBoxAdapter(
            child: BannerCarousel(banners: controller.banners),
          ),

          // Categories Section
          if (controller.categories.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: SectionHeader(title: 'Categories', onViewAll: () {}),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    return CategoryItem(category: controller.categories[index]);
                  },
                ),
              ),
            ),
          ],

          // Popular Food Section
          if (controller.popularFoods.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Popular Food Nearby',
                onViewAll: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 229.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(right: 16.w, left: 16.w, bottom: 10),
                  itemCount: controller.popularFoods.length,
                  itemBuilder: (context, index) {
                    return FoodCard(product: controller.popularFoods[index]);
                  },
                ),
              ),
            ),
          ],

          // Food Campaigns Section
          if (controller.foodCampaigns.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: SectionHeader(title: 'Food Campaign', onViewAll: () {}),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 165.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(
                    right: 16.w,
                    bottom: 10.h,
                    left: 16.w,
                  ),
                  itemCount: controller.foodCampaigns.length,
                  itemBuilder: (context, index) {
                    return FoodCampaign(
                      product: controller.foodCampaigns[index],
                    );
                  },
                ),
              ),
            ),
          ],

          // Restaurants Section Header
          if (controller.restaurants.isNotEmpty)
            const SliverToBoxAdapter(
              child: SectionHeader(title: 'Restaurants'),
            ),

          // Restaurants List
          if (controller.restaurants.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return RestaurantCard(
                  restaurant: controller.restaurants[index],
                );
              }, childCount: controller.restaurants.length),
            ),

          // Loading More Indicator
          if (controller.isLoadingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),

          // Bottom Padding
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        ],
      ),
    );
  }
}
