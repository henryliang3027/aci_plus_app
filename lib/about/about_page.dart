import 'package:dsim_app/home/views/home_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
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
  late final String _dsimVersion;

  @override
  void initState() {
    _kExpandedHeight = 160.0;
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _dsimVersion = 'V 2.0.0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double horizontalTitlePadding() {
      const kBasePadding = 40.0;
      const kMultiplier = 4.5;

      if (_scrollController.hasClients) {
        if (_scrollController.offset < (_kExpandedHeight / 2)) {
          // In case 50%-100% of the expanded height is viewed
          return kBasePadding;
        } else if (_scrollController.offset >
            (_kExpandedHeight - kToolbarHeight)) {
          // In case 0% of the expanded height is viewed
          return 0.0;
        } else {
          // In case 0%-50% of the expanded height is viewed
          return (_scrollController.offset - (_kExpandedHeight / 2)) *
                  kMultiplier +
              kBasePadding;
        }
      }

      return kBasePadding;
    }

    double getTitleFontSize() {
      const defaultSize = 30.0;

      if (_scrollController.hasClients) {
        if (_scrollController.offset < (_kExpandedHeight / 2)) {
          // In case 50%-100% of the expanded height is viewed
          return 30;
        }

        if (_scrollController.offset > (_kExpandedHeight - kToolbarHeight)) {
          // In case 0% of the expanded height is viewed
          return 22;
        }

        // In case 0%-50% of the expanded height is viewed
        return 30 - (_scrollController.offset - (_kExpandedHeight / 2)) * 0.3;
      }

      return defaultSize;
    }

    bool isCenterTitle() {
      if (_scrollController.hasClients) {
        if (_scrollController.offset > (_kExpandedHeight - kToolbarHeight)) {
          // In case 0% of the expanded height is viewed
          return true;
        }

        return false;
      }

      return false;
    }

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
            flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.fromLTRB(
                  horizontalTitlePadding(),
                  10.0,
                  0.0,
                  10.0,
                ),
                centerTitle: isCenterTitle(),
                title: Text(
                  AppLocalizations.of(context).aboutUs,
                  style: TextStyle(
                    fontSize: getTitleFontSize(),
                  ),
                  textAlign: TextAlign.center,
                ),
                background: Stack(
                  children: [
                    Container(
                      color: Colors.black,
                    ),
                    Positioned(
                      top: 70.0,
                      right: 10.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.all(0.0),
                          visualDensity: const VisualDensity(
                            horizontal: -4.0,
                            vertical: -4.0,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          _dsimVersion,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {},
                      ),
                    ),
                  ],
                )),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildParagraph(
                  paragraph:
                      AppLocalizations.of(context).aboutArticleParagraph1,
                ),
                buildParagraph(
                  paragraph:
                      AppLocalizations.of(context).aboutArticleParagraph2,
                ),
                buildParagraph(
                  paragraph:
                      AppLocalizations.of(context).aboutArticleParagraph3,
                ),
                buildParagraph(
                  paragraph:
                      AppLocalizations.of(context).aboutArticleParagraph4,
                ),
                buildParagraph(
                  paragraph:
                      AppLocalizations.of(context).aboutArticleParagraph5,
                ),
                const SizedBox(
                  height: 30,
                ),
                buildParagraph(
                  paragraph:
                      AppLocalizations.of(context).aboutArticleDigitalTeamTitle,
                  fontSize: 20,
                ),
                buildParagraph(
                  paragraph: AppLocalizations.of(context)
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
                              AppLocalizations.of(context).projectManager,
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
                              AppLocalizations.of(context).websiteDesigner,
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
                              AppLocalizations.of(context)
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
                              AppLocalizations.of(context).systemEngineer,
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
                        height: 20.0,
                      ),
                      const SizedBox(
                        height: 10,
                        child: Image(
                          image: AssetImage('assets/address.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const SizedBox(
                        height: 9,
                        child: Image(
                          image: AssetImage('assets/2022.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
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
