import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/information/bloc/information18/information18_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class About18Form extends StatelessWidget {
  const About18Form({super.key});

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
          child: const About()),
    );
  }
}

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Information18Bloc, Information18State>(
      builder: (context, state) {
        Widget getAppVersionCard({
          required String title,
          required String appVersion,
        }) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      appVersion,
                      style: const TextStyle(
                        fontSize: CustomStyle.sizeL,
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                      mainAxisAlignment: MainAxisAlignment.end,
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
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.all(1.0),
                                ),
                                child: Text(
                                  linkText,
                                  style: const TextStyle(
                                    fontSize: CustomStyle.sizeL,
                                  ),
                                  textAlign: TextAlign.end,
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

        Widget buildContent({
          required String appVersion,
        }) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Column(
              children: [
                getAppVersionCard(
                  title: AppLocalizations.of(context)!.appVersion,
                  appVersion: appVersion,
                ),
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

        return BlocBuilder<Information18Bloc, Information18State>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 120,
                ),
                buildContent(
                  appVersion: state.appVersion,
                ),
                const Spacer(),
                buildFooter(),
              ],
            );
          },
        );
      },
    );
  }
}
