import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:aci_plus_app/home/views/home_bottom_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late final ScrollController _scrollController;
  late final double _kExpandedHeight;

  @override
  void initState() {
    _kExpandedHeight = 160.0;
    _scrollController = ScrollController()..addListener(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildParagraph({
      required String paragraph,
      double fontSize = 16,
    }) {
      return Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 0, left: 30, right: 30),
        child: Text(
          paragraph,
          style: TextStyle(fontSize: fontSize),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: _kExpandedHeight,
            flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              double percentage = (constraints.maxHeight - kToolbarHeight) /
                  (_kExpandedHeight - kToolbarHeight);

              Alignment titleAlignment = Alignment.bottomCenter;
              if (percentage <= 0.5) {
                titleAlignment = Alignment.bottomCenter;
              } else {
                titleAlignment = Alignment.bottomLeft;
              }

              return FlexibleSpaceBar(
                titlePadding: const EdgeInsets.fromLTRB(26.0, 10.0, 26.0, 14.0),
                centerTitle: false,
                title: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  alignment: titleAlignment,
                  child: Text(
                    AppLocalizations.of(context)!.aboutUs,
                    style: TextStyle(
                      //  fontSize: 24,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                background: Stack(
                  children: [
                    Container(
                      color: Colors.black,
                    ),
                  ],
                ),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildParagraph(
                  paragraph:
                      AppLocalizations.of(context)!.aboutArticleParagraph1,
                ),
                buildParagraph(
                  paragraph:
                      AppLocalizations.of(context)!.aboutArticleParagraph2,
                ),
                buildParagraph(
                  paragraph:
                      AppLocalizations.of(context)!.aboutArticleParagraph3,
                ),
                buildParagraph(
                  paragraph:
                      AppLocalizations.of(context)!.aboutArticleParagraph4,
                ),
                buildParagraph(
                  paragraph:
                      AppLocalizations.of(context)!.aboutArticleParagraph5,
                ),
                const SizedBox(
                  height: 30,
                ),
                buildParagraph(
                  paragraph: AppLocalizations.of(context)!
                      .aboutArticleDigitalTeamTitle,
                  fontSize: 20,
                ),
                buildParagraph(
                  paragraph: AppLocalizations.of(context)!
                      .aboutArticleDigitalTeamParagraph,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, bottom: 0, left: 30, right: 30),
                  child: Table(
                    children: [
                      TableRow(children: [
                        Container(
                          alignment: Alignment.center,
                          child: const Image(
                            image:
                                AssetImage('assets/about_project_manager.png'),
                            //fit: BoxFit.contain,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.fill,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Colors.grey,
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.projectManager,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 0, left: 30, right: 30),
                  child: Table(
                    children: [
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.fill,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Colors.grey,
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.websiteDesigner,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: const Image(
                            image:
                                AssetImage('assets/about_web_ui_designer.png'),
                            //fit: BoxFit.contain,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 0, left: 30, right: 30),
                  child: Table(
                    children: [
                      TableRow(children: [
                        Container(
                          alignment: Alignment.center,
                          child: const Image(
                            image: AssetImage(
                                'assets/about_frontend_backend_engineer.png'),
                            //fit: BoxFit.contain,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.fill,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Colors.grey,
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .frontendBackendEngineer,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 0, left: 30, right: 30),
                  child: Table(
                    children: [
                      TableRow(children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.fill,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Colors.grey,
                                  Colors.white,
                                ],
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.systemEngineer,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: const Image(
                            image:
                                AssetImage('assets/about_system_engineer.png'),
                            //fit: BoxFit.contain,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Container(
                  width: double.maxFinite,
                  height: 300.0,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topRight,
                      radius: 1.0,
                      colors: [
                        Colors.grey,
                        Colors.black,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      const Row(
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
                          // SizedBox(
                          //   width: 20.0,
                          // ),
                          // SizedBox(
                          //   height: 26,
                          //   child: Image(
                          //     image: AssetImage('assets/ACI+.png'),
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(
                        height: CustomStyle.sizeXXL,
                      ),
                      const SizedBox(
                        height: 10,
                        child: Image(
                          image: AssetImage('assets/address.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: CustomStyle.sizeXXL,
                      ),
                      const SizedBox(
                        height: 9,
                        child: Image(
                          image: AssetImage('assets/2022.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: CustomStyle.sizeXXL,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        pageController: widget.pageController,
        selectedIndex: 4,
        onTap: (int index) {
          widget.pageController.jumpToPage(
            index,
          );
        },
      ),
    );
  }
}
