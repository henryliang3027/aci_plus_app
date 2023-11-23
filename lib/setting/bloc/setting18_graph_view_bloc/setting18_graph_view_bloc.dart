import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
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
    required Amp18Repository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const Setting18GraphViewState()) {
    on<LoadGraphRequested>(_onLoadGraphRequested);
    on<AttenuatorTapped>(_onAttenuatorTapped);

    add(const LoadGraphRequested());
  }

  final Amp18Repository _dsimRepository;

  Future<void> _onLoadGraphRequested(
    LoadGraphRequested event,
    Emitter<Setting18GraphViewState> emit,
  ) async {
    String generalString =
        await rootBundle.loadString('assets/circuits/MB_1.8G_20231117.svg');

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
      int moduleId = int.parse(element.getAttribute('symbol').toString());
      double x = double.parse(element.getAttribute('x').toString());
      double y = double.parse(element.getAttribute('y').toString());
      double width = double.parse(element.getAttribute('width').toString());
      double height = double.parse(element.getAttribute('height').toString());

      boxes.add(Box(
        moduleId: moduleId,
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

  void _onAttenuatorTapped(
    AttenuatorTapped event,
    Emitter<Setting18GraphViewState> emit,
  ) {}
}
