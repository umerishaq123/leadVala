import '../../../config.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangePasswordProvider>(
        builder: (context1, resetPass, child) {
      return LoadingComponent(
          child: StatefulWrapper(
        onInit: () => Future.delayed(DurationClass.ms150).then((value) =>
            resetPass.loadingImage ==
            resetPass.loadImage(eImageAssets.userSlider)),
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                leadingWidth: 80,
                leading: CommonArrow(
                    arrow: eSvgAssets.arrowLeft,
                    onTap: () => route.pop(context)).paddingAll(Insets.i8),
                title: Text(language(context, appFonts.changePassword),
                    style: appCss.dmDenseBold18
                        .textColor(appColor(context).darkText))),
            body: SafeArea(
                child: SingleChildScrollView(
                    child: Column(children: [
              Form(
                  key: resetPass.resetFormKey,
                  child: const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [VSpace(Sizes.s30), ChangePasswordLayout()])
                      .alignment(Alignment.centerLeft))
            ]).paddingSymmetric(horizontal: Insets.i20)))),
      ));
    });
  }
}
