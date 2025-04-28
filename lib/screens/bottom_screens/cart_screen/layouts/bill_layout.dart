import 'dart:developer';

import '../../../../config.dart';

class BillLayout extends StatelessWidget {
  const BillLayout({super.key});
  @override
  Widget build(BuildContext context) {
    final value = Provider.of<CartProvider>(context, listen: true);

// create for g
    double currencyValue =
        currency(context).currencyVal; // Get currency value safely
    double subtotal = value.checkoutModel!.services!.first.total!.subtotal ?? 0;
//

    Set<String> uniqueServiceIds = {}; // Track unique service IDs

    log("value.checkoutModel!: ${value.checkoutModel!}");
    if (value.checkoutModel == null) {
      log("checkoutModel is null");
      return Container(); // Return an empty container or a loading indicator
    }
    return Container(
        padding: const EdgeInsets.symmetric(vertical: Insets.i20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(isDark(context)
                    ? eImageAssets.pendingBillBgDark
                    : eImageAssets.pendingBillBg),
                fit: BoxFit.fill)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                if (value.checkoutModel!.services != null)
                  Column(
                    children: [
                      ...?value.checkoutModel?.services
                          ?.where((e) =>
                                  e.serviceId != null &&
                                  uniqueServiceIds.add(e.serviceId!
                                      .toString()) // Convert int to String
                              )
                          .map((e) {
                        int total = getTotalRequiredServiceMan(
                            value.cartList, e.serviceId!, false);
                        return (value.checkoutModel?.services?.first.total
                                        ?.totalServicemen ??
                                    0) >
                                1
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    // Ensures text does not break into two lines
                                    child: Row(
                                      children: [
                                        Text(
                                          getName(value.cartList, e.serviceId!,
                                              false),
                                          style: appCss.dmDenseMedium14
                                              .textColor(
                                                  appColor(context).lightText),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const HSpace(Sizes.s5),
                                        SvgPicture.asset(eSvgAssets.about,
                                                fit: BoxFit.scaleDown,
                                                colorFilter: ColorFilter.mode(
                                                    appColor(context).primary,
                                                    BlendMode.srcIn))
                                            .inkWell(
                                                onTap: () => value
                                                    .onServiceDetail(context,
                                                        data: e,
                                                        totalServiceman: total))
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "${getSymbol(context)}${(currencyValue * subtotal)}",
                                    style: appCss.dmDenseMedium14
                                        .textColor(appColor(context).darkText),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ).paddingOnly(
                                bottom: Insets.i10,
                                right: Insets.i15,
                                left: Insets.i15)
                            : BillRowCommon(
                                    title: getName(
                                        value.cartList, e.serviceId!, false),
                                    color: appColor(context).darkText,
                                    price:
                                        "${getSymbol(context)}${(currency(context).currencyVal * (e.total?.subtotal ?? 0))}")
                                .paddingOnly(bottom: Insets.i10);
                      }),

// old code
                      // ...value.checkoutModel!.services!
                      //     .asMap()
                      //     .entries
                      //     .map((e) {
                      //   int total = getTotalRequiredServiceMan(
                      //       value.cartList, e.value.serviceId, false);
                      //   return (value.checkoutModel!.services!.first.total!
                      //                   .totalServicemen ??
                      //               0) >
                      //           1
                      //       ? Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //               Row(children: [
                      //                 Text(
                      //                     getName(value.cartList,
                      //                         e.value.serviceId, false),
                      //                     style: appCss.dmDenseMedium14
                      //                         .textColor(
                      //                             appColor(context).lightText)),
                      //                 const HSpace(Sizes.s5),
                      //                 SvgPicture.asset(eSvgAssets.about,
                      //                         fit: BoxFit.scaleDown,
                      //                         colorFilter: ColorFilter.mode(
                      //                             appColor(context).primary,
                      //                             BlendMode.srcIn))
                      //                     .inkWell(
                      //                         onTap: () =>
                      //                             value.onServiceDetail(context,
                      //                                 data: e.value,
                      //                                 totalServiceman: total))
                      //               ]),

                      //               Text(
                      //                 "---=??-${getSymbol(context)}${(currencyValue * subtotal)}",
                      //                 style: appCss.dmDenseMedium14.textColor(
                      //                     appColor(context).darkText),
                      //               )
                      //               // Text(
                      //               //     "${getSymbol(context)}${(currency(context).currencyVal * e.value.total!.subtotal!).toStringAsFixed(2)}",
                      //               //     style: appCss.dmDenseMedium14.textColor(
                      //               //         appColor(context).darkText))
                      //             ]).paddingOnly(
                      //           bottom: Insets.i10,
                      //           right: Insets.i15,
                      //           left: Insets.i15)
                      //       : BillRowCommon(
                      //               title: getName(value.cartList,
                      //                   e.value.serviceId, false),
                      //               color: appColor(context).darkText,
                      //               price:
                      //                   "${getSymbol(context)}${(currency(context).currencyVal * e.value.total!.subtotal!)}")
                      //           .paddingOnly(bottom: Insets.i10);
                      // })
                    ],
                  ),

                // if (value.checkoutModel!.servicesPackage != null)
                //   Column(
                //     children: [
                //       ...value.checkoutModel!.servicesPackage!
                //           .asMap()
                //           .entries
                //           .map((e) => Column(
                //                 children: e.value.services!
                //                     .asMap()
                //                     .entries
                //                     .map((ser) {
                //                   int total = getTotalRequiredServiceMan(
                //                       value.cartList,
                //                       ser.value.serviceId,
                //                       true);
                //                   return ser.value.total!.totalServicemen! > 1
                //                       ? Row(
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.spaceBetween,
                //                           children: [
                //                               Row(children: [
                //                                 Text(
                //                                     getName(
                //                                         value.cartList,
                //                                         ser.value.serviceId,
                //                                         true),
                //                                     style: appCss
                //                                         .dmDenseMedium14
                //                                         .textColor(
                //                                             appColor(context)
                //                                                 .lightText)),
                //                                 const HSpace(Sizes.s5),
                //                                 SvgPicture.asset(
                //                                         eSvgAssets.about,
                //                                         fit: BoxFit.scaleDown,
                //                                         colorFilter:
                //                                             ColorFilter.mode(
                //                                                 appColor(
                //                                                         context)
                //                                                     .primary,
                //                                                 BlendMode
                //                                                     .srcIn))
                //                                     .inkWell(
                //                                         onTap: () => value
                //                                             .onServiceDetail(
                //                                                 context,
                //                                                 packageServices:
                //                                                     ser.value,
                //                                                 totalServiceman:
                //                                                     total))
                //                               ]),
                //                               Text(
                //                                   "---+++-${getSymbol(context)}${(currency(context).currencyVal * ser.value.total!.subtotal!)}",
                //                                   style: appCss.dmDenseMedium14
                //                                       .textColor(
                //                                           appColor(context)
                //                                               .darkText))
                //                               // Text(
                //                               //     "${getSymbol(context)}${(currency(context).currencyVal * ser.value.total!.subtotal!).toStringAsFixed(2)}",
                //                               //     style: appCss.dmDenseMedium14
                //                               //         .textColor(
                //                               //             appColor(context)
                //                               //                 .darkText))
                //                             ]).paddingOnly(
                //                           bottom: Insets.i10,
                //                           right: Insets.i15,
                //                           left: Insets.i15)
                //                       : BillRowCommon(
                //                               title: getName(value.cartList,
                //                                   ser.value.serviceId, true),
                //                               color: appColor(context).darkText,
                //                               price:
                //                                   "+++++${getSymbol(context)}${(currency(context).currencyVal * ser.value.total!.subtotal!).toStringAsFixed(2)}")
                //                           .paddingOnly(bottom: Insets.i10);
                //                 }).toList(),
                //               ))
                //     ],
                //   ),
                BillRowCommon(
                        title: appFonts.subtotal,
                        price:
                            "+${getSymbol(context)}${(currencyValue * subtotal).toStringAsFixed(2)}")
                    .paddingOnly(bottom: Insets.i10),
                BillRowCommon(
                        title: appFonts.tax,
                        color: appColor(context).online,
                        price:
                            "+${getSymbol(context)}${(currencyValue * subtotal).toStringAsFixed(2)}")
                    .paddingOnly(bottom: Insets.i10),
                BillRowCommon(
                        title: appFonts.platformFees,
                        color: appColor(context).online,
                        price:
                            "+${getSymbol(context)}${(currencyValue * subtotal).toStringAsFixed(2)}")
                    .paddingOnly(bottom: Insets.i25),

                // code comment for g
                // BillRowCommon(
                //         title: appFonts.subtotal,
                //         price:
                //             "${getSymbol(context)}${(currency(context).currencyVal * value.checkoutModel!.total!.subtotal!).toStringAsFixed(2)}")
                //     .paddingOnly(bottom: Insets.i10),
                // BillRowCommon(
                //         title: appFonts.tax,
                //         color: appColor(context).online,
                //         price:
                //             "+${getSymbol(context)}${(currency(context).currencyVal * value.checkoutModel!.total!.tax!).toStringAsFixed(2)}")
                //     .paddingOnly(bottom: Insets.i10),
                // BillRowCommon(
                //         title: appFonts.platformFees,
                //         color: appColor(context).online,
                //         price:
                //             "+${getSymbol(context)}${(currency(context).currencyVal * value.checkoutModel!.total!.platformFees!).toStringAsFixed(2)}")
                //     .paddingOnly(bottom: Insets.i25),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(language(context, appFonts.totalAmount),
                    style: appCss.dmDenseMedium14
                        .textColor(appColor(context).darkText)),
                Text(
                    "${getSymbol(context)}${(currency(context).currencyVal * value.checkoutModel!.total!.total!).toStringAsFixed(2)}",
                    style: appCss.dmDenseBold16
                        .textColor(appColor(context).primary))
              ])
                  .paddingSymmetric(horizontal: Insets.i15)
                  .paddingOnly(bottom: Insets.i5, top: Insets.i10)
            ]));
  }
}

// experiment code

//
//                     ...value.checkoutModel!.services!.asMap().entries.map((e) {
//                       int totalr = getTotalRequiredServiceMan(
//                           value.cartList, e.value.serviceId, false);
//                       print('????--${e.value.total!.totalServicemen}');
// // value.total?.totalServicemen
//                       return

//                       (value.checkoutModel!.services!.first.total!
//                                       .totalServicemen ??
//                                   0) >
//                               1
//                           ? Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                   Text(
//                                       '???>>>???${e.value.total?.totalServicemen}'),
//                                   Row(children: [
//                                     const HSpace(Sizes.s5),
//                                     Text(
//                                         getName(value.cartList,
//                                             e.value.serviceId, false),
//                                         style: appCss.dmDenseMedium14.textColor(
//                                             appColor(context).lightText)),
//                                     SvgPicture.asset(eSvgAssets.about,
//                                             fit: BoxFit.scaleDown,
//                                             colorFilter: ColorFilter.mode(
//                                                 appColor(context).primary,
//                                                 BlendMode.srcIn))
//                                         .inkWell(
//                                             onTap: () => value.onServiceDetail(
//                                                   context,
//                                                   data: e.value,

//                                                   // totalServiceman: total
//                                                 ))
//                                   ]),
//                                   Text(
//                                       "${getSymbol(context)}${(currency(context).currencyVal * (e.value.total?.subtotal ?? 0)).toStringAsFixed(2)}",
//                                       style: appCss.dmDenseMedium14.textColor(
//                                           appColor(context).darkText))
//                                 ]).paddingOnly(
//                               bottom: Insets.i10,
//                               right: Insets.i15,
//                               left: Insets.i15)
//                           : BillRowCommon(
//                                   title: getName(
//                                       value.cartList, e.value.serviceId, false),
//                                   color: appColor(context).darkText,
//                                   price:
//                                       "????${getSymbol(context)}${(currency(context).currencyVal * (e.value.total?.subtotal ?? 0)).toStringAsFixed(2)}")
//                               .paddingOnly(bottom: Insets.i10);
//                     })
