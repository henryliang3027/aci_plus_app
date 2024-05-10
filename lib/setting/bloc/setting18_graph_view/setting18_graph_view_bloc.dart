import 'package:aci_plus_app/setting/model/svg_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart';

part 'setting18_graph_view_event.dart';
part 'setting18_graph_view_state.dart';

class Setting18GraphViewBloc
    extends Bloc<Setting18GraphViewEvent, Setting18GraphViewState> {
  Setting18GraphViewBloc({
    required String graphFilePath,
  })  : _graphFilePath = graphFilePath,
        super(const Setting18GraphViewState()) {
    on<LoadGraphRequested>(_onLoadGraphRequested);

    add(const LoadGraphRequested());
  }

  final String _graphFilePath;

  Future<void> _onLoadGraphRequested(
    LoadGraphRequested event,
    Emitter<Setting18GraphViewState> emit,
  ) async {
    String generalString = await rootBundle.loadString(_graphFilePath);

    XmlDocument document = XmlDocument.parse(generalString);

    final paths = document.findAllElements('path');
    final rects = document.findAllElements('rect');
    final header = document.findElements('svg').toList()[0];
    final double width = double.parse(header.getAttribute('width').toString());
    final double height =
        double.parse(header.getAttribute('height').toString());

    List<Component> components = [];
    List<Box> boxes = [];

    for (var element in paths) {
      String partColor =
          'ff${element.getAttribute('fill').toString().substring(1)}';
      String partPath = element.getAttribute('d').toString();

      components.add(Component(color: partColor, path: partPath));
    }

    for (var element in rects) {
      String moduleName = element.getAttribute('module').toString();
      double x = double.parse(element.getAttribute('x').toString());
      double y = double.parse(element.getAttribute('y').toString());
      double width = double.parse(element.getAttribute('width').toString());
      double height = double.parse(element.getAttribute('height').toString());

      boxes.add(Box(
        moduleName: moduleName,
        x: x,
        y: y,
        width: width,
        height: height,
      ));
    }

    SVGImage svgImage = SVGImage(
      width: width,
      height: height,
      components: components,
      boxes: boxes,
    );

    emit(state.copyWith(
      svgImage: svgImage,
    ));
  }
}
