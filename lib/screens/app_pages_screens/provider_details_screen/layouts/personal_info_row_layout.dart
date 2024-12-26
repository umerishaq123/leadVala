import '../../../../config.dart';

class PersonalInfoRowLayout extends StatelessWidget {
  final String? icon,title,content;
  const PersonalInfoRowLayout({super.key,this.title,this.icon,this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(icon!,colorFilter: ColorFilter.mode(appColor(context).lightText, BlendMode.srcIn),height: Sizes.s18,width: Sizes.s18,),
            const HSpace(Sizes.s6),
            Text(language(context, title!),style: appCss.dmDenseMedium12.textColor(appColor(context).lightText))
          ]
        ),
        const VSpace(Sizes.s5),
        Text(capitalizeFirstLetter(content),style: appCss.dmDenseSemiBold14.textColor(appColor(context).darkText))
      ]
    );
  }
}
