import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/setting/model/component.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart';

part 'setting18_graph_view_event.dart';
part 'setting18_graph_view_state.dart';

class Setting18GraphViewBloc
    extends Bloc<Setting18GraphViewEvent, Setting18GraphViewState> {
  Setting18GraphViewBloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const Setting18GraphViewState()) {
    on<LoadGraphRequested>(_onLoadGraphRequested);
    on<AttenuatorTapped>(_onAttenuatorTapped);

    add(const LoadGraphRequested());
  }

  final DsimRepository _dsimRepository;

  Future<void> _onLoadGraphRequested(
    LoadGraphRequested event,
    Emitter<Setting18GraphViewState> emit,
  ) async {
    String generalString =
        await rootBundle.loadString('assets/circuits/MB_1.8G_small.svg');

    XmlDocument document = XmlDocument.parse(generalString);

    final paths = document.findAllElements('path');
    final rects = document.findAllElements('rect');

    List<Component> svgPaths = [];
    List<Box> boxes = [];

    for (var element in paths) {
      String partColor =
          'ff${element.getAttribute('fill').toString().substring(1)}';
      String partPath = element.getAttribute('d').toString();

      svgPaths.add(Component(color: partColor, path: partPath));
    }

    for (var element in rects) {
      double x = double.parse(element.getAttribute('x').toString());
      double y = double.parse(element.getAttribute('y').toString());
      double width = double.parse(element.getAttribute('width').toString());
      double height = double.parse(element.getAttribute('height').toString());

      boxes.add(Box(
        x: x,
        y: y,
        width: width,
        height: height,
      ));
    }

    emit(state.copyWith(
      svgPaths: svgPaths,
      boxes: boxes,
    ));
  }

  void _onAttenuatorTapped(
    AttenuatorTapped event,
    Emitter<Setting18GraphViewState> emit,
  ) {}
}
