import 'dart:developer';

import '../../../../config.dart';

// import '../config.dart';

class BillcopyClass extends StatelessWidget {
  BillcopyClass({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<CartProvider>(context, listen: true);

    print(
        '++++++cart++++${value.cartList.map((e) => e.serviceList?.serviceRate).toList()}');

    double currencyValue = currency(context).currencyVal;

    // ✅ Iterate over all cart items instead of using `.first`
    double subtotal = value.cartList.fold(
      0.0,
      (sum, item) => sum + (item.serviceList?.serviceRate ?? 0.0),
    );

    print('Currency value +++++${currencyValue}');
    print('Subtotal +++++${subtotal}');

    double allaboutTotal = currencyValue * subtotal;
    double gstRate = 18.0;
    double gstAmount = (subtotal * gstRate) / 100;
    double platformFees = subtotal * 0.05;
    double totalAmount = subtotal + gstAmount + platformFees;

    Set<String> uniqueServiceIds = {};

    if (value.checkoutModel == null) {
      log("checkoutModel is null");
      return Container();
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: Insets.i20),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isDark(context)
                ? eImageAssets.pendingBillBgDark
                : eImageAssets.pendingBillBg,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            // ✅ Iterate over all cart items instead of using `.first`
            ...value.cartList.map((cartItem) {
              return BillRowCommon(
                // value.cartList, e.serviceId
                title: cartItem.serviceList!.title ??
                    "No Name", // ✅ Dynamically add backend service name
                color: appColor(context).darkText,
                price:
                    "${getSymbol(context)}${(currency(context).currencyVal * (cartItem.serviceList?.serviceRate ?? 0)).toStringAsFixed(2)}",
              ).paddingOnly(bottom: Insets.i10);
            }).toList(),

            // ✅ Subtotal
            BillRowCommon(
              title: "Subtotal",
              price: "${getSymbol(context)}${subtotal.toStringAsFixed(2)}",
            ).paddingOnly(bottom: Insets.i10),

            // ✅ GST Calculation
            BillRowCommon(
              title: "GST (${gstRate.toStringAsFixed(0)}%)",
              color: appColor(context).online,
              price: "${getSymbol(context)}${gstAmount.toStringAsFixed(2)}",
            ).paddingOnly(bottom: Insets.i10),

            // ✅ Platform Fees
            BillRowCommon(
              title: "Platform Fees",
              color: appColor(context).online,
              price: "${getSymbol(context)}${platformFees.toStringAsFixed(2)}",
            ).paddingOnly(bottom: Insets.i25),
          ]),

          // ✅ Total Amount Calculation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language(context, appFonts.totalAmount),
                style: appCss.dmDenseMedium14
                    .textColor(appColor(context).darkText),
              ),
              Text(
                "${getSymbol(context)}${totalAmount.toStringAsFixed(2)}",
                style:
                    appCss.dmDenseBold16.textColor(appColor(context).primary),
              )
            ],
          )
              .paddingSymmetric(horizontal: Insets.i15)
              .paddingOnly(bottom: Insets.i5, top: Insets.i10),
        ],
      ),
    );
  }
}





// change to code for 14-02-2025
// class BillcopyClass extends StatelessWidget {
//   BillcopyClass({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final value = Provider.of<CartProvider>(context, listen: true);

//     print('++++++cart++++${value.cartList.first.serviceList!.serviceRate}');
//     double currencyValue = currency(context).currencyVal;
//     double subtotal = value.cartList.first.serviceList!.serviceRate ?? 0.0;

//     print('currency valu +++++${currencyValue}');
//     print('subtotal +++++${subtotal}');

//     double allaboutTotal = currencyValue * subtotal;
//     double gstRate = 18.0;
//     double gstAmount =
//         ((value.cartList.first.serviceList!.serviceRate)! * gstRate) / 100;
//     double platformFees = subtotal * 0.05;
//     double totalAmount = subtotal + gstAmount + platformFees + allaboutTotal;
// // old code
//     // double allaboutTotal = currencyValue * subtotal;
//     // double gstRate = 18.0;
//     // double gstAmount = (subtotal * gstRate) / 100;
//     // double platformFees = subtotal * 0.05;
//     // double totalAmount = subtotal + gstAmount + platformFees + allaboutTotal;

//     Set<String> uniqueServiceIds = {};

//     if (value.checkoutModel == null) {
//       log("checkoutModel is null");
//       return Container();
//     }
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: Insets.i20),
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(
//             isDark(context)
//                 ? eImageAssets.pendingBillBgDark
//                 : eImageAssets.pendingBillBg,
//           ),
//           fit: BoxFit.fill,
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(children: [
//             if (value.checkoutModel!.services != null)
//               Column(
//                 children: [
//                   ...?value.checkoutModel?.services
//                       ?.where((e) =>
//                           e.serviceId != null &&
//                           uniqueServiceIds.add(e.serviceId!.toString()))
//                       .map((e) {
//                     int total = getTotalRequiredServiceMan(
//                         value.cartList, e.serviceId!, false);

//                     return (value.checkoutModel?.services?.first.total
//                                     ?.totalServicemen ??
//                                 0) >
//                             1
//                         ? Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       "-??1 ${getName(value.cartList, e.serviceId!, false)}",
//                                       style: appCss.dmDenseMedium14.textColor(
//                                           appColor(context).lightText),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     const HSpace(Sizes.s5),
//                                     SvgPicture.asset(eSvgAssets.about,
//                                             fit: BoxFit.scaleDown,
//                                             colorFilter: ColorFilter.mode(
//                                                 appColor(context).primary,
//                                                 BlendMode.srcIn))
//                                         .inkWell(
//                                             onTap: () => value.onServiceDetail(
//                                                 context,
//                                                 data: e,
//                                                 totalServiceman: total))
//                                   ],
//                                 ),
//                               ),
//                               // any change this file to filed
//                               Text(
//                                 "???${getSymbol(context)}${(value.cartList.first.serviceList!.serviceRate)!.toStringAsFixed(2)}",
//                                 style: appCss.dmDenseMedium14
//                                     .textColor(appColor(context).darkText),
//                               ),
//                             ],
//                           ).paddingOnly(
//                             bottom: Insets.i10,
//                             right: Insets.i15,
//                             left: Insets.i15)
//                         : BillRowCommon(
//                                 title: getName(
//                                     value.cartList, e.serviceId!, false),
//                                 color: appColor(context).darkText,
//                                 price:
//                                     "${getSymbol(context)}${(currency(context).currencyVal * (e.total?.subtotal ?? 0)).toStringAsFixed(2)}")
//                             .paddingOnly(bottom: Insets.i10);
//                   }),
//                 ],
//               ),
//             if (value.checkoutModel!.servicesPackage != null)
//               Column(
//                 children: [
//                   ...value.checkoutModel!.servicesPackage!
//                       .asMap()
//                       .entries
//                       .map((e) => Column(
//                             children:
//                                 e.value.services!.asMap().entries.map((ser) {
//                               int total = getTotalRequiredServiceMan(
//                                   value.cartList, ser.value.serviceId, true);
//                               return ser.value.total!.totalServicemen! > 1
//                                   ? Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                           Row(children: [
//                                             Text(
//                                                 getName(value.cartList,
//                                                     ser.value.serviceId, true),
//                                                 style: appCss.dmDenseMedium14
//                                                     .textColor(appColor(context)
//                                                         .lightText)),
//                                             const HSpace(Sizes.s5),
//                                             SvgPicture.asset(eSvgAssets.about,
//                                                     fit: BoxFit.scaleDown,
//                                                     colorFilter:
//                                                         ColorFilter.mode(
//                                                             appColor(context)
//                                                                 .primary,
//                                                             BlendMode.srcIn))
//                                                 .inkWell(
//                                                     onTap: () =>
//                                                         value.onServiceDetail(
//                                                             context,
//                                                             packageServices:
//                                                                 ser.value,
//                                                             totalServiceman:
//                                                                 total))
//                                           ]),
//                                           Text(
//                                               "---+++-${getSymbol(context)}${(currency(context).currencyVal * ser.value.total!.subtotal!)}",
//                                               style: appCss.dmDenseMedium14
//                                                   .textColor(appColor(context)
//                                                       .darkText))
//                                           // Text(
//                                           //     "${getSymbol(context)}${(currency(context).currencyVal * ser.value.total!.subtotal!).toStringAsFixed(2)}",
//                                           //     style: appCss.dmDenseMedium14
//                                           //         .textColor(
//                                           //             appColor(context)
//                                           //                 .darkText))
//                                         ]).paddingOnly(
//                                       bottom: Insets.i10,
//                                       right: Insets.i15,
//                                       left: Insets.i15)
//                                   : BillRowCommon(
//                                           title: getName(value.cartList,
//                                               ser.value.serviceId, true),
//                                           color: appColor(context).darkText,
//                                           price:
//                                               "+++++${getSymbol(context)}${(currency(context).currencyVal * ser.value.total!.subtotal!).toStringAsFixed(2)}")
//                                       .paddingOnly(bottom: Insets.i10);
//                             }).toList(),
//                           ))
//                 ],
//               ),
//             BillRowCommon(
//               title: "Subtotal copy",
//               price: "${getSymbol(context)}${subtotal.toStringAsFixed(2)}",
//             ).paddingOnly(bottom: Insets.i10),
//             BillRowCommon(
//               title: "GST copy (${gstRate.toStringAsFixed(0)}%)",
//               color: appColor(context).online,
//               price: "${getSymbol(context)}${gstAmount.toStringAsFixed(2)}",
//             ).paddingOnly(bottom: Insets.i10),
//             BillRowCommon(
//               title: "Platform Fees copy ",
//               color: appColor(context).online,
//               price: "${getSymbol(context)}${platformFees.toStringAsFixed(2)}",
//             ).paddingOnly(bottom: Insets.i25),
//           ]),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 language(context, appFonts.totalAmount),
//                 style: appCss.dmDenseMedium14
//                     .textColor(appColor(context).darkText),
//               ),
//               Text(
//                 "${getSymbol(context)}${totalAmount.toStringAsFixed(2)}",
//                 style:
//                     appCss.dmDenseBold16.textColor(appColor(context).primary),
//               )
//             ],
//           )
//               .paddingSymmetric(horizontal: Insets.i15)
//               .paddingOnly(bottom: Insets.i5, top: Insets.i10),
//         ],
//       ),
//     );
//   }
// }
