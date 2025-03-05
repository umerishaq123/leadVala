import 'package:leadvala/screens/app_pages_screens/provider_details_screen/layouts/services_status_button.dart';
import 'package:leadvala/screens/app_pages_screens/provider_details_screen/layouts/services_status_timeline.dart';

import '../../../../config.dart';

class ProviderTopLayout extends StatelessWidget {
  const ProviderTopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderDetailsProvider>(
        builder: (context, providerCtrl, child) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(isDark(context)
                    ? eImageAssets.providerBgDark
                    : eImageAssets.providerBg),
                fit: BoxFit.fill)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePicCommon(
              isProfile: false,
              imageUrl: providerCtrl.provider!.media != null &&
                      providerCtrl.provider!.media!.isNotEmpty
                  ? providerCtrl.provider!.media![0].originalUrl
                  : null,
            ).alignment(Alignment.center),
            const VSpace(Sizes.s8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(capitalizeFirstLetter(providerCtrl.provider!.name!),
                  style: appCss.dmDenseSemiBold14
                      .textColor(appColor(context).darkText)),
              const HSpace(Sizes.s6),
              SvgPicture.asset(eSvgAssets.tick)
            ]),
            const VSpace(Sizes.s6),
            IntrinsicHeight(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  if (providerCtrl.provider!.reviewRatings != null)
                    Column(children: [
                      RatingLayout(
                          initialRating:
                              providerCtrl.provider!.reviewRatings != null
                                  ? double.parse(providerCtrl
                                      .provider!.reviewRatings
                                      .toString())
                                  : 0.0,
                          color: const Color(0xffFFC412)),
                      Text(
                          "${providerCtrl.provider!.reviewRatings ?? 0} ${language(context, appFonts.reviews).toLowerCase()}",
                          style: appCss.dmDenseMedium13
                              .textColor(appColor(context).darkText))
                    ]),
                  // if (providerCtrl.provider!.reviewRatings != null)
                  //   VerticalDivider(width: 1, color: appColor(context).stroke, indent: 3, endIndent: 3)
                  //       .paddingSymmetric(horizontal: Insets.i10),
                  // Text(
                  //     "${providerCtrl.provider!.experienceDuration ?? 0} ${providerCtrl.provider!.experienceInterval != null ? capitalizeFirstLetter(providerCtrl.provider!.experienceInterval) : "Years"} ${appFonts.of} ${language(context, appFonts.experience)}",
                  //     style: appCss.dmDenseMedium13.textColor(appColor(context).darkText))
                ])),
            const VSpace(Sizes.s20),
            const Center(child: ServicesStatusButton()),
            const VSpace(Sizes.s8),
            const DottedLines(),
            const VSpace(Sizes.s10),
            // ServicesDeliveredLayout(
            //     services: providerCtrl.provider!.served ?? "0"),
            if (providerCtrl.provider!.description != null)
              Text(language(context, appFonts.detailsOfProvider),
                      style: appCss.dmDenseMedium12
                          .textColor(appColor(context).lightText))
                  .paddingOnly(top: Insets.i15, bottom: Insets.i8),
            if (providerCtrl.provider!.description != null)
              Text(providerCtrl.provider!.description ?? "",
                  style: appCss.dmDenseMedium14
                      .textColor(appColor(context).darkText)),
            Text(language(context, appFonts.personalInfo),
                    style: appCss.dmDenseMedium12
                        .textColor(appColor(context).lightText))
                .paddingOnly(top: Insets.i15, bottom: Insets.i8),
            if (providerCtrl.provider!.phone != null ||
                providerCtrl.provider!.email != null)
              PersonalDetailLayout(
                email: providerCtrl.provider!.email ?? "",
                code: providerCtrl.provider!.code.toString(),
                phone: providerCtrl.provider!.phone != null
                    ? providerCtrl.provider?.phone.toString()
                    : "",
                // knownLanguage: providerCtrl.provider!.knownLanguages,
              ),
          ],
        ).paddingAll(Insets.i20),
      );
    });
  }
}


// <!-- <manifest xmlns:android="http://schemas.android.com/apk/res/android">

//     <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
//     <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
//     <uses-permission android:name="android.permission.CALL_PHONE"/>

//     <uses-permission android:name="android.permission.INTERNET" />
//     <uses-permission android:name="android.permission.VIBRATE"/>
//     <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
//     <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
//     <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
//     <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
//     <application
//         android:label="LeadVala"
//         android:name="${applicationName}"
//         android:icon="@mipmap/ic_launcher">
//         android:requestLegacyExternalStorage="true"
//         <queries>
//         <intent>
//             <action android:name="android.intent.action.VIEW"/>
//             <data android:scheme="tel"/>
//         </intent>
//         </queries>
//         <meta-data android:name="com.google.android.geo.API_KEY"
//             android:value="Your Google api key"/>

//         <activity
//             android:name=".MainActivity"
//             android:exported="true"
//             android:launchMode="singleTop"

//             android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
//             android:hardwareAccelerated="true"
//             android:enableOnBackInvokedCallback="true"
//             android:windowSoftInputMode="adjustResize">
//             <!-- Specifies an Android theme to apply to this Activity as soon as
//                  the Android process has started. This theme is visible to the user
//                  while the Flutter UI initializes. After that, this theme continues
//                  to determine the Window background behind the Flutter UI. -->
//             <meta-data
//               android:name="io.flutter.embedding.android.NormalTheme"
//               android:resource="@style/NormalTheme"
//               />
//             <meta-data
//                 android:name="com.google.firebase.messaging.default_notification_channel_id"
//                 android:value="high_importance_channel" />
//             <intent-filter>
//                 <action android:name="android.intent.action.MAIN"/>
//                 <category android:name="android.intent.category.LAUNCHER"/>
//             </intent-filter>
//             <intent-filter>
//                 <action android:name="FLUTTER_NOTIFICATION_CLICK" />
//                 <category android:name="android.intent.category.DEFAULT" />
//             </intent-filter>
//         </activity>
//         <!-- Don't delete the meta-data below.
//              This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
//         <meta-data
//             android:name="flutterEmbedding"
//             android:value="2" />
//     </application>
// </manifest> -->
