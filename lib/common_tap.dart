import 'dart:developer';
import 'dart:io';

import 'package:leadvala/common/extension/text_style_extensions.dart';
import 'package:leadvala/models/provider_model.dart';
import 'package:leadvala/models/service_model.dart';
import 'package:leadvala/packages_list.dart';
import 'package:leadvala/screens/app_pages_screens/pending_booking_screen/layouts/booking_status_dialog.dart';
import 'package:leadvala/screens/app_pages_screens/provider_details_screen/layouts/book_your_service_layout.dart';
import 'package:leadvala/widgets/alert_message_common.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';

import 'config.dart';

//
const mail = 'mailto:';
const call = 'tel:';
const googleMapLink = 'https://www.google.com/maps/search/?api=1&query=';
const wpLink = 'whatsapp://send?phone=';
bool isOpen = false;

onBook(context, Services service,
    {GestureTapCallback? addTap,
    minusTap,
    ProviderModel? provider,
    isPackage = false,
    packageServiceId}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isGuest = preferences.getBool(session.isContinueAsGuest) ?? false;

  if (isGuest == false) {
    log("ISOPEN :$isOpen");
   if(isOpen == false){
     showModalBottomSheet(
         isScrollControlled: true,
         context: context,
         builder: (context1) {
           return StatefulBuilder(builder: (context2, setState) {
             isOpen =true;
             setState;
             log("ISOPEN 1:$isOpen");
             return Consumer6<
                 ServicesDetailsProvider,
                 DashboardProvider,
                 CategoriesDetailsProvider,
                 CartProvider,
                 ProviderDetailsProvider,
                 SelectServicemanProvider>(
                 builder: (context3, value, dash, category, cart, providerDetail,
                     selectServiceMan, child) {

                   return BookYourServiceLayout(
                       price: service.serviceRate,
                       style: appCss.dmDenseSemiBold18
                           .textColor(appColor(context).primary),
                       //providerModel: provider ?? service.user,
                       requiredServiceMan:
                       (service.selectedRequiredServiceMan ??1),
                       addTap: addTap,
                       minusTap: minusTap,
                       packageServiceId: packageServiceId,
                       isPackage: isPackage,
                       services: service);
                 });
           });
         }).then((value) {
       isOpen = false;
       log("IHS L$isOpen");
     });
   }
  } else {
    route.pushAndRemoveUntil(context);
  }
}

mailTap(context, String url) {
  if (url.isNotEmpty) {
    commonUrlTap(context, '$mail$url',
        launchMode: LaunchMode.externalApplication);
  }
}

commonUrlTap(context, String address,
    {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    snackBarMessengers(context);
  });
}

launchCall(context, String? url) {
  if(url != null) {
    if (Platform.isIOS) {
      commonUrlTap(context, '$call//$url',
          launchMode: LaunchMode.externalApplication);
    } else {
      commonUrlTap(context, '$call$url',
          launchMode: LaunchMode.externalApplication);
    }
  }
}

launchMap(context, String? url) {
  commonUrlTap(context, googleMapLink + url!,
      launchMode: LaunchMode.externalApplication);
}

wpTap(context, String? url) {
  commonUrlTap(context, wpLink + url!,
      launchMode: LaunchMode.externalApplication);
}

showBookingStatus(context, BookingModel? bookingModel) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BookingStatusDialog(
          bookingModel: bookingModel,
        );
      });
}
