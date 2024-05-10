part of 'setting18_graph_view_bloc.dart';

class Setting18GraphViewState extends Equatable {
  const Setting18GraphViewState({
    this.svgImage = const SVGImage(
      width: 0.0,
      height: 0.0,
      components: [],
      boxes: [],
    ),
  });

  final SVGImage svgImage;

  Setting18GraphViewState copyWith({
    SVGImage? svgImage,
  }) {
    return Setting18GraphViewState(
      svgImage: svgImage ?? this.svgImage,
    );
  }

  @override
  List<Object> get props => [
        svgImage,
      ];
}
