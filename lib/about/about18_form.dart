import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class About18Form extends StatelessWidget {
  const About18Form({
    super.key,
    required this.appVersion,
  });

  final String appVersion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.aboutUs),
        centerTitle: true,
      ),
      body: Container(
          // 移除 appbar 跟 body 中間白色細長的區域
          transform: Matrix4.translationValues(
            0,
            -0.2,
            0,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).colorScheme.primary, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: About(appVersion: appVersion)),
    );
  }
}

class About extends StatelessWidget {
  const About({
    super.key,
    required this.appVersion,
  });

  final String appVersion;

  @override
  Widget build(BuildContext context) {
    Widget getAppVersionCard() {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          height: 58,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.appVersion,
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  appVersion,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget getLinkCard({
      required String title,
      required String linkText,
    }) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // const SizedBox(
                    //   width: 30,
                    // ),
                    Flexible(
                      child: RichText(
                        text: WidgetSpan(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              visualDensity: const VisualDensity(
                                  vertical: -4.0, horizontal: -4.0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.all(1.0),
                            ),
                            child: Text(
                              linkText,
                              style: const TextStyle(
                                fontSize: CustomStyle.sizeL,
                              ),
                            ),
                            onPressed: () async {
                              Uri uri = Uri.parse(linkText);
                              launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget buildContent() {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Column(
          children: [
            getAppVersionCard(),
            getLinkCard(
              title: AppLocalizations.of(context)!.support,
              linkText: 'https://acicomms.com/support/',
            ),
            getLinkCard(
              title: AppLocalizations.of(context)!.website,
              linkText: 'https://acicomms.com/',
            ),
          ],
        ),
      );
    }

    Widget buildFooter() {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 26,
                child: Image(
                  image: AssetImage('assets/twoway.png'),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              SizedBox(
                height: 26,
                child: Image(
                  image: AssetImage('assets/ACI.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          SizedBox(
            height: CustomStyle.sizeXXL,
          ),
          SizedBox(
            height: 10,
            child: Image(
              image: AssetImage('assets/address.png'),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: CustomStyle.sizeXXL,
          ),
          SizedBox(
            height: 9,
            child: Image(
              image: AssetImage('assets/2022.png'),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: CustomStyle.sizeXXL,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 40,
        ),
        buildContent(),
        const Spacer(),
        buildFooter(),
      ],
    );
  }
}
