import 'package:aci_plus_app/core/custom_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class About18Page extends StatefulWidget {
  const About18Page({super.key});

  @override
  State<About18Page> createState() => _About18PageState();
}

class _About18PageState extends State<About18Page> {
  @override
  void initState() {}

  Widget buildCard(IconData icon, String title, String info) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(info),
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
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.primary, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCard(Icons.info, 'App Version', 'state.appVersion'),
            buildCard(Icons.support, 'Support', 'state.supportInfo'),
            buildCard(Icons.web, 'Website', 'state.website'),
            Spacer(),
            buildFooter(),
          ],
        ),
      ),

      // Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     // SliverAppBar(
      //     //   pinned: true,
      //     //   expandedHeight: 150,
      //     //   flexibleSpace: LayoutBuilder(
      //     //       builder: (BuildContext context, BoxConstraints constraints) {
      //     //     Alignment titleAlignment = Alignment.bottomLeft;

      //     //     return FlexibleSpaceBar(
      //     //       titlePadding: const EdgeInsets.fromLTRB(26.0, 10.0, 26.0, 14.0),
      //     //       centerTitle: false,
      //     //       title: AnimatedContainer(
      //     //         duration: const Duration(milliseconds: 300),
      //     //         alignment: titleAlignment,
      //     //         child: Text(
      //     //           AppLocalizations.of(context)!.aboutUs,
      //     //           style: TextStyle(
      //     //             //  fontSize: 24,
      //     //             color: Theme.of(context).colorScheme.onPrimary,
      //     //           ),
      //     //           textAlign: TextAlign.center,
      //     //         ),
      //     //       ),
      //     //       background: Stack(
      //     //         children: [
      //     //           Container(
      //     //             color: Colors.black,
      //     //           ),
      //     //         ],
      //     //       ),
      //     //     );
      //     //   }),
      //     // ),
      //     // SliverToBoxAdapter(
      //     //   child: Column(
      //     //     mainAxisAlignment: MainAxisAlignment.end,
      //     //     crossAxisAlignment: CrossAxisAlignment.start,
      //     //     children: [
      //     //       Card(
      //     //         color: Theme.of(context).colorScheme.onPrimary,
      //     //         surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      //     //         child: Padding(
      //     //           padding: const EdgeInsets.all(16.0),
      //     //           child: Row(
      //     //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     //             children: [
      //     //               Text(
      //     //                 AppLocalizations.of(context)!.appVersion,
      //     //                 style: Theme.of(context).textTheme.titleLarge,
      //     //               ),
      //     //               Text(
      //     //                 'state.appVersion',
      //     //                 style: const TextStyle(
      //     //                   fontSize: CustomStyle.sizeL,
      //     //                 ),
      //     //               ),
      //     //             ],
      //     //           ),
      //     //         ),
      //     //       ),
      //     //       Card(
      //     //         color: Theme.of(context).colorScheme.onPrimary,
      //     //         surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      //     //         child: Padding(
      //     //           padding: const EdgeInsets.all(16.0),
      //     //           child: Row(
      //     //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     //             children: [
      //     //               Text(
      //     //                 AppLocalizations.of(context)!.support,
      //     //                 style: Theme.of(context).textTheme.titleLarge,
      //     //               ),
      //     //               Text(
      //     //                 'state.appVersion',
      //     //                 style: const TextStyle(
      //     //                   fontSize: CustomStyle.sizeL,
      //     //                 ),
      //     //               ),
      //     //             ],
      //     //           ),
      //     //         ),
      //     //       ),
      //     //       Card(
      //     //         color: Theme.of(context).colorScheme.onPrimary,
      //     //         surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      //     //         child: Padding(
      //     //           padding: const EdgeInsets.all(16.0),
      //     //           child: Row(
      //     //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     //             children: [
      //     //               Text(
      //     //                 AppLocalizations.of(context)!.website,
      //     //                 style: Theme.of(context).textTheme.titleLarge,
      //     //               ),
      //     //               Text(
      //     //                 'state.appVersion',
      //     //                 style: const TextStyle(
      //     //                   fontSize: CustomStyle.sizeL,
      //     //                 ),
      //     //               ),
      //     //             ],
      //     //           ),
      //     //         ),
      //     //       ),
      //     Card(
      //       color: Theme.of(context).colorScheme.onPrimary,
      //       surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      //       child: Padding(
      //         padding: const EdgeInsets.all(16.0),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text(
      //               AppLocalizations.of(context)!.appVersion,
      //               style: Theme.of(context).textTheme.titleLarge,
      //             ),
      //             Text(
      //               'state.appVersion',
      //               style: const TextStyle(
      //                 fontSize: CustomStyle.sizeL,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     Card(
      //       color: Theme.of(context).colorScheme.onPrimary,
      //       surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      //       child: Padding(
      //         padding: const EdgeInsets.all(16.0),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text(
      //               AppLocalizations.of(context)!.support,
      //               style: Theme.of(context).textTheme.titleLarge,
      //             ),
      //             Text(
      //               'state.appVersion',
      //               style: const TextStyle(
      //                 fontSize: CustomStyle.sizeL,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     Card(
      //       color: Theme.of(context).colorScheme.onPrimary,
      //       surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      //       child: Padding(
      //         padding: const EdgeInsets.all(16.0),
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text(
      //               AppLocalizations.of(context)!.website,
      //               style: Theme.of(context).textTheme.titleLarge,
      //             ),
      //             Text(
      //               'state.appVersion',
      //               style: const TextStyle(
      //                 fontSize: CustomStyle.sizeL,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     Container(
      //       width: double.maxFinite,
      //       height: 300.0,
      //       decoration: const BoxDecoration(
      //         gradient: RadialGradient(
      //           center: Alignment.topRight,
      //           radius: 1.0,
      //           colors: [
      //             Colors.grey,
      //             Colors.black,
      //           ],
      //         ),
      //       ),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Expanded(
      //             child: Container(),
      //           ),
      //           const Row(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               SizedBox(
      //                 height: 26,
      //                 child: Image(
      //                   image: AssetImage('assets/twoway.png'),
      //                   fit: BoxFit.cover,
      //                 ),
      //               ),
      //               SizedBox(
      //                 width: 20.0,
      //               ),
      //               SizedBox(
      //                 height: 26,
      //                 child: Image(
      //                   image: AssetImage('assets/ACI.png'),
      //                   fit: BoxFit.cover,
      //                 ),
      //               ),
      //               // SizedBox(
      //               //   width: 20.0,
      //               // ),
      //               // SizedBox(
      //               //   height: 26,
      //               //   child: Image(
      //               //     image: AssetImage('assets/ACI+.png'),
      //               //     fit: BoxFit.cover,
      //               //   ),
      //               // ),
      //             ],
      //           ),
      //           const SizedBox(
      //             height: CustomStyle.sizeXXL,
      //           ),
      //           const SizedBox(
      //             height: 10,
      //             child: Image(
      //               image: AssetImage('assets/address.png'),
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //           const SizedBox(
      //             height: CustomStyle.sizeXXL,
      //           ),
      //           const SizedBox(
      //             height: 9,
      //             child: Image(
      //               image: AssetImage('assets/2022.png'),
      //               fit: BoxFit.cover,
      //             ),
      //           ),
      //           const SizedBox(
      //             height: CustomStyle.sizeXXL,
      //           ),
      //         ],
      //       ),
      //     ),
      //     //     ],
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }
}
