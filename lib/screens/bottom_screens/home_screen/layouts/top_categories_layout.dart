import 'package:flutter/material.dart';

import '../../../../config.dart';

class TopCategoriesLayout extends StatelessWidget {
  final CategoryModel? data;
  final GestureTapCallback? onTap;
  final int? index, selectedIndex;
  final double? rPadding;
  final bool isCategories, isExapnded;

  const TopCategoriesLayout(
      {super.key,
      this.onTap,
      this.data,
      this.index,
      this.selectedIndex,
      this.isCategories = false,
      this.isExapnded = true,
      this.rPadding});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          height: Sizes.s60,
          width: Sizes.s60,
          decoration: ShapeDecoration(
              color: selectedIndex == index
                  ? appColor(context).primary.withOpacity(0.2)
                  : isCategories == true
                      ? appColor(context).whiteBg
                      : appColor(context).fieldCardBg,
              shape: SmoothRectangleBorder(
                  side: BorderSide(
                      color: selectedIndex == index
                          ? appColor(context).primary
                          : appColor(context).trans),
                  borderRadius: SmoothBorderRadius(
                      cornerRadius: AppRadius.r10, cornerSmoothing: 1))),
          child: /*Image.network(data!.media![0].originalUrl!,
                  fit: BoxFit.fill,
                  color: selectedIndex == index
                      ? appColor(context).primary
                      : appColor(context).darkText,
                  height: Sizes.s22,
                  width: Sizes.s22)
              .paddingAll(Insets.i18)*/
              data!.media != null && data!.media!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: data!.media![0].originalUrl!,
                      imageBuilder: (context, imageProvider) => Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        height: Sizes.s20,
                        color: appColor(context).darkText,
                        width: Sizes.s20,
                      ).paddingAll(Insets.i14),
                      placeholder: (context, url) => Image.asset(
                              eImageAssets.noImageFound1,
                              fit: BoxFit.fill,
                              height: Sizes.s22,
                              width: Sizes.s22)
                          .paddingAll(Insets.i18),
                      errorWidget: (context, url, error) => Image.asset(
                              eImageAssets.noImageFound1,
                              fit: BoxFit.fill,
                              height: Sizes.s22,
                              width: Sizes.s22)
                          .paddingAll(Insets.i18),
                    )
                  : selectedIndex == index
                      ? Image.asset(eImageAssets.noImageFound1,
                              color: appColor(context).primary,
                              fit: BoxFit.cover,
                              height: Sizes.s22,
                              width: Sizes.s22)
                          .paddingAll(Insets.i18)
                      : Image.asset(eImageAssets.noImageFound1,
                              fit: BoxFit.cover,
                              height: Sizes.s22,
                              width: Sizes.s22)
                          .paddingAll(Insets.i18)),
      const VSpace(Sizes.s8),
      if (isExapnded)
        Expanded(
          child: Text(data!.title!,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: appCss.dmDenseRegular13.textColor(
                      selectedIndex == index
                          ? appColor(context).primary
                          : appColor(context).darkText))
              .width(isCategories ? Sizes.s76 : Sizes.s70),
        ),
      if (!isExapnded)
        Text(data!.title!,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: appCss.dmDenseRegular13.textColor(selectedIndex == index
                    ? appColor(context).primary
                    : appColor(context).darkText))
            .width(isCategories ? Sizes.s76 : Sizes.s70)
    ]).inkWell(onTap: onTap);
  }
}
