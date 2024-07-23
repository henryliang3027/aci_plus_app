import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/setting/bloc/setting18_graph_view/setting18_graph_view_bloc.dart';
import 'package:aci_plus_app/setting/views/circuit_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:touchable/touchable.dart';

class Setting18GraphView extends StatelessWidget {
  const Setting18GraphView({super.key});

  @override
  Widget build(BuildContext context) {
    setFullScreenOrientation();
    HomeState homeState = context.read<HomeBloc>().state;
    String partId = homeState.characteristicData[DataKey.partId] ?? '';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: _GraphInteractor(
        partId: partId,
      ),
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
  const _GraphInteractor({
    required this.partId,
  });

  final String partId;

  @override
  Widget build(BuildContext context) {
    print(
        '${MediaQuery.of(context).size.width}, ${MediaQuery.of(context).size.height}');

    return BlocBuilder<Setting18GraphViewBloc, Setting18GraphViewState>(
      builder: (context, state) {
        // 讀取 SVG 圖, 放在 stack 的最下層
        final Widget svgGraph = SvgPicture.asset(state.graphFilePath);

        return PopScope(
          onPopInvoked: (didPop) async {
            setPreferredOrientation();
          },
          child: InteractiveViewer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                svgGraph,
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: CanvasTouchDetector(
                    builder: (context) => CustomPaint(
                        painter: CircuitPainter(
                      context: context,
                      svgImage: state.svgImage,
                      partId: partId,
                      onDone: () => context
                          .read<Setting18GraphViewBloc>()
                          .add(const ValueTextUpdated()),
                    )),
                    gesturesToOverride: const [GestureType.onTapUp],
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
