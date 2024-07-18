part of 'setting18_graph_view_bloc.dart';

class Setting18GraphViewState extends Equatable {
  const Setting18GraphViewState({
    this.graphFilePath = '',
    this.svgImage = const SVGImage(
      width: 0.0,
      height: 0.0,
      components: [],
      boxes: [],
      valueTexts: [],
    ),
  });

  final String graphFilePath;
  final SVGImage svgImage;

  Setting18GraphViewState copyWith({
    String? graphFilePath,
    SVGImage? svgImage,
  }) {
    return Setting18GraphViewState(
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
