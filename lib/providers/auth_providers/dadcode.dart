 /* this code for splech provider screen 
  onReady(TickerProvider sync, context) async {
    bool isAvailable = await isNetworkConnection();
    if (!isAvailable) {
      route.pushReplacementNamed(context, routeName.noInternet);
      return;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();
    dynamic userData = pref.getString(session.user);
    print('userdata:::: check to the user $userData');

    // final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
    // final dashCtrl = Provider.of<DashboardProvider>(context, listen: false);
    // final locationCtrl = Provider.of<LocationProvider>(context, listen: false);
    // final search = Provider.of<SearchProvider>(context, listen: false);

    bool isAuthenticate = false;
    // if (userData != null) {
    //   isAuthenticate = await commonApi.checkForAuthenticate();
    // }
    log("isAuthenticate :$isAuthenticate");

    /// **✅ Initialize Animation Controllers**
    controller =
        AnimationController(vsync: sync, duration: const Duration(seconds: 2))
          ..addListener(() => notifyListeners())
          ..forward();

    animation = CurvedAnimation(parent: controller!, curve: Curves.easeInOut);

    controller2 =
        AnimationController(vsync: sync, duration: const Duration(seconds: 2))
          ..forward();
    animation2 = CurvedAnimation(parent: controller2!, curve: Curves.easeInOut);

    controllerSlide =
        AnimationController(vsync: sync, duration: const Duration(seconds: 2))
          ..forward();
    offsetAnimation =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
            .animate(controllerSlide!);

    controller3 =
        AnimationController(duration: const Duration(seconds: 2), vsync: sync)
          ..repeat();
    animation3 = CurvedAnimation(parent: controller3!, curve: Curves.easeInOut);

    popUpAnimationController =
        AnimationController(vsync: sync, duration: const Duration(seconds: 2))
          ..forward();

    /// **✅ Start API Calls in Parallel (Without Blocking UI)**
    Future<void> loadAPIs() async {
      List<Future<void>> apiCalls = [
        getAppSettingList(context),
        getPaymentMethodList(context),
        // dashCtrl.getCurrency(),
        // dashCtrl.getBanner(),
        // dashCtrl.getOffer(),
        // dashCtrl.getCoupons(),
        // dashCtrl.getBookingStatus(),
        // dashCtrl.getProvider(),
        // dashCtrl.getFeaturedPackage(1),
        // dashCtrl.getHighestRate(),
        // dashCtrl.getBlog(),
      ];

      for (var api in apiCalls) {
        try {
          await api;
        } catch (e) {
          print("⚠️ API Error: $e");
        }
      }
    }

    // ✅ Start API calls in the background
    loadAPIs();

    /// **✅ Load Additional Data Without Blocking UI**
    // locationCtrl.getCountryState();
    // await locationCtrl.getUserCurrentLocation(context);
    // search.loadImage1();

    // if (userData != null) {
    //   pref.remove(session.isContinueAsGuest);
    //   await commonApi.selfApi(context);
    //   await locationCtrl.getLocationList(context);

    //   Provider.of<FavouriteListProvider>(context, listen: false).getFavourite();
    //   dashCtrl.getBookingHistory(context);
    //   Provider.of<CartProvider>(context, listen: false).onReady(context);
    //   Provider.of<NotificationProvider>(context, listen: false)
    //       .getNotificationList(context);
    //   Provider.of<WalletProvider>(context, listen: false)
    //       .getWalletList(context);
    //   Provider.of<MyReviewProvider>(context, listen: false)
    //       .getMyReview(context);
    // }

    /// **✅ Wait for Animation to Finish Before Transitioning**
    await Future.delayed(const Duration(seconds: 3));

    /// **✅ Ensure All APIs Finish Before Navigating**
    await loadAPIs();

    // await locationCtrl.getZoneId();
    bool? isIntro = pref.getBool(session.isIntro) ?? false;

    log("userData :: $userData");

    // dashCtrl.getCategory();
    // dashCtrl.getServicePackage();

    // if (isIntro) {
    //   if (userData != null) {
    //     if (isAuthenticate) {
    //       route.pushReplacementNamed(context, routeName.dashboard);
    //     } else {
    //       _logoutUser(pref);
    //       route.pushReplacementNamed(context, routeName.login);
    //     }
    //   } else {
    //     route.pushReplacementNamed(context, routeName.login);
    //   }
    // } else {
    //   route.pushReplacementNamed(context, routeName.onBoarding);
    // }
  }

  /// **🛑 Helper Function for Logout**
  void _logoutUser(SharedPreferences pref) {
    userModel = null;
    setPrimaryAddress = null;
    userPrimaryAddress = null;
    pref.remove(session.user);
    pref.remove(session.accessToken);
    pref.remove(session.isContinueAsGuest);
    pref.remove(session.isLogin);
    pref.remove(session.cart);
    pref.remove(session.recentSearch);

    final auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      FirebaseAuth.instance.signOut();
      GoogleSignIn().disconnect();
    }
  }
  */

/*

await Future.delayed(const Duration(seconds: 1));
    controller2!.forward();
    popUpAnimationController!.forward();

    /// **✅ Load Initial API Data**
// ✅ Execute Functions in Order
    List<Future<void> Function()> tasks = [
      () => getAppSettingList(context),
      () => getPaymentMethodList(context),
      () => dashCtrl.getCurrency(),
      () => dashCtrl.getBanner(),
      () => dashCtrl.getOffer(),
      () => dashCtrl.getCoupons(),
      () => dashCtrl.getBookingStatus(),
      () => dashCtrl.getProvider(),
      () => dashCtrl.getFeaturedPackage(1),
      () => dashCtrl.getHighestRate(),
      () => dashCtrl.getBlog(),
    ];

  onReady(TickerProvider sync, context) async {
    bool isAvailable = await isNetworkConnection();
    if (isAvailable) {
      getAppSettingList(context);
      getPaymentMethodList(context);
      SharedPreferences pref = await SharedPreferences.getInstance();
      dynamic userData = pref.getString(session.user);
      print('userdata:::: check to the user ${userData}');
      final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
      bool isAuthenticate = false;
      if (userData != null) {
        isAuthenticate = await commonApi.checkForAuthenticate();
      }

      log("isAuthenticate :$isAuthenticate");
      controller = controller =
          AnimationController(vsync: sync, duration: const Duration(seconds: 2))
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                controller!.stop();
                notifyListeners();
              }
              if (status == AnimationStatus.dismissed) {
                controller!.forward();
                notifyListeners();
              }
            });

      animation = CurvedAnimation(parent: controller!, curve: Curves.easeIn);
      controller!.forward();

      controller2 = AnimationController(
          vsync: sync, duration: const Duration(seconds: 2));
      animation2 = CurvedAnimation(parent: controller2!, curve: Curves.easeIn);

      if (controller2!.status == AnimationStatus.forward ||
          controller2!.status == AnimationStatus.completed) {
        controller2!.reverse();
        notifyListeners();
      } else if (controller2!.status == AnimationStatus.dismissed) {
        Timer(const Duration(seconds: 2), () {
          controller2!.forward();
          notifyListeners();
        });
      }

      controllerSlide = AnimationController(
          vsync: sync, duration: const Duration(seconds: 2));

      offsetAnimation =
          Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .animate(controllerSlide!);

      controller3 =
          AnimationController(duration: const Duration(seconds: 2), vsync: sync)
            ..repeat();
      animation3 = CurvedAnimation(parent: controller3!, curve: Curves.easeIn);

      popUpAnimationController = AnimationController(
          vsync: sync, duration: const Duration(seconds: 2));

      Timer(const Duration(seconds: 3), () {
        popUpAnimationController!.forward();
        notifyListeners();
      });

      log("ANIMATION CON ${popUpAnimationController!.status}");
      final dashCtrl = Provider.of<DashboardProvider>(context, listen: false);
      print('time to call functions ${dashCtrl.getBanner()}');
      dashCtrl.getCurrency();
      dashCtrl.getBanner();
      dashCtrl.getOffer();
      dashCtrl.getCoupons();
      dashCtrl.getBookingStatus();
      dashCtrl.getProvider();

      dashCtrl.getFeaturedPackage(1);
      dashCtrl.getHighestRate();
      dashCtrl.getBlog();
      final locationCtrl =
          Provider.of<LocationProvider>(context, listen: false);
      locationCtrl.getCountryState();
      await locationCtrl.getUserCurrentLocation(context);
      final search = Provider.of<SearchProvider>(context, listen: false);
      search.loadImage1();

      if (userData != null) {
        pref.remove(session.isContinueAsGuest);
        final commonApi =
            Provider.of<CommonApiProvider>(context, listen: false);
        await commonApi.selfApi(context);

        await locationCtrl.getLocationList(context);

        final favCtrl =
            Provider.of<FavouriteListProvider>(context, listen: false);
        favCtrl.getFavourite();
        dashCtrl.getBookingHistory(context);
        //dashCtrl.getServicePackage();
        final cartCtrl = Provider.of<CartProvider>(context, listen: false);
        cartCtrl.onReady(context);
        final notifyCtrl =
            Provider.of<NotificationProvider>(context, listen: false);
        notifyCtrl.getNotificationList(context);

        final wallet = Provider.of<WalletProvider>(context, listen: false);
        wallet.getWalletList(context);
        final review = Provider.of<MyReviewProvider>(context, listen: false);
        review.getMyReview(context);
      }

      Timer(const Duration(seconds: 5), () async {
        await locationCtrl.getZoneId();
        bool? isIntro = pref.getBool(session.isIntro) ?? false;

        log("userData :: $userData");

        Provider.of<SplashProvider>(context, listen: false).dispose();
        onDispose();

        dashCtrl.getCategory();
        dashCtrl.getServicePackage();
        log("userData :: 1$userData");
        if (isIntro) {
          if (userData != null) {
            if (isAuthenticate) {
              route.pushReplacementNamed(context, routeName.dashboard);
            } else {
              userModel = null;
              setPrimaryAddress = null;
              userPrimaryAddress = null;
              final dash =
                  Provider.of<DashboardProvider>(context, listen: false);
              dash.selectIndex = 0;
              dash.notifyListeners();
              pref.remove(session.user);
              pref.remove(session.accessToken);
              pref.remove(session.isContinueAsGuest);
              pref.remove(session.isLogin);
              pref.remove(session.cart);
              pref.remove(session.recentSearch);

              final auth = FirebaseAuth.instance.currentUser;
              if (auth != null) {
                FirebaseAuth.instance.signOut();
                GoogleSignIn().disconnect();
              }

              route.pushReplacementNamed(context, routeName.login);
            }
          } else {
            route.pushReplacementNamed(context, routeName.login);
          }
        } else {
          route.pushReplacementNamed(context, routeName.onBoarding);
        }
      });
    } else {
      onDispose();
      Provider.of<SplashProvider>(context, listen: false).dispose();
      route.pushReplacementNamed(context, routeName.noInternet);
    }
  }

*/

/* this code for on redmi animation functuion  

onReady(TickerProvider sync, context) async {
    bool isAvailable = await isNetworkConnection();
    if (isAvailable) {
      // getAppSettingList(context);
      // getPaymentMethodList(context);
      // SharedPreferences pref = await SharedPreferences.getInstance();
      // dynamic userData = pref.getString(session.user);
      // print('userdata:::: check to the user ${userData}');
      // final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
      // bool isAuthenticate = false;
      // if (userData != null) {
      //   isAuthenticate = await commonApi.checkForAuthenticate();
      // }

      // log("isAuthenticate :$isAuthenticate");
      controller = controller =
          AnimationController(vsync: sync, duration: const Duration(seconds: 2))
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                controller!.stop();
                notifyListeners();
              }
              if (status == AnimationStatus.dismissed) {
                controller!.forward();
                notifyListeners();
              }
            });

      animation = CurvedAnimation(parent: controller!, curve: Curves.easeIn);
      controller!.forward();

      controller2 = AnimationController(
          vsync: sync, duration: const Duration(seconds: 2));
      animation2 = CurvedAnimation(parent: controller2!, curve: Curves.easeIn);

      if (controller2!.status == AnimationStatus.forward ||
          controller2!.status == AnimationStatus.completed) {
        controller2!.reverse();
        notifyListeners();
      } else if (controller2!.status == AnimationStatus.dismissed) {
        Timer(const Duration(seconds: 2), () {
          controller2!.forward();
          notifyListeners();
        });
      }

      controllerSlide = AnimationController(
          vsync: sync, duration: const Duration(seconds: 2));

      offsetAnimation =
          Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .animate(controllerSlide!);

      controller3 =
          AnimationController(duration: const Duration(seconds: 2), vsync: sync)
            ..repeat();
      animation3 = CurvedAnimation(parent: controller3!, curve: Curves.easeIn);

      popUpAnimationController = AnimationController(
          vsync: sync, duration: const Duration(seconds: 2));

      Timer(const Duration(seconds: 3), () {
        popUpAnimationController!.forward();
        notifyListeners();
      });

      log("ANIMATION CON ${popUpAnimationController!.status}");
      // final dashCtrl = Provider.of<DashboardProvider>(context, listen: false);
      // print('time to call functions ${dashCtrl.getBanner()}');
      // dashCtrl.getCurrency();
      // dashCtrl.getBanner();
      // dashCtrl.getOffer();
      // dashCtrl.getCoupons();
      // dashCtrl.getBookingStatus();
      // dashCtrl.getProvider();

      // dashCtrl.getFeaturedPackage(1);
      // dashCtrl.getHighestRate();
      // dashCtrl.getBlog();
      final locationCtrl =
          Provider.of<LocationProvider>(context, listen: false);
      locationCtrl.getCountryState();
      await locationCtrl.getUserCurrentLocation(context);
      final search = Provider.of<SearchProvider>(context, listen: false);
      search.loadImage1();

      // if (userData != null) {
      //   pref.remove(session.isContinueAsGuest);
      //   final commonApi =
      //       Provider.of<CommonApiProvider>(context, listen: false);
      //   await commonApi.selfApi(context);

      //   await locationCtrl.getLocationList(context);

      //   final favCtrl =
      //       Provider.of<FavouriteListProvider>(context, listen: false);
      //   favCtrl.getFavourite();
      //   dashCtrl.getBookingHistory(context);
      //   // dashCtrl.getServicePackage();
      //   final cartCtrl = Provider.of<CartProvider>(context, listen: false);
      //   cartCtrl.onReady(context);
      //   final notifyCtrl =
      //       Provider.of<NotificationProvider>(context, listen: false);
      //   notifyCtrl.getNotificationList(context);

      //   final wallet = Provider.of<WalletProvider>(context, listen: false);
      //   wallet.getWalletList(context);
      //   final review = Provider.of<MyReviewProvider>(context, listen: false);
      //   review.getMyReview(context);
      // }

      Timer(const Duration(seconds: 5), () async {
        await locationCtrl.getZoneId();
        // bool? isIntro = pref.getBool(session.isIntro) ?? false;

        // log("userData :: $userData");

        Provider.of<SplashProvider>(context, listen: false).dispose();
        onDispose();

        // dashCtrl.getCategory();
        // dashCtrl.getServicePackage();
        // log("userData :: 1$userData");
        // if (isIntro) {
        //   if (userData != null) {
        //     if (isAuthenticate) {
        //       route.pushReplacementNamed(context, routeName.dashboard);
        //     } else {
        //       userModel = null;
        //       setPrimaryAddress = null;
        //       userPrimaryAddress = null;
        //       final dash =
        //           Provider.of<DashboardProvider>(context, listen: false);
        //       dash.selectIndex = 0;
        //       dash.notifyListeners();
        //       pref.remove(session.user);
        //       pref.remove(session.accessToken);
        //       pref.remove(session.isContinueAsGuest);
        //       pref.remove(session.isLogin);
        //       pref.remove(session.cart);
        //       pref.remove(session.recentSearch);

        //       final auth = FirebaseAuth.instance.currentUser;
        //       if (auth != null) {
        //         FirebaseAuth.instance.signOut();
        //         GoogleSignIn().disconnect();
        //       }

        //       route.pushReplacementNamed(context, routeName.login);
        //     }
        //   } else {
        //     route.pushReplacementNamed(context, routeName.login);
        //   }
        // } else {
        //   route.pushReplacementNamed(context, routeName.onBoarding);
        // }
      });
    } else {
      onDispose();
      Provider.of<SplashProvider>(context, listen: false).dispose();
      route.pushReplacementNamed(context, routeName.noInternet);
    }
  }




*/



/* dad code home screen 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context3, dash, child) {
        return Consumer<HomeScreenProvider>(
          builder: (context1, value, child) {
            return Consumer<LocationProvider>(
              builder: (context2, locationCtrl, child) {
                return StatefulWrapper(
                  onInit: () => Future.delayed(
                      const Duration(milliseconds: 100),
                      () => value.onAnimate(this)),
                  child: value.isSkeleton
                      ? const HomeSkeleton()
                      : RefreshIndicator(
                          onRefresh: () async {
                            return dash.onRefresh(context);
                          },
                          child: Scaffold(
                            appBar: AppBar(
                                leadingWidth: MediaQuery.of(context).size.width,
                                leading: HomeAppBar(location: street ?? "")),
                            body: !value.isEmptyLayout(context)
                                ? const CommonEmpty()
                                : ListView(
                                    children: [
                                      if (dash.bannerList.isNotEmpty)
                                        BannerLayout(
                                            bannerList: dash.bannerList,
                                            onPageChanged: (index, reason) =>
                                                value.onSlideBanner(index),
                                            onTap: (type, id) =>
                                                value.onBannerTap(
                                                    context, type, id)),
                                      if (dash.bannerList.length > 1)
                                        const VSpace(Sizes.s12),
                                      if (dash.bannerList.length > 1)
                                        DotIndicator(
                                            list: dash.bannerList,
                                            selectedIndex: value.selectIndex),
                                      const VSpace(Sizes.s20),
                                      if (dash.couponList.isNotEmpty)
                                        HeadingRowCommon(
                                            title: appFonts.coupons,
                                            isTextSize: true,
                                            onTap: () => route.pushNamed(
                                                context,
                                                routeName.couponListScreen,
                                                arg: true)).paddingSymmetric(
                                            horizontal: Insets.i20),
                                      if (dash.couponList.isNotEmpty)
                                        const VSpace(Sizes.s15),
                                      if (dash.couponList.isNotEmpty)
                                        SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                                children: dash.couponList
                                                    .asMap()
                                                    .entries
                                                    .map((e) =>
                                                        HomeCouponLayout(
                                                            data: e.value))
                                                    .toList())),
                                      VSpace(dash.couponList.isNotEmpty
                                          ? Sizes.s25
                                          : Sizes.s15),
                                      const HomeBody(),
                                      if (dash.firstTwoHighRateList
                                              .isNotEmpty ||
                                          dash.highestRateList.isNotEmpty)
                                        const VSpace(Sizes.s25),
                                      if (dash.blogList.isNotEmpty)
                                        HeadingRowCommon(
                                          title: appFonts.latestBlog,
                                          isTextSize: true,
                                          onTap: () => route.pushNamed(context,
                                              routeName.latestBlogViewAll),
                                        ).paddingSymmetric(
                                            horizontal: Insets.i20),
                                      SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: dash.firstTwoBlogList.isNotEmpty
                                              ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: dash
                                                          .firstTwoBlogList
                                                          .asMap()
                                                          .entries
                                                          .map((e) => LatestBlogLayout(
                                                              data: e.value))
                                                          .toList())
                                                  .paddingOnly(left: Insets.i20)
                                              : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: dash.blogList
                                                          .asMap()
                                                          .entries
                                                          .map((e) =>
                                                              LatestBlogLayout(
                                                                  data: e.value))
                                                          .toList())
                                                  .paddingOnly(left: Insets.i20)),
                                      const VSpace(Sizes.s50),
                                    ],
                                  ),
                          ),
                        ),
                );
              },
            );
          },
        );
      },
    );
  }
}


*/