part of 'setting18_graph_view_bloc.dart';

class Setting18GraphViewState extends Equatable {
  const Setting18GraphViewState({
    this.formStatus = FormStatus.none,
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

  final FormStatus formStatus;
  final String graphFilePath;
  final SVGImage svgImage;

  Setting18GraphViewState copyWith({
    FormStatus? formStatus,
    String? graphFilePath,
    SVGImage? svgImage,
  }) {
    return Setting18GraphViewState(
      formStatus: formStatus ?? this.formStatus,
      graphFilePath: graphFilePath ?? this.graphFilePath,
      svgImage: svgImage ?? this.svgImage,
    );
  }

  @override
  List<Object> get props => [
        formStatus,
        graphFilePath,
        svgImage,
      ];
}
