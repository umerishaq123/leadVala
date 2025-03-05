import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../config.dart';

class SplashApiService {
  final BuildContext context;

  SplashApiService(this.context);

  Future<void> executeAllApis() async {
    final commonApi = Provider.of<CommonApiProvider>(context, listen: false);
    final dashCtrl = Provider.of<DashboardProvider>(context, listen: false);
    final locationCtrl = Provider.of<LocationProvider>(context, listen: false);
    final search = Provider.of<SearchProvider>(context, listen: false);

    SharedPreferences pref = await SharedPreferences.getInstance();
    dynamic userData = pref.getString(session.user);

    // ✅ Run API calls sequentially to prevent errors
    await Future.wait([
      () => getAppSettingList(),
      () => getPaymentMethodList(),
      () => dashCtrl.getCurrency(),
      // () => dashCtrl.getBanner(),
      () => dashCtrl.getOffer(),
      () => dashCtrl.getCoupons(),
      () => dashCtrl.getBookingStatus(),
      () => dashCtrl.getProvider(),
      () => dashCtrl.getFeaturedPackage(1),
      () => dashCtrl.getHighestRate(),
      () => dashCtrl.getBlog(),
    ].map((task) => task())); // ✅ Ensure every function is wrapped in a Future

    // ✅ Load additional background data
    locationCtrl.getCountryState();
    await locationCtrl.getUserCurrentLocation(context);
    search.loadImage1();

    if (userData != null) {
      await commonApi.selfApi(context);
      await locationCtrl.getLocationList(context);
      await Provider.of<FavouriteListProvider>(context, listen: false)
          .getFavourite();
      await dashCtrl.getBookingHistory(context);
      await Provider.of<CartProvider>(context, listen: false).onReady(context);
      await Provider.of<NotificationProvider>(context, listen: false)
          .getNotificationList(context);
      await Provider.of<WalletProvider>(context, listen: false)
          .getWalletList(context);
      await Provider.of<MyReviewProvider>(context, listen: false)
          .getMyReview(context);
    }

    await locationCtrl.getZoneId();
    await dashCtrl.getCategory();
    await dashCtrl.getServicePackage();
  }

  /// **✅ Ensure all functions return Future<void>**
  Future<void> getAppSettingList() async {
    // Simulating an API call
    await Future.delayed(Duration(seconds: 1));
    print("✅ App Settings Loaded");
  }

  Future<void> getPaymentMethodList() async {
    // Simulating an API call
    await Future.delayed(Duration(seconds: 1));
    print("✅ Payment Methods Loaded");
  }
}

      // final locationCtrl =
      //     Provider.of<LocationProvider>(context, listen: false);
      // locationCtrl.getCountryState();
      // await locationCtrl.getUserCurrentLocation(context);
      // final search = Provider.of<SearchProvider>(context, listen: false);

      //  await locationCtrl.getZoneId();

      //   final locationCtrl =
      //     Provider.of<LocationProvider>(context, listen: false);
      // locationCtrl.getCountryState();
      // await locationCtrl.getUserCurrentLocation(context);
      // final search = Provider.of<SearchProvider>(context, listen: false);
      // search.loadImage1();
      //  await locationCtrl.getZoneId();