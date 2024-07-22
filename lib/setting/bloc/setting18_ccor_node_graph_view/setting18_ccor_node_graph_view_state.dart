part of 'setting18_ccor_node_graph_view_bloc.dart';

class Setting18CCorNodeGraphViewState extends Equatable {
  const Setting18CCorNodeGraphViewState({
    this.graphFilePath = '',
    this.svgImage = const SVGImage(
      width: 0.0,
      height: 0.0,
      components: [],
      boxes: [],
      valueTexts: [],
      editable: false,
    ),
  });

  final String graphFilePath;
  final SVGImage svgImage;

  Setting18CCorNodeGraphViewState copyWith({
    String? graphFilePath,
    SVGImage? svgImage,
  }) {
    return Setting18CCorNodeGraphViewState(
      graphFilePath: graphFilePath ?? this.graphFilePath,
      svgImage: svgImage ?? this.svgImage,
    );
  }

  @override
  List<Object> get props => [
        graphFilePath,
        svgImage,
      ];
}
