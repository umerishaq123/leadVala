import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:leadvala/common_tap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config.dart';

class PersonalDetailLayout extends StatefulWidget {
  final String? email, phone, code;
  final List<KnownLanguageModel>? knownLanguage;

  const PersonalDetailLayout({
    super.key,
    this.email,
    this.phone,
    this.knownLanguage,
    this.code,
  });

  @override
  State<PersonalDetailLayout> createState() => _PersonalDetailLayoutState();
}

class _PersonalDetailLayoutState extends State<PersonalDetailLayout> {
  @override
  Widget build(BuildContext context) {
    String? dateTime;
    void showFollowUpBottomSheet(BuildContext context) {
      DateTime? selectedDate;
      TimeOfDay? selectedTime;

      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: appColor(context).themeData.scaffoldBackgroundColor,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      capitalizeFirstLetter("add follow-up"),
                      style: appCss.dmDenseSemiBold14
                          .textColor(appColor(context).darkText),
                    ),
                    const SizedBox(height: 10),

                    // Date Picker
                    ListTile(
                      leading:
                          const Icon(Icons.calendar_today, color: Colors.blue),
                      title: Text(
                        selectedDate != null
                            ? capitalizeFirstLetter(
                                DateFormat('yyyy-MM-dd').format(selectedDate!))
                            : capitalizeFirstLetter("select date"),
                        style: appCss.dmDenseSemiBold14
                            .textColor(appColor(context).darkText),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                    primary: appColor(context).primary),
                                buttonTheme: const ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedDate != null) {
                          setState(() => selectedDate = pickedDate);
                        }
                      },
                    ),

                    // Time Picker
                    ListTile(
                      leading:
                          const Icon(Icons.access_time, color: Colors.blue),
                      title: Text(
                        selectedTime != null
                            ? capitalizeFirstLetter(
                                selectedTime!.format(context))
                            : capitalizeFirstLetter("select time"),
                        style: appCss.dmDenseSemiBold14
                            .textColor(appColor(context).darkText),
                      ),
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                    primary: appColor(context).primary),
                                buttonTheme: const ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedTime != null) {
                          setState(() => selectedTime = pickedTime);
                        }
                      },
                    ),

                    const SizedBox(height: 15),

                    // Confirm Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColor(context).primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (selectedDate == null || selectedTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(capitalizeFirstLetter(
                                    "please select both date and time")),
                              ),
                            );
                            return;
                          }

                          // Format Date
                          String formattedDate =
                              DateFormat('dd MMM yyyy').format(selectedDate!);

                          // Format Time
                          DateTime fullDateTime = DateTime(
                            selectedDate!.year,
                            selectedDate!.month,
                            selectedDate!.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );
                          String formattedTime =
                              DateFormat('hh:mm a').format(fullDateTime);

                          // Combine Date and Time
                          setState(() =>
                              dateTime = "$formattedDate | $formattedTime");
                          dateTime = "$formattedDate | $formattedTime";

                          log("Selected Follow-Up: $dateTime");

                          Navigator.pop(context); // Close Bottom Sheet

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(capitalizeFirstLetter(
                                  "follow-up scheduled for $dateTime")),
                            ),
                          );
                        },
                        child: Text(capitalizeFirstLetter("confirm"),
                            style: appCss.dmDenseMedium18.textColor(
                              appColor(context).darkText,
                            )),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    log("phone exists: ${widget.phone != null && widget.phone != "null"}");
    log("phone: ${widget.phone}");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PersonalInfoRowLayout(
          icon: eSvgAssets.mail,
          title: appFonts.mail,
          content: widget.email,
        ).inkWell(
          onTap: () => commonUrlTap(context, widget.email ?? ""),
        ),
        if (widget.phone != null && widget.phone != "null")
          PersonalInfoRowLayout(
            icon: eSvgAssets.phone1,
            title: appFonts.call,
            // content: "${widget.code} ${widget.phone}",
            content: "${11} ${widget.phone}",
          ).paddingSymmetric(vertical: Insets.i20),
// add section call or phone
        if (widget.phone != null && widget.phone!.isNotEmpty)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButton(Icons.call, "Call", Colors.green, () {
                _launchURL("tel:${widget.phone}");
              }),
              _buildButton(Icons.message, "Message", Colors.blue, () {
                _launchURL("sms:${widget.phone}");
              }),
              _buildButton(Icons.chat, "WhatsApp", Colors.teal, () {
                _launchURL("https://wa.me/${widget.phone}");
              }),
            ],
          ),
//  end of this part
        // const SizedBox(height: 10),
        if (widget.knownLanguage?.isNotEmpty ?? false)
          Row(
            children: [
              SvgPicture.asset(
                eSvgAssets.country,
                colorFilter: ColorFilter.mode(
                    appColor(context).lightText, BlendMode.srcIn),
              ),
              const HSpace(Sizes.s6),
              Text(
                language(context, appFonts.knowLanguage),
                style: appCss.dmDenseMedium12
                    .textColor(appColor(context).lightText),
              ),
            ],
          ),
        const VSpace(Sizes.s7),
        if (widget.knownLanguage?.isNotEmpty ?? false)
          Wrap(
            direction: Axis.horizontal,
            children: widget.knownLanguage!
                .map(
                    (e) => LanguageLayout(title: e.key).paddingOnly(bottom: 10))
                .toList(),
          ),
        const VSpace(Sizes.s7),
        Row(
          children: [
            SvgPicture.asset(
              eSvgAssets.clock,
              colorFilter: ColorFilter.mode(
                  appColor(context).lightText, BlendMode.srcIn),
            ),
            const HSpace(Sizes.s6),
            Text(
              language(context, 'Follow Up'),
              style:
                  appCss.dmDenseMedium13.textColor(appColor(context).lightText),
            ),
            const Spacer(),
            Text(dateTime ?? ''),
            TextButton(
              onPressed: () {
                showFollowUpBottomSheet(context);
              },
              child: Text(
                dateTime != null
                    ? dateTime.toString()
                    : language(context, 'Add Follow Up'),
                style:
                    appCss.dmDenseMedium15.textColor(appColor(context).primary),
              ),
            ),
          ],
        ),
        const VSpace(Sizes.s7),
        Row(
          children: [
            SvgPicture.asset(
              eSvgAssets.accountTag,
              colorFilter: ColorFilter.mode(
                  appColor(context).lightText, BlendMode.srcIn),
            ),
            const HSpace(Sizes.s6),
            Text(
              language(context, 'Notes'),
              style:
                  appCss.dmDenseMedium13.textColor(appColor(context).lightText),
            ),
          ],
        ),
        const VSpace(Sizes.s7),
        // change of the text
        // TextField(
        //   maxLines: 5,
        //   decoration: InputDecoration(
        //     hintText: language(context, 'Write your notes here...'),
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //   ),
        // ),
        TextField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: language(context, 'Write your notes here...'),
              hintStyle: TextStyle(
                  color: appColor(context)
                      .lightText), // Optional: Light hint color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: appColor(context).lightText), // ✅ White Border
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: appColor(context).lightText), // ✅ White Border
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: appColor(context).lightText), // ✅ Thicker on focus
              ),
            ),
            style: TextStyle(
                color: appColor(context)
                    .lightText), // ✅ Text color inside the field
            cursorColor: appColor(context).lightText // ✅ White blinking cursor
            ),
      ],
    )
        .paddingAll(Insets.i12)
        .boxShapeExtension(color: appColor(context).whiteBg);
  }

  Widget _buildButton(
      IconData icon, String text, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 5),
          Text(text,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }
}
