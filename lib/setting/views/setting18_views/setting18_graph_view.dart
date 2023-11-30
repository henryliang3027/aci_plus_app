import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/setting/bloc/setting18_graph_view_bloc/setting18_graph_view_bloc.dart';
import 'package:aci_plus_app/setting/views/circuit_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touchable/touchable.dart';

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
      resizeToAvoidBottomInset: false,
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
        return WillPopScope(
          onWillPop: () async {
            setPreferredOrientation();
            return true;
          },
          child: InteractiveViewer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
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
        );
      },
    );
  }
}
