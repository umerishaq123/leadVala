// import 'dart:developer';

// import 'package:leadvala/users_services.dart';
// import 'package:leadvala/users_services.dart';
// import 'package:leadvala/users_services.dart';
// import 'package:leadvala/users_services.dart';

// import '../../../config.dart';
// import '../../../users_services.dart';

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final dash = Provider.of<DashboardProvider>(context, listen: false);

    return StatefulWrapper(
      onInit: () => Future.delayed(
        const Duration(milliseconds: 100),
        () => Provider.of<HomeScreenProvider>(context, listen: false)
            .onAnimate(this),
      ),
      child: Consumer<HomeScreenProvider>(
        builder: (context, value, child) {
          return value.isSkeleton
              ? const HomeSkeleton()
              : RefreshIndicator(
                  onRefresh: () async => dash.onRefresh(context),
                  child: Scaffold(
                    appBar: AppBar(
                      leadingWidth: MediaQuery.of(context).size.width,
                      leading: HomeAppBar(location: street ?? ""),
                    ),
                    body: value.isEmptyLayout(context)
                        ? _buildHomeScreenBody(context)
                        : const CommonEmpty(),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildHomeScreenBody(BuildContext context) {
    return Consumer2<DashboardProvider, HomeScreenProvider>(
      builder: (context, dash, value, child) {
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            if (dash.bannerList.isNotEmpty)
              _buildBannerSection(dash, value), // ✅ Pass both arguments
            if (dash.couponList.isNotEmpty) _buildCouponsSection(dash),
            const HomeBody(),
            if (dash.highestRateList.isNotEmpty) const SizedBox(height: 25),
            if (dash.blogList.isNotEmpty) _buildBlogsSection(context, dash),
            const SizedBox(height: 50),
          ],
        );
      },
    );
  }

  Widget _buildBannerSection(DashboardProvider dash, HomeScreenProvider value) {
    print('${dash.bannerList.length}');
    return Column(
      children: [
        BannerLayout(
          bannerList: dash.bannerList,
          onPageChanged: (index, reason) => value.onSlideBanner(index),
          onTap: (type, id) => value.onBannerTap(context, type, id),
        ),
        // if (dash.bannerList.length > 1) ...[
        //   const SizedBox(height: 12),
        //   DotIndicator(list: dash.bannerList, selectedIndex: value.selectIndex),
        //   const SizedBox(height: 20),
        // ]
      ],
    );
  }

  Widget _buildCouponsSection(
    DashboardProvider dash,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingRowCommon(
          title: appFonts.coupons,
          isTextSize: true,
          onTap: () =>
              route.pushNamed(context, routeName.couponListScreen, arg: true),
        ).paddingSymmetric(horizontal: Insets.i20),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                dash.couponList.map((e) => HomeCouponLayout(data: e)).toList(),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildBlogsSection(BuildContext context, DashboardProvider dash) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingRowCommon(
          title: appFonts.latestBlog,
          isTextSize: true,
          onTap: () => route.pushNamed(context, routeName.latestBlogViewAll),
        ).paddingSymmetric(horizontal: Insets.i20),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: (dash.firstTwoBlogList.isNotEmpty
                    ? dash.firstTwoBlogList
                    : dash.blogList)
                .map((e) => LatestBlogLayout(data: e))
                .toList(),
          ).paddingOnly(left: Insets.i20),
        ),
      ],
    );
  }
}

// Widget _buildHomeScreenBody(
  //     BuildContext context, DashboardProvider dash, HomeScreenProvider value) {
  //   return ListView(
  //     padding: const EdgeInsets.symmetric(vertical: 10),
  //     children: [
  //       if (dash.bannerList.isNotEmpty) _buildBannerSection(dash, value),
  //       Text('////${dash.couponList.isNotEmpty}'),
  //       if (dash.couponList.isNotEmpty) _buildCouponsSection(dash),
  //       const HomeBody(),
  //       if (dash.highestRateList.isNotEmpty) const SizedBox(height: 25),
  //       if (dash.blogList.isNotEmpty) _buildBlogsSection(context, dash),
  //       const SizedBox(height: 50),
  //     ],
  //   );
  // }
