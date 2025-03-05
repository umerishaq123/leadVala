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

onBook(
  BuildContext context,
  Services service, {
  GestureTapCallback? addTap,
  GestureTapCallback? minusTap,
  ProviderModel? provider,
  bool isPackage = false,
  dynamic packageServiceId,
}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isGuest = preferences.getBool(session.isContinueAsGuest) ?? false;

  if (!isGuest) {
    print('call to card 1');
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Create a new cart item based on whether it's a package or a single service
    CartModel newCartItem = CartModel(
      isPackage: isPackage,
      serviceList: isPackage ? null : service,
      servicePackageList: isPackage
          ? ServicePackageModel(id: packageServiceId, services: [service])
          : null,
    );

    // Add the new cart item
    cartProvider.addToCart(newCartItem);

    // Explicitly update checkoutModel after adding an item
    cartProvider.updateCheckoutModel();

    log("Added to cart: ${newCartItem.serviceList ?? newCartItem.servicePackageList}");
    log("Checkout Model Updated: ${cartProvider.checkoutModel}");

    // Add the service to CheckoutModel's services list (checking for null or missing values)
    if (isPackage) {
      print('call to card 2');

      if (cartProvider.checkoutModel?.servicesPackage == null) {
        cartProvider.checkoutModel?.servicesPackage = [];
        print('call to card 3');
      }
      print('call to card 4');

      cartProvider.checkoutModel?.servicesPackage?.add(ServicesPackage(
          servicePackageId: packageServiceId,
          services: [
            PackageServices(
                servicePackageId: packageServiceId, serviceId: service.id)
          ]));
    } else {
      print('call to card 4');

      if (cartProvider.checkoutModel?.services == null) {
        print('call to card 4--');

        cartProvider.checkoutModel?.services = [];
      }

      // old code

      cartProvider.checkoutModel?.services?.add(
        SingleServices(
          providerId: provider?.id ?? -1, // Default to -1 if provider is null
          serviceId: service.id,
          servicePrice: service.price,
          addressId: provider?.addresses?.first.id ??
              -1, // Default to -1 if address is missing
          perServicemanCharge: 0.0,
          dateTime: DateTime.now().toString(),
          total: Total(total: service.price), // Set total here if needed
        ),
      );
      List<SingleServices>? services = cartProvider.checkoutModel?.services;
    }

//

    // Log to verify services have been added
    log("Services after addition: ${cartProvider.checkoutModel?.services ?? 'No services'}");
    log("ServicesPackage after addition: ${cartProvider.checkoutModel?.servicesPackage ?? 'No service packages'}");

    // Ensure checkoutModel is not null before navigating
    if (cartProvider.checkoutModel != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CartScreen()));
    } else {
      log("checkoutModel is still null after update!");
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
  if (url != null) {
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
  print('call to showingbooking status');
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BookingStatusDialog(
          bookingModel: bookingModel,
        );
      });
}
