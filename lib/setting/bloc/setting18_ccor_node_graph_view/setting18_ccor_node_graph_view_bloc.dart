import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
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
    bool editable = true,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        _editable = editable,
        super(Setting18CCorNodeGraphViewState(graphFilePath: graphFilePath)) {
    on<LoadGraphRequested>(_onLoadGraphRequested);
    on<ValueTextUpdated>(_onValueTextUpdated);

    add(const LoadGraphRequested());
  }

  final Amp18CCorNodeRepository _amp18CCorNodeRepository;
  final bool _editable;

  String getValueText({
    required Map<DataKey, String> characteristicDataCache,
    required DataKey dataKey,
  }) {
    String value = characteristicDataCache[dataKey] ?? '';
    if (dataKey == DataKey.returnConfig) {
      return '2 X 2';
    }

    if (value.isNotEmpty) {
      if (dataKey.name.startsWith('biasCurrent')) {
        return '$value${CustomStyle.milliAmps}';
      } else if (dataKey == DataKey.forwardConfig) {
        return '${forwardConfigExportTexts[value]}';
      } else {
        return '$value${CustomStyle.dB}';
      }
    } else {
      return '';
    }
  }

  Future<void> _onLoadGraphRequested(
    LoadGraphRequested event,
    Emitter<Setting18CCorNodeGraphViewState> emit,
  ) async {
    Map<DataKey, String> characteristicDataCache =
        _amp18CCorNodeRepository.characteristicDataCache;

    String generalString = await rootBundle.loadString(state.graphFilePath);

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
        String text = getValueText(
          characteristicDataCache: characteristicDataCache,
          dataKey: dataKey,
        );

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
      editable: _editable,
    );

    emit(state.copyWith(
      svgImage: svgImage,
    ));
  }

  void _onValueTextUpdated(
    ValueTextUpdated event,
    Emitter<Setting18CCorNodeGraphViewState> emit,
  ) async {
    Map<DataKey, String> characteristicDataCache =
        _amp18CCorNodeRepository.characteristicDataCache;

    // 取得所有 DataKey 並轉為 list
    List<DataKey> dataKeys = DataKey.values;

    List<ValueText> valueTexts = List.from(state.svgImage.valueTexts);
    List<ValueText> newValueTexts = [];

    for (ValueText valueText in valueTexts) {
      DataKey dataKey = dataKeys
          .firstWhere((dataKey) => dataKey.name == valueText.moduleName);

      String text = getValueText(
        characteristicDataCache: characteristicDataCache,
        dataKey: dataKey,
      );

      newValueTexts.add(ValueText(
        moduleName: valueText.moduleName,
        x: valueText.x,
        y: valueText.y,
        text: text,
        color: valueText.color,
      ));

      SVGImage svgImage = SVGImage(
        width: state.svgImage.width,
        height: state.svgImage.height,
        components: state.svgImage.components,
        boxes: state.svgImage.boxes,
        valueTexts: newValueTexts,
        editable: _editable,
      );

      emit(state.copyWith(
        svgImage: svgImage,
      ));
    }
  }
}
