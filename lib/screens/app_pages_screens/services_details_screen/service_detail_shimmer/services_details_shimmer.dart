import '../../../../config.dart';

class ServiceDetailShimmer extends StatelessWidget {
  const ServiceDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark(context) ? Colors.black : Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(children: [
            Stack(alignment: Alignment.bottomCenter, children: [
              const CommonSkeleton(
                  height: Sizes.s238,
                  isAllRadius: true,
                  bLRadius: 20,
                  bRRadius: 20),
              const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonWhiteShimmer(height: Sizes.s18, width: Sizes.s155),
                    HSpace(Sizes.s3),
                    CommonWhiteShimmer(height: Sizes.s18, width: Sizes.s45)
                  ]).padding(horizontal: Sizes.s20, bottom: Sizes.s18)
            ]),
            const VSpace(Sizes.s12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const CommonSkeleton(
                  width: Sizes.s60, height: Sizes.s60, radius: 8),
              const CommonSkeleton(
                      width: Sizes.s60, height: Sizes.s60, radius: 8)
                  .paddingSymmetric(horizontal: Sizes.s15),
              const CommonSkeleton(
                  width: Sizes.s60, height: Sizes.s60, radius: 8)
            ]),
            const VSpace(Sizes.s18),
            Stack(alignment: Alignment.center, children: [
              const CommonSkeleton(height: Sizes.s53, radius: 10),
              const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CommonWhiteShimmer(height: Sizes.s16, width: Sizes.s50),
                    CommonWhiteShimmer(height: Sizes.s23, width: Sizes.s58)
                  ]).paddingSymmetric(horizontal: Sizes.s14)
            ]).padding(horizontal: Sizes.s20, bottom: Sizes.s20),
            const ServiceDetailBodyShimmer(),
            const VSpace(Sizes.s25),
            const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonSkeleton(height: Sizes.s18, width: Sizes.s138),
                  CommonSkeleton(height: Sizes.s18, width: Sizes.s46)
                ]).padding(horizontal: Sizes.s20, bottom: Sizes.s18),
            const OtherServiceShimmer(),
            const VSpace(Sizes.s100)
          ]),
          const Stack(alignment: Alignment.center, children: [
            CommonSkeleton(height: Sizes.s50),
            CommonWhiteShimmer(height: Sizes.s15, width: Sizes.s88)
          ])
              .marginSymmetric(horizontal: Sizes.s15)
              .paddingOnly(bottom: Sizes.s15)
              .backgroundColor(
                  isDark(context) ? Colors.black : appColor(context).whiteColor)
        ],
      ),
    );
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