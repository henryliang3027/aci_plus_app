import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/setting/model/svg_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xml/xml.dart';

part 'setting18_ccor_node_graph_view_event.dart';
part 'setting18_ccor_node_graph_view_state.dart';

class Setting18CCorNodeGraphViewBloc extends Bloc<
    Setting18CCorNodeGraphViewEvent, Setting18CCorNodeGraphViewState> {
  Setting18CCorNodeGraphViewBloc({
    required String graphFilePath,
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        _graphFilePath = graphFilePath,
        super(const Setting18CCorNodeGraphViewState()) {
    on<LoadGraphRequested>(_onLoadGraphRequested);

    add(const LoadGraphRequested());
  }

  final String _graphFilePath;
  final Amp18CCorNodeRepository _amp18CCorNodeRepository;

  Future<void> _onLoadGraphRequested(
    LoadGraphRequested event,
    Emitter<Setting18CCorNodeGraphViewState> emit,
  ) async {
    Map<DataKey, String> characteristicDataCache =
        _amp18CCorNodeRepository.characteristicDataCache;

    String generalString = await rootBundle.loadString(_graphFilePath);

    XmlDocument document = XmlDocument.parse(generalString);

    final paths = document.findAllElements('path');
    final rects = document.findAllElements('rect');
    final textPlaceholders = document.findAllElements('text');
    final header = document.findElements('svg').toList()[0];
    final double width = double.parse(header.getAttribute('width').toString());
    final double height =
        double.parse(header.getAttribute('height').toString());

    List<Component> components = [];
    List<Box> boxes = [];
    List<ValueText> valueTexts = [];

    // 取得所有 DataKey 並轉為 list
    List<DataKey> dataKeys = DataKey.values;

    for (var element in paths) {
      String partColor =
          'ff${element.getAttribute('fill').toString().substring(1)}';
      String partPath = element.getAttribute('d').toString();

      components.add(Component(color: partColor, path: partPath));
    }

    for (var element in rects) {
      String? moduleName = element.getAttribute('module');

      if (moduleName != null) {
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
    }

    for (var textPlaceholder in textPlaceholders) {
      String? moduleName = textPlaceholder.getAttribute('module');

      if (moduleName != null) {
        double x = double.parse(textPlaceholder.getAttribute('x').toString());
        double y = double.parse(textPlaceholder.getAttribute('y').toString());
        DataKey dataKey =
            dataKeys.firstWhere((dataKey) => dataKey.name == moduleName);
        String text =
            '${characteristicDataCache[dataKey] ?? ''}${CustomStyle.dB}';

        String color = textPlaceholder.getAttribute('color').toString();

        valueTexts.add(ValueText(
          moduleName: moduleName,
          x: x,
          y: y,
          text: text,
          color: color,
        ));
      }
    }
    SVGImage svgImage = SVGImage(
      width: width,
      height: height,
      components: components,
      boxes: boxes,
      valueTexts: valueTexts,
    );

    emit(state.copyWith(
      svgImage: svgImage,
    ));
  }
}
