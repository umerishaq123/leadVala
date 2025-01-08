import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../config.dart';
import 'package:leadvala/models/booking_response_model.dart' as booking_model;

class BookingLayout extends StatefulWidget {
  final booking_model.Datum? data;
  final GestureTapCallback? onTap, editLocationTap, editDateTimeTap;
  final int? index;

  const BookingLayout({
    super.key,
    this.data,
    this.onTap,
    this.index,
    this.editLocationTap,
    this.editDateTimeTap,
  });

  @override
  State<BookingLayout> createState() => _BookingLayoutState();
}

class _BookingLayoutState extends State<BookingLayout> {
  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: true);

    if (widget.data == null) {
      return SizedBox.shrink(); // Fallback if no data is provided
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.data?.bookingNumber?.toString() ?? "N/A",
                            style: appCss.dmDenseMedium14.textColor(
                              appColor(context).primary,
                            ),
                          ),
                          const SizedBox(width: 5),
                          if (widget.data?.servicePackageId != null)
                            BookingStatusLayout(title: appFonts.package),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.data?.service?.title ?? "Unknown Service",
                        style: appCss.dmDenseMedium16.textColor(
                          appColor(context).darkText,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "${getSymbol(context)}${(currency(context).currencyVal * (widget.data?.subtotal ?? 0)).ceilToDouble().toStringAsFixed(2)}",
                            style: appCss.dmDenseBold18.textColor(
                              appColor(context).darkText,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (widget.data?.service?.discount != null)
                            Text(
                              "(${widget.data?.service?.discount}% ${language(context, appFonts.off)})",
                              style: appCss.dmDenseMedium14.textColor(
                                appColor(context).red,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                widget.data?.service?.media != null &&
                        (widget.data?.service?.media?.isNotEmpty ?? false)
                    ? CachedNetworkImage(
                        imageUrl: widget.data?.service?.media?[0]?.originalUrl ?? "",
                        imageBuilder: (context, imageProvider) => Container(
                          height: 84,
                          width: 84,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            shape: const SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius.all(
                                SmoothRadius(cornerRadius: 10, cornerSmoothing: 1),
                              ),
                            ),
                          ),
                        ),
                        placeholder: (context, url) => _placeholderImage(),
                        errorWidget: (context, url, error) => _placeholderImage(),
                      )
                    : _placeholderImage(),
              ],
            ),
            Image.asset(eImageAssets.bulletDotted)
                .paddingSymmetric(vertical: Insets.i12),
            _statusRows(),
            const SizedBox(height: 15),
          ],
        )
            .paddingSymmetric(vertical: Insets.i20, horizontal: Insets.i20)
            .decorated(
              color: appColor(context).whiteBg,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: appColor(context).darkText.withOpacity(0.06),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: appColor(context).stroke),
            )
            .paddingOnly(bottom: Insets.i15, left: 20, right: 20)
            .inkWell(onTap: widget.onTap),
      ],
    ).paddingOnly(bottom: 15);
  }

  Widget _statusRows() {
    return Column(
      children: [
        StatusRow(
          title: appFonts.bookingStatus,
          statusText: widget.data?.bookingStatus?.name ?? "",
          statusId: widget.data?.bookingStatusId,
        ),
        if (widget.data?.bookingStatus?.slug != appFonts.cancelled)
          StatusRow(
            title: appFonts.dateTime,
            title2: widget.data?.dateTime != null
                ? DateFormat("dd-MM-yyyy, hh:mm aa")
                    .format(widget.data?.dateTime ?? DateTime.now())
                : "N/A",
            onTap: widget.editDateTimeTap,
            style: appCss.dmDenseMedium12.textColor(appColor(context).darkText),
          ),
        StatusRow(
          title: appFonts.location,
          title2: widget.data?.address != null
              ? "${widget.data?.address?.address}-${widget.data?.address?.area ?? widget.data?.address?.state?.name}"
              : getAddress(context, widget.data?.addressId),
          onTap: widget.editLocationTap,
          style: appCss.dmDenseMedium12.textColor(appColor(context).darkText),
        ),
        StatusRow(
          title: appFonts.payment,
          title2: _getPaymentStatus(),
          style: appCss.dmDenseMedium12.textColor(appColor(context).online),
        ),
        StatusRow(
          title: appFonts.paymentMode,
          title2: widget.data?.paymentMethod == "on_hand" ||
                  widget.data?.paymentMethod == "cash"
              ? language(context, appFonts.cash)
              : capitalizeFirstLetter(widget.data?.paymentMethod ?? "N/A"),
          style: appCss.dmDenseMedium12.textColor(appColor(context).online),
        ),
      ],
    );
  }

  String _getPaymentStatus() {
    final paymentStatus = widget.data?.paymentStatus ?? "N/A";
    final isCompleted = paymentStatus.toLowerCase() == "completed";
    if (widget.data?.paymentMethod == "cash") {
      return isCompleted
          ? language(context, appFonts.paid)
          : language(context, appFonts.notPaid);
    }
    return paymentStatus;
  }

  Widget _placeholderImage() {
    return Container(
      height: 84,
      width: 84,
      decoration: ShapeDecoration(
        image: DecorationImage(
          image: AssetImage(eImageAssets.noImageFound1),
          fit: BoxFit.cover,
        ),
        shape: const SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 10, cornerSmoothing: 1),
          ),
        ),
      ),
    );
  }
}
