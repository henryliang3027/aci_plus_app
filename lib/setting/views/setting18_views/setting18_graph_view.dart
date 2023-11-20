import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/setting/bloc/setting18_graph_view_bloc/setting18_graph_view_bloc.dart';
import 'package:aci_plus_app/setting/views/circuit_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable/touchable.dart';
import 'package:xml/xml.dart';

class Setting18GraphView extends StatelessWidget {
  const Setting18GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    setFullScreenOrientation();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: const _GraphInteractor(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(
          side: BorderSide.none,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(200),
        child: Icon(
          Icons.list,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () {
          setPreferredOrientation();
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _GraphInteractor extends StatelessWidget {
  const _GraphInteractor({super.key});

  @override
  Widget build(BuildContext context) {
    print(
        '${MediaQuery.of(context).size.width}, ${MediaQuery.of(context).size.height}');

    return BlocBuilder<Setting18GraphViewBloc, Setting18GraphViewState>(
      builder: (context, state) {
        return PopScope(
          onPopInvoked: (didPop) {
            setPreferredOrientation();
          },

          child: InteractiveViewer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                // Container(
                //   width: double.maxFinite,
                //   height: double.maxFinite,
                //   child: const Image(
                //     image: AssetImage('assets/circuits/MB_1.8G.png'),
                //     // fit: BoxFit.cover,
                //   ),
                // ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CanvasTouchDetector(
                    builder: (context) => CustomPaint(
                        painter: CircuitPainter(
                      context: context,
                      svgImage: state.svgImage,
                    )),
                    gesturesToOverride: [GestureType.onTapUp],
                  ),
                ),
              ],
            ),
          ),

          // Stack(
          //   alignment: AlignmentDirectional.center,
          //   children: [
          //     const Image(
          //       image: AssetImage('assets/circuits/MB_1.8G.png'),
          //       fit: BoxFit.cover,
          //     ),

          //     // Positioned(
          //     //   left: centerX - 175,
          //     //   top: centerY - 199,
          //     //   child: Material(
          //     //     color: Colors.transparent,
          //     //     child: InkWell(
          //     //       child: Container(
          //     //         width: 68,
          //     //         height: 62,
          //     //         decoration: BoxDecoration(
          //     //             color: Colors.transparent,
          //     //             border: Border.all(color: Colors.blue)),
          //     //       ),
          //     //       onTap: () {
          //     //         showResultDialog(context: context, message: 'Button 1');
          //     //       },
          //     //     ),
          //     //   ),
          //     // ),
          //     // Positioned(
          //     //   left: 352,
          //     //   top: 18,
          //     //   child: Material(
          //     //     color: Colors.transparent,
          //     //     child: InkWell(
          //     //       child: Container(
          //     //         width: 68,
          //     //         height: 62,
          //     //         decoration: BoxDecoration(
          //     //             color: Colors.transparent,
          //     //             border: Border.all(color: Colors.blue)),
          //     //       ),
          //     //       onTap: () {
          //     //         showResultDialog(context: context, message: 'Button 2');
          //     //       },
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          // ),
        );
      },
    );
  }
}

Future<List<String>> loadSvgImage({required String svgImage}) async {
  List<String> maps = [];
  String generalString = await rootBundle.loadString(svgImage);

  XmlDocument document = XmlDocument.parse(generalString);

  final paths = document.findAllElements('path');

  for (var element in paths) {
    String partPath = element.getAttribute('d').toString();
    maps.add(partPath);
  }

  return maps;
}
