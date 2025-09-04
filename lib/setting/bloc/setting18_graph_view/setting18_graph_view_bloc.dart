import 'package:aci_plus_app/core/custom_style.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/setting/model/setting_widgets.dart';
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
    required Amp18Repository amp18Repository,
    bool editable = true,
  })  : _amp18Repository = amp18Repository,
        _editable = editable,
        super(Setting18GraphViewState(graphFilePath: graphFilePath)) {
    on<LoadGraphRequested>(_onLoadGraphRequested);
    on<ValueTextUpdated>(_onValueTextUpdated);

    add(const LoadGraphRequested());
  }

  final Amp18Repository _amp18Repository;
  final bool _editable;

  String getValueText({
    required Map<DataKey, String> characteristicDataCache,
    required DataKey dataKey,
    required String moduleName,
  }) {
    String value = characteristicDataCache[dataKey] ?? '';
    String valueText = '';
    if (value.isNotEmpty) {
      valueText = value;
      if (moduleName == DataKey.dsVVA1.name) {
        valueText = getInputAttenuation(
          pilotFrequencyMode:
              characteristicDataCache[DataKey.pilotFrequencyMode] ?? '',
          agcMode: characteristicDataCache[DataKey.agcMode] ?? '',
          inputAttenuation: value,
          currentInputAttenuation:
              characteristicDataCache[DataKey.currentDSVVA1] ?? '',
        );
      } else if (moduleName == DataKey.dsSlope1.name) {
        valueText = getInputEqualizer(
          pilotFrequencyMode:
              characteristicDataCache[DataKey.pilotFrequencyMode] ?? '',
          agcMode: characteristicDataCache[DataKey.agcMode] ?? '',
          inputEqualizer: value,
          currentInputEqualizer:
              characteristicDataCache[DataKey.currentDSSlope1] ?? '',
        );
      } else {
        valueText = value;
      }

      return '$valueText${CustomStyle.dB}';
    } else {
      return '';
    }
  }

  Future<void> _onLoadGraphRequested(
    LoadGraphRequested event,
    Emitter<Setting18GraphViewState> emit,
  ) async {
    emit(state.copyWith(
      formStatus: FormStatus.requestInProgress,
    ));

    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

    String generalString = await rootBundle.loadString(state.graphFilePath);

    XmlDocument document = XmlDocument.parse(generalString);

    final rects = document.findAllElements('rect');
    final header = document.findElements('svg').toList()[0];
    final double width = double.parse(header.getAttribute('width').toString());
    final double height =
        double.parse(header.getAttribute('height').toString());

    List<Box> boxes = [];
    List<ValueText> valueTexts = [];

    // 取得所有 DataKey 並轉為 list
    List<DataKey> dataKeys = DataKey.values;

    for (var element in rects) {
      String? moduleName = element.getAttribute('module');
      String? type = element.getAttribute('type');

      if (moduleName != null) {
        if (type == 'textBox') {
          double x = double.parse(element.getAttribute('x').toString());
          double y = double.parse(element.getAttribute('y').toString());
          double width = double.parse(element.getAttribute('width').toString());
          double height =
              double.parse(element.getAttribute('height').toString());
          DataKey dataKey =
              dataKeys.firstWhere((dataKey) => dataKey.name == moduleName);

          String text = getValueText(
            characteristicDataCache: characteristicDataCache,
            dataKey: dataKey,
            moduleName: moduleName,
          );

          String color = element.getAttribute('color').toString();

          valueTexts.add(ValueText(
            moduleName: moduleName,
            x: x,
            y: y,
            width: width,
            height: height,
            text: text,
            color: color,
          ));
        } else {
          print('moduleName: $moduleName');
          double x = double.parse(element.getAttribute('x').toString());
          double y = double.parse(element.getAttribute('y').toString());
          double width = double.parse(element.getAttribute('width').toString());
          double height =
              double.parse(element.getAttribute('height').toString());

          boxes.add(Box(
            moduleName: moduleName,
            x: x,
            y: y,
            width: width,
            height: height,
          ));
        }
      }
    }

    SVGImage svgImage = SVGImage(
      width: width,
      height: height,
      boxes: boxes,
      valueTexts: valueTexts,
      editable: _editable,
    );

    emit(state.copyWith(
      formStatus: FormStatus.requestSuccess,
      svgImage: svgImage,
    ));
  }

  void _onValueTextUpdated(
    ValueTextUpdated event,
    Emitter<Setting18GraphViewState> emit,
  ) async {
    Map<DataKey, String> characteristicDataCache =
        _amp18Repository.characteristicDataCache;

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
        moduleName: valueText.moduleName,
      );

      newValueTexts.add(ValueText(
        moduleName: valueText.moduleName,
        x: valueText.x,
        y: valueText.y,
        width: valueText.width,
        height: valueText.height,
        text: text,
        color: valueText.color,
      ));
    }

    SVGImage svgImage = SVGImage(
      width: state.svgImage.width,
      height: state.svgImage.height,
      boxes: state.svgImage.boxes,
      valueTexts: newValueTexts,
      editable: _editable,
    );

    emit(state.copyWith(
      svgImage: svgImage,
    ));
  }
}
