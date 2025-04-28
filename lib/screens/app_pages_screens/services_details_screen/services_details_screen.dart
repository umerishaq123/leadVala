import 'package:leadvala/common_tap.dart';
import 'package:leadvala/screens/app_pages_screens/services_details_screen/service_detail_shimmer/services_details_shimmer.dart';
import 'package:flutter/rendering.dart';

import '../../../config.dart';

import 'dart:developer';

class ServicesDetailsScreen extends StatelessWidget {
  const ServicesDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesDetailsProvider>(
      builder: (BuildContext context, value, Widget? child) {  
        return   Consumer<FavouriteListProvider>(builder: (context2, favCtrl, child) {
        return Consumer<ServicesDetailsProvider>(
            builder: (context1, serviceCtrl, child) {
          return Container(
            color: appColor(context).whiteBg,
            child: SafeArea(
              child: StatefulWrapper(
                  onInit: () => Future.delayed(DurationClass.ms50)
                      .then((val) => serviceCtrl.onReady(context)),
                  child: PopScope(
                      canPop: true,
                      onPopInvoked: (didPop) {
                        serviceCtrl.onBack(context, false);
                        if (didPop) return;
                      },
                      child: RefreshIndicator(
                        onRefresh: () {
                          return serviceCtrl.onRefresh(context);
                        },
                        child: LoadingComponent(
                          child: (serviceCtrl.widget1Opacity == 0.0)
                              ? const ServiceDetailShimmer()
                              : Scaffold(
                                  body: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 1200),
                                  opacity: serviceCtrl.widget1Opacity,
                                  child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        SingleChildScrollView(
                                            controller:
                                                serviceCtrl.scrollController,
                                            child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                  ServiceImageLayout(
                                                    onBack: () => serviceCtrl
                                                        .onBack(context, true),
                                                    isFav: favCtrl.serviceFavList
                                                        .where((element) =>
                                                            element.serviceId !=
                                                                null &&
                                                            element.serviceId
                                                                    .toString() ==
                                                                serviceCtrl
                                                                    .service!.id
                                                                    .toString())
                                                        .isNotEmpty,
                                                    title: serviceCtrl
                                                        .service!.title!,
                                                    image: serviceCtrl.service!
                                                            .media!.isNotEmpty
                                                        ? serviceCtrl
                                                            .service!
                                                            .media![serviceCtrl
                                                                .selectedIndex]
                                                            .originalUrl!
                                                        : "",
                                                    rating: serviceCtrl
                                                        .service!.ratingCount
                                                        ?.toString(),
                                                    favTap: (p0) {
                                                      log("FAV : $p0");
                                                      if (p0) {
                                                        favCtrl.addToFav(
                                                            context,
                                                            serviceCtrl
                                                                .service!.id,
                                                            'service');
                                                      } else {
                                                        favCtrl.deleteToFav(
                                                            context,
                                                            serviceCtrl
                                                                .service!.id,
                                                            'service');
                                                      }
                                                    },
                                                  ),
                                                  if (serviceCtrl.service!.media!
                                                          .length >
                                                      1)
                                                    const VSpace(Sizes.s12),
                                                  if (serviceCtrl.service!.media!
                                                          .length >
                                                      1)
                                                    Column(children: [
                                                      Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Image.asset(
                                                                eImageAssets
                                                                    .servicesBg,
                                                                width:
                                                                    MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width),
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      language(
                                                                          context,
                                                                          appFonts
                                                                              .amount),
                                                                      style: appCss
                                                                          .dmDenseMedium12
                                                                          .textColor(
                                                                              appColor(context).primary)),
                                                                  Text(
                                                                      "${getSymbol(context)}${(currency(context).currencyVal * (serviceCtrl.service!.serviceRate!)).toStringAsFixed(2)}",
                                                                      style: appCss
                                                                          .dmDenseBold18
                                                                          .textColor(
                                                                              appColor(context).primary))
                                                                ]).paddingSymmetric(
                                                                horizontal:
                                                                    Insets.i20)
                                                          ]).paddingSymmetric(
                                                          vertical: Insets.i15),
                                                      ServiceDescription(
                                                          services: serviceCtrl
                                                              .service),
                                                    ]).paddingSymmetric(
                                                        horizontal: Insets.i20),
      
                                                  // if (serviceCtrl.serviceFaq.isNotEmpty)
                                                  //   Column(
                                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                                  //     children: [
                                                  //       const VSpace(Sizes.s10),
                                                  //       Text(language(context, appFonts.faq),
                                                  //               overflow: TextOverflow.clip,
                                                  //               style: appCss.dmDenseBold16.textColor(appColor(context).darkText))
                                                  //           .paddingSymmetric(horizontal: Sizes.s20),
                                                  //       const VSpace(Sizes.s10),
                                                  //       ...serviceCtrl.serviceFaq.asMap().entries.map((e) => Container(
                                                  //             margin: const EdgeInsets.symmetric(
                                                  //                 horizontal: Sizes.s20, vertical: Sizes.s8),
                                                  //             padding: const EdgeInsets.symmetric(horizontal: Sizes.s20),
                                                  //             decoration: ShapeDecoration(
                                                  //                 shadows: [
                                                  //                   BoxShadow(
                                                  //                       blurRadius: 2,
                                                  //                       spreadRadius: 2,
                                                  //                       color: appColor(context).darkText.withOpacity(0.06))
                                                  //                 ],
                                                  //                 color: appColor(context).whiteBg,
                                                  //                 shape: SmoothRectangleBorder(
                                                  //                     borderRadius: SmoothBorderRadius(
                                                  //                         cornerRadius: 8, cornerSmoothing: 1))),
                                                  //             child: ExpansionTile(
                                                  //                 expansionAnimationStyle:
                                                  //                     AnimationStyle(curve: Curves.fastOutSlowIn),
                                                  //                 key: Key(serviceCtrl.selected.toString()),
                                                  //                 initiallyExpanded: e.key == serviceCtrl.selected,
                                                  //                 onExpansionChanged: (newState) =>
                                                  //                     serviceCtrl.onExpansionChange(newState, e.key),
                                                  //                 //atten
                                                  //                 tilePadding: EdgeInsets.zero,
                                                  //                 collapsedIconColor: appColor(context).darkText,
                                                  //                 dense: true,
                                                  //                 iconColor: appColor(context).darkText,
                                                  //                 title: Text(e.value.question!,
                                                  //                     style: appCss.dmDenseMedium14
                                                  //                         .textColor(appColor(context).darkText)),
                                                  //                 children: <Widget>[
                                                  //                   Divider(
                                                  //                     color: appColor(context).stroke,
                                                  //                     height: .5,
                                                  //                     thickness: 0,
                                                  //                   ),
                                                  //                   ListTile(
                                                  //                       contentPadding:
                                                  //                           const EdgeInsets.symmetric(horizontal: Sizes.s5),
                                                  //                       title: Text(e.value.answer!,
                                                  //                           style: appCss.dmDenseLight14.textColor(
                                                  //                               appColor(context).darkText.withOpacity(.8))))
                                                  //                 ]),
                                                  //           ))
                                                  //     ],
                                                  //   ).marginOnly(top: Sizes.s10),
      
                                                  if (serviceCtrl.service!
                                                              .relatedServices !=
                                                          null &&
                                                      serviceCtrl
                                                          .service!
                                                          .relatedServices!
                                                          .isNotEmpty)
                                                    HeadingRowCommon(
                                                      title:
                                                          appFonts.alsoProvided,
                                                      onTap: () => route.pushNamed(
                                                          context,
                                                          routeName
                                                              .providerDetailsScreen,
                                                          arg: {
                                                            'provider':
                                                                serviceCtrl
                                                                    .service!.user
                                                          }),
                                                    ).padding(
                                                        top: Insets.i25,
                                                        bottom: Insets.i15,
                                                        horizontal: Insets.i20),
     value.serviceList.isNotEmpty
  ? Consumer<CartProvider>(
      builder: (context2, cart, child) {
        return Column(
          children: [
            // Add header text for the service list
            // Text(
            //   language(context, appFonts.services),
            //   style: appCss.dmDenseBold16.textColor(appColor(context).darkText),
            // ).paddingOnly(
            //   left: rtl(context) ? 0 : Insets.i20,
            //   right: rtl(context) ? Insets.i20 : 0,
            // ),
            
            // Display the service list horizontally in a row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: value.serviceList
                    .asMap()
                    .entries
                    .map((e) {
                      return FeaturedServicesLayout(
                        data: e.value,
                        isProvider: false,
                        inCart: isInCart(context, e.value.id),
                        addTap: () =>value.getServiceById(
                                                context,
                                                e.value.id),
                        //  value.getProviderById(
                        //   context,
                        //   e.value.userId,
                        //   e.key,
                        //   e.value,
                        // ),
                        onTap: () => value.getServiceById(context, e.value.id),
                      ).paddingSymmetric(horizontal: Insets.i20);
                    })
                    .toList(),
              ),
            ).marginOnly(top: Insets.i15),
          ],
        );
      },
  )
  : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text heading when no services are found
        Text(
          language(context, appFonts.services),
          style: appCss.dmDenseBold16.textColor(appColor(context).darkText),
        ).paddingOnly(
          left: rtl(context) ? 10 : Insets.i20,
          right: rtl(context) ? Insets.i20 : 0,
        ),

        // Empty state when no data is available
        EmptyLayout(
          title: appFonts.noDataFound,
          subtitle: appFonts.noDataFoundDesc,
          buttonText: appFonts.refresh,
          bTap: () {
            value.getServiceByCategoryId(
              context, value.categoryModel!.id);
          },
          widget: Stack(
            children: [
              Image.asset(
                eImageAssets.emptyCart,
                height: Sizes.s230,
              ),
            ],
          ),
        ).marginOnly(top: Insets.i50),
      ],
  ),

                          
                          
                                                ])
                                                .marginOnly(bottom: Insets.i100)),
      
                                        /*                  ButtonCommon(
                                    margin: Insets.i20,
                                    title: appFonts.addToCart,
                                    onTap: () => onBook(context, serviceCtrl.service!,
                                            addTap: () => serviceCtrl.onAdd(),
                                            minusTap: () =>
                                                serviceCtrl.onRemoveService(context))
                                        .then((e) {
                                      serviceCtrl
                                              .service!.selectedRequiredServiceMan =
                                          serviceCtrl.service!.requiredServicemen;
                                      serviceCtrl.notifyListeners();
                                    }),
                                  ).paddingOnly(bottom: Insets.i20).decorated(
                                      color: appColor(context).whiteBg)*/
                                        ButtonCommon(
                                                margin: Insets.i20,
                                                title: appFonts.addToCart,
                                                onTap: () {
                                                  final providerDetail = Provider
                                                      .of<ProviderDetailsProvider>(
                                                          context,
                                                          listen: false);
                                                  providerDetail
                                                      .selectProviderIndex = 0;
                                                  providerDetail
                                                      .notifyListeners();
                                                  onBook(context,
                                                      serviceCtrl.service!,
                                                      addTap: () =>
                                                          serviceCtrl.onAdd(),
                                                      minusTap: () => serviceCtrl
                                                          .onRemoveService(
                                                              context)).then((e) {
                                                    serviceCtrl.service!
                                                            .selectedRequiredServiceMan =
                                                        serviceCtrl.service!
                                                            .requiredServicemen;
                                                    serviceCtrl.notifyListeners();
                                                  });
                                                })
                                            .marginOnly(bottom: Insets.i20)
                                            .backgroundColor(
                                                appColor(context).whiteBg)
                                      ]),
                                )),
                        ),
                      ))),
            ),
          );
        });
      });
   
   
      },
     
    );
  }
}
