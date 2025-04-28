import '../../../../config.dart';

class FeaturedServicesLayout extends StatelessWidget {
  final Services? data;
  final Services? services;

  final GestureTapCallback? onTap, addTap;
  final bool? isProvider, inCart;

  const FeaturedServicesLayout(
      {super.key,
      this.data,
      this.onTap,
      this.isProvider = true,
      this.addTap,
      this.services,
      this.inCart = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              /*
              Stack(alignment: Alignment.topRight, children: [
               
                if (data!.discount != "")
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        SizedBox(
                                child: Text(
                                        "${data!.discount!}% ${language(context, appFonts.off)}",
                                        style: appCss.dmDenseMedium12.textColor(
                                            appColor(context).whiteColor))
                                    .padding(
                                        horizontal: Insets.i9,
                                        top: Insets.i3,
                                        bottom: Insets.i3))
                            .decorated(
                                color: appColor(context).red,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.r30))
                      ]).paddingSymmetric(
                      horizontal: Insets.i20, vertical: Insets.i10),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                              child: Text("New",
                                      style: appCss.dmDenseMedium12.textColor(
                                          appColor(context).whiteColor))
                                  .padding(
                                      horizontal: Insets.i9,
                                      top: Insets.i3,
                                      bottom: Insets.i3))
                          .decorated(
                              color: appColor(context).red,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.r30)),
                      Container(),
                    ]).paddingSymmetric(
                    horizontal: Insets.i20, vertical: Insets.i10)

              ]),

              */
/*
              Row(
                children: [
                  data!.media != null && data!.media!.isNotEmpty
                      ? CommonImageLayout(
                          tlRadius: 8,
                          tRRadius: 8,
                          blRadius: 0,
                          bRRadius: 0,
                          isAllBorderRadius: false,
                          image: data!.media![0].originalUrl!,
                          boxFit: BoxFit.cover,
                          height: Sizes.s23,
                          width: Sizes.s23,
                          assetImage: eImageAssets.noImageFound2)
                      : CommonCachedImage(
                          tlRadius: 8,
                          tRRadius: 8,
                          blRadius: 0,
                          bRRadius: 0,
                          isAllBorderRadius: false,
                          height: Sizes.s23,
                          image: eImageAssets.noImageFound2),
                ],
              ),
              */
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Display
                  Text(
                    // capitalizeFirstLetter(data!.user?.name ?? 'N/A'),
                    capitalizeFirstLetter(data!.title ?? 'N/A'),
                    style: appCss.dmDenseSemiBold15
                        .textColor(appColor(context).darkText),
                  ),
                  const VSpace(Sizes.s8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DescriptionLayout(
                          icon: eSvgAssets.location,
                          title: 'Area ??>>>>?',
                          subtitle: data!.mainarea ?? 'N/A',
                        ),
                      ),
                      Container(
                        color: appColor(context).stroke,
                        width: 2,
                        height: Sizes.s50,
                      ),
                      const HSpace(Sizes.s10),
                      Expanded(
                        child: DescriptionLayout(
                          icon: eSvgAssets.homeFill,
                          title: 'Accommodation',
                          subtitle: data!.serviceType ?? 'N/A',
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: Insets.i25),
                  const VSpace(Sizes.s9),

                  // Second Row: Amount & Type of Tenant
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DescriptionLayout(
                          icon: eSvgAssets.amount,
                          title: "Budget",
                          subtitle:
                              "₹ ${data!.budget ?? '0'}", // Show proper budget
                        ),
                      ),
                      Container(
                        color: appColor(context).stroke,
                        width: 2,
                        height: Sizes.s50,
                      ),
                      const HSpace(Sizes.s10),
                      Expanded(
                        child: DescriptionLayout(
                          icon: eSvgAssets.homeOut,
                          title: 'Type of Tenant',
                          subtitle: data!.typeOfTenant ??
                              'N/A', // Show correct tenant type
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: Insets.i24),

                  // Image Section
                  const VSpace(Sizes.s9),
                  const DottedLines(),
                  const VSpace(Sizes.s9),

                  // Price & Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${getSymbol(context)}${(currency(context).currencyVal * data!.price!).toStringAsFixed(2)}",
                            style: appCss.dmDenseRegular14
                                .textColor(appColor(context).lightText)
                                .lineThrough,
                          ),
                          const HSpace(Sizes.s8),
                          Text(
                            "${getSymbol(context)}${((currency(context).currencyVal * data!.serviceRate!).toStringAsFixed(2))}",
                            style: appCss.dmDenseBold16
                                .textColor(appColor(context).darkText),
                          ),
                        ],
                      ),
                      (inCart!)
                          ? AddedButtonCommon(onTap: addTap)
                          : AddedButtonCommon(onTap: addTap)

                      // AddButtonCommon(onTap: addTap),
                    ],
                  ),
                ],
              ).padding(horizontal: Insets.i14, vertical: Insets.i13)
            ]))
        .decorated(
            color: appColor(context).whiteBg,
            boxShadow: [
              BoxShadow(
                  blurRadius: 3,
                  spreadRadius: 2,
                  color: appColor(context).darkText.withOpacity(0.06))
            ],
            borderRadius: BorderRadius.circular(AppRadius.r8),
            border: Border.all(color: appColor(context).stroke))
        .inkWell(onTap: onTap)
        .paddingOnly(bottom: Insets.i15);
  }
}

//  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Expanded(
//             child: DescriptionLayout(
//                 icon: eSvgAssets.location,
//                 title: 'Area',
//                 subtitle: services?.primaryAddress?.address ?? 'N/A')),

//         Container(
//           color: appColor(context).stroke,
//           width: 2,
//           height: Sizes.s78,
//         ),

//         SizedBox(
//           width: 20,
//         ),

//         Expanded(
//             child: DescriptionLayout(
//                 icon: eSvgAssets.homeFill,
//                 title: 'Accommodation',
//                 // subtitle: "${services!.duration} ${services!.durationUnit}"
//                 subtitle: services?.serviceType ?? 'N/A')),

//         // if (services!.categories!.isNotEmpty)
//         //   Expanded(
//         //     child: DescriptionLayout(
//         //             icon: eSvgAssets.categories, title: appFonts.category, subtitle: services!.categories![0].title!)
//         //         .paddingOnly(
//         //             left: AppLocalizations.of(context)?.locale.languageCode == "ar" ? 0 : Insets.i20,
//         //             right: AppLocalizations.of(context)?.locale.languageCode == "ar" ? 0 : Insets.i20),
//         //   )
//       ]).paddingSymmetric(horizontal: Insets.i25),

//          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         Expanded(
//             child: DescriptionLayout(
//                 icon: eSvgAssets.amount,
//                 title: "Amount",
//                 subtitle: "₹ ${services?.budget ?? '0'}")),

//         Container(
//           color: appColor(context).stroke,
//           width: 2,
//           height: Sizes.s78,
//         ),

//         SizedBox(
//           width: 20,
//         ),

//         Expanded(
//             child: DescriptionLayout(
//                 icon: eSvgAssets.homeOut,
//                 title: 'Type of Tenant',
//                 // subtitle: "${services!.duration} ${services!.durationUnit}"
//                 subtitle: services?.typeOfTenant ?? 'N/A')),

//         // if (services!.categories!.isNotEmpty)
//         //   Expanded(
//         //     child: DescriptionLayout(
//         //             icon: eSvgAssets.categories, title: appFonts.category, subtitle: services!.categories![0].title!)
//         //         .paddingOnly(
//         //             left: AppLocalizations.of(context)?.locale.languageCode == "ar" ? 0 : Insets.i20,
//         //             right: AppLocalizations.of(context)?.locale.languageCode == "ar" ? 0 : Insets.i20),
//         //   )
//       ]).paddingSymmetric(horizontal: Insets.i25),
//       const DottedLines(),
//       const VSpace(Sizes.s17),




   /*  change
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            // Text(capitalizeFirstLetter(data!.title!),
                            Text(capitalizeFirstLetter(data!.user?.name!),
                                style: appCss.dmDenseSemiBold15
                                    .textColor(appColor(context).darkText)),
                            const VSpace(Sizes.s8),

                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: DescriptionLayout(
                                          icon: eSvgAssets.location,
                                          title: 'Area',
                                          subtitle: 'N/A'
                                          // services?.primaryAddress?.address ??
                                          )),
                                  Container(
                                    color: appColor(context).stroke,
                                    width: 2,
                                    height: Sizes.s78,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                      child: DescriptionLayout(
                                          icon: eSvgAssets.homeFill,
                                          title: 'Accommodation',
                                          // subtitle: "${services!.duration} ${services!.durationUnit}"
                                          subtitle: 'N/A'
                                          // services?.serviceType ??
                                          )),
                                ]).paddingSymmetric(horizontal: Insets.i25),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: DescriptionLayout(
                                          icon: eSvgAssets.amount,
                                          title: "Amount",
                                          subtitle: "₹ ${'0'}")),
                                  // services?.budget ??

                                  Container(
                                    color: appColor(context).stroke,
                                    width: 2,
                                    height: Sizes.s78,
                                  ),

                                  SizedBox(
                                    width: 20,
                                  ),

                                  Expanded(
                                      child: DescriptionLayout(
                                          icon: eSvgAssets.homeOut,
                                          title: 'Type of Tenant',
                                          // subtitle: "${services!.duration} ${services!.durationUnit}"
                                          subtitle: 'N/A')),
                                  // services?.typeOfTenant ??
                                ]).paddingSymmetric(horizontal: Insets.i25),
                            const VSpace(Sizes.s17),
/*
                            IntrinsicHeight(
                                child: Row(children: [
                              SvgPicture.asset(eSvgAssets.clock),
                              const HSpace(Sizes.s5),
                              Text(
                                  "${data!.duration} ${capitalizeFirstLetter(data!.durationUnit)}",
                                  style: appCss.dmDenseSemiBold12
                                      .textColor(appColor(context).online)),
                              VerticalDivider(
                                      indent: 4,
                                      endIndent: 4,
                                      width: 1,
                                      color: appColor(context).lightText)
                                  .paddingSymmetric(horizontal: Insets.i5),
                              SvgPicture.asset(eSvgAssets.homeOut,
                                  height: Sizes.s16,
                                  colorFilter: ColorFilter.mode(
                                      appColor(context).darkText,
                                      BlendMode.srcIn)),
                              const HSpace(Sizes.s5),
                              // Expanded(
                              //   child: Text(
                              //       "${data!.requiredServicemen} ${capitalizeFirstLetter(language(context, appFonts.serviceman))}",
                              //       style: appCss.dmDenseRegular13
                              //           .textColor(appColor(context).darkText)),
                              // ),
                              Expanded(
                                child: Text(data?.typeOfTenant ?? 'N/A',
                                    style: appCss.dmDenseRegular13
                                        .textColor(appColor(context).darkText)),
                              )
                            ]))
                            */
                          ])),
                      /*
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                "${getSymbol(context)}${(currency(context).currencyVal * data!.price!).toStringAsFixed(2)}",
                                style: appCss.dmDenseRegular14
                                    .textColor(appColor(context).lightText)
                                    .lineThrough),
                            const HSpace(Sizes.s8),
                            Text(
                                "${getSymbol(context)}${((currency(context).currencyVal * data!.serviceRate!).toStringAsFixed(2))}",
                                style: appCss.dmDenseBold16
                                    .textColor(appColor(context).darkText))
                          ]),
*/
                      data!.media != null && data!.media!.isNotEmpty
                          ? CommonImageLayout(
                              tlRadius: 8,
                              tRRadius: 8,
                              blRadius: 0,
                              bRRadius: 0,
                              isAllBorderRadius: false,
                              image: data!.media![0].originalUrl!,
                              boxFit: BoxFit.cover,
                              height: Sizes.s100,
                              width: Sizes.s100,
                              assetImage: eImageAssets.noImageFound2)
                          : CommonCachedImage(
                              tlRadius: 8,
                              tRRadius: 8,
                              blRadius: 0,
                              bRRadius: 0,
                              isAllBorderRadius: false,
                              height: Sizes.s100,
                              width: Sizes.s100,
                              image: eImageAssets.noImageFound2),
                    ]),
                const HSpace(Sizes.s10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        DottedLines(
                            width: MediaQuery.of(context).size.width - 155),
                        SvgPicture.asset(eSvgAssets.arrowRight1,
                            colorFilter: ColorFilter.mode(
                                appColor(context).stroke, BlendMode.srcIn))
                      ]),
                      const HSpace(Sizes.s10),
                    ]),
                Row(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                              "${getSymbol(context)}${(currency(context).currencyVal * data!.price!).toStringAsFixed(2)}",
                              style: appCss.dmDenseRegular14
                                  .textColor(appColor(context).lightText)
                                  .lineThrough),
                          const HSpace(Sizes.s8),
                          Text(
                              "${getSymbol(context)}${((currency(context).currencyVal * data!.serviceRate!).toStringAsFixed(2))}",
                              style: appCss.dmDenseBold16
                                  .textColor(appColor(context).darkText))
                        ]),
                    Spacer(),
                    (inCart!)
                        ? AddedButtonCommon(onTap: addTap)
                        : AddButtonCommon(onTap: addTap)
                  ],
                ),
                if (data!.description != null) SizedBox(),
/*
                Text(capitalizeFirstLetter(data!.description!),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: appCss.dmDenseMedium13
                            .textColor(appColor(context).lightText))
                    .marginOnly(
                        right: rtl(context) ? 0 : Insets.i70,
                        left: rtl(context) ? Insets.i70 : 0,
                        bottom: Sizes.s6)
*/
              ]).padding(horizontal: Insets.i14, vertical: Insets.i13)
              */



              /*
               if (data!.media != null && data!.media!.isNotEmpty)
                    CommonImageLayout(
                      tlRadius: 8,
                      tRRadius: 8,
                      blRadius: 0,
                      bRRadius: 0,
                      isAllBorderRadius: false,
                      image: data!.media![0].originalUrl!,
                      boxFit: BoxFit.cover,
                      height: Sizes.s100,
                      width: Sizes.s100,
                      assetImage: eImageAssets.noImageFound2,
                    )
                  else
                    CommonCachedImage(
                      tlRadius: 8,
                      tRRadius: 8,
                      blRadius: 0,
                      bRRadius: 0,
                      isAllBorderRadius: false,
                      height: Sizes.s100,
                      width: Sizes.s100,
                      image: eImageAssets.noImageFound2,
                    ),
              */