import 'dart:developer';

import 'package:leadvala/config.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(builder: (context1, value, child) {
      print('chek out of payment scren value ${value.scrollController}');

      final commonApiProvider = Provider.of<CommonApiProvider>(context);
      final userModel = commonApiProvider.userModel;

      double walletBalance =
          double.tryParse(userModel?.wallet?.balance?.toString() ?? "0.0") ??
              0.0;
      double totalAmount = value.checkoutModel?.total?.total ?? 0.0;

      log("💰 Wallet Balance: $walletBalance | 🛒 Total Amount: $totalAmount");

      return LoadingComponent(
        child: StatefulWrapper(
            onInit: () async {
              await Future.delayed(Durations.short3);

              await value.getUserDetail(
                  context); // Ensure user details & payments are loaded
            },
            child: Scaffold(
                appBar: AppBarCommon(title: appFonts.payment),
                body: Stack(alignment: Alignment.bottomCenter, children: [
                  ListView(controller: value.scrollController, children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language(context, appFonts.selectMethod),
                                style: appCss.dmDenseSemiBold14
                                    .textColor(appColor(context).lightText))
                            .paddingSymmetric(horizontal: Insets.i20),
                        const VSpace(Sizes.s5),
                        Consumer<PaymentProvider>(
                          builder: (context, value, child) {
                            print(
                                "🔄 UI Updated - Selected Payment Method: ${value.selectedPaymentMethod}");

                            return Column(
                              children: [
                                if (walletBalance > 0 &&
                                    walletBalance >= totalAmount)
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      print('✅ Wallet Option Pressed!');
                                      value.onSelectPaymentMethod(-1, "wallet");
                                    },
                                    child: const WalletOptionSelection()
                                        .paddingSymmetric(
                                            horizontal: Insets.i20),
                                  ),
                                ...paymentMethods
                                    .where((element) => element.status == true)
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map((e) => PaymentMethodLayout(
                                        index: e.key,
                                        data: e.value,
                                        selectIndex: value.selectIndex,
                                        onTap: () {
                                          value.onSelectPaymentMethod(
                                              e.key, e.value.slug.toString());
                                        }))
                                    .toList(),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    const VSpace(Sizes.s100)
                  ]),
                  AnimatedBuilder(
                      animation: value.scrollController,
                      builder: (BuildContext context, Widget? child) {
                        return AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            height: 70,
                            child: child);
                      },
                      child: ButtonCommon(
                              title: appFonts.continues,
                              margin: Sizes.s20,
                              onTap: () {
                                print('showing booking idsss ${value.method}');
                                value.addToCartOrBooking(context);
                              })
                          .paddingOnly(bottom: Insets.i20)
                          .backgroundColor(appColor(context).whiteBg))
                ]))),
      );
    });
  }
}



// print(
                                //     'button title ${value.addToCartOrBooking(context)}');
                                // print(
                                //     'button mmm ${value.paymentList.first.name}');
                                // print(
                                //     'button mmm ${value.checkoutModel!.services!.first.serviceId}');
                                // print(
                                //     'button mmm1 ${value.checkoutModel!.services!.first.dateTime}');
                                // print(
                                //     'button mmm2 ${value.checkoutModel!.services!.first.total!.totalServicemen}');
                                // print(
                                //     'button mmm3 ${value.checkoutModel!.services!.first.total}');
                                // print(
                                //     'button mmm4 ${value.checkoutModel!.services!.first.serviceId}');
//  chnage to the part
// Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(language(context, appFonts.selectMethod),
//               style: appCss.dmDenseSemiBold14
//                   .textColor(appColor(context).lightText))
//           .paddingSymmetric(horizontal: Insets.i20),
//       const VSpace(Sizes.s5),
//       if (value.bookingId == 0)
//         // commant for g

//         // if (userModel!.wallet != null &&
//         //     userModel!.wallet!.balance! >
//         //         (value.checkoutModel != null
//         //             ? value.checkoutModel!.total!.total ??
//         //                 0.0
//         //             : 0.0))

//         const WalletOptionSelection()
//             .paddingSymmetric(horizontal: Insets.i20),
//       ...paymentMethods
//           .where((element) => element.status == true)
//           .toList()
//           .asMap()
//           .entries
//           .map((e) => PaymentMethodLayout(
//               index: e.key,
//               data: e.value,
//               selectIndex: value.selectIndex,
//               onTap: () => value.onSelectPaymentMethod(
//                   e.key, e.value.slug)))
//     ]),


/*22-03

 if (value.bookingId == 0)

                        if (userModel?.wallet?.balance != null &&
                            userModel!.wallet!.balance! >
                                0 && // Wallet balance should not be zero
                            userModel!.wallet!.balance! >=
                                ((value.checkoutModel?.total?.total) ?? 0.0))
                          const WalletOptionSelection()
                              .paddingSymmetric(horizontal: Insets.i20),

                        if (walletBalance > 0 && walletBalance >= totalAmount)
                          GestureDetector(
                            behavior: HitTestBehavior
                                .opaque, // Ensures tap is detected
                            onTap: () {
                              print('✅ Wallet Option Tapped!');
                              value.onSelectPaymentMethod(-1, "wallet");

                              log("✅ Wallet option selected! New method: ${value.selectedPaymentMethod}");
                            },
                            child: Container(
                              color: Colors.transparent, // Ensure it's tappable
                              child: WalletOptionSelection()
                                  .paddingSymmetric(horizontal: Insets.i20),
                            ),
                          ),

                        ...paymentMethods
                            .where((element) => element.status == true)
                            .toList()
                            .asMap()
                            .entries
                            .map((e) => PaymentMethodLayout(
                                index: e.key,
                                data: e.value,
                                selectIndex: value.selectIndex,
                                onTap: () {
                                  print(
                                      'showing value of this time??/1${e.value}');
                                  print(
                                      'showing value of this time??/2${value.selectIndex}');
                                  value.onSelectPaymentMethod(
                                      e.key, e.value.slug.toString());

                                  // value.onSelectPaymentMethod(
                                  //     e.key, e.value.slug);
                                }))
                            .toList(),
*/
