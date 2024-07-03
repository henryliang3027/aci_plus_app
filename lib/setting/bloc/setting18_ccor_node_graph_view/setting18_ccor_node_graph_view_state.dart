part of 'setting18_ccor_node_graph_view_bloc.dart';

class Setting18CCorNodeGraphViewState extends Equatable {
  const Setting18CCorNodeGraphViewState({
    this.svgImage = const SVGImage(
      width: 0.0,
      height: 0.0,
      components: [],
      boxes: [],
      valueTexts: [],
    ),
  });

  final SVGImage svgImage;

  Setting18CCorNodeGraphViewState copyWith({
    SVGImage? svgImage,
  }) {
    return Setting18CCorNodeGraphViewState(
      svgImage: svgImage ?? this.svgImage,
    );
  }

  @override
  List<Object> get props => [
        svgImage,
      ];
}
