part of 'setting18_graph_view_bloc.dart';

class Setting18GraphViewState extends Equatable {
  const Setting18GraphViewState({
    this.submissionStatus = SubmissionStatus.none,
    this.svgImage = const SVGImage(
      width: 0.0,
      height: 0.0,
      components: [],
      boxes: [],
    ),
  });

  final SubmissionStatus submissionStatus;
  final SVGImage svgImage;

  Setting18GraphViewState copyWith({
    SubmissionStatus? submissionStatus,
    SVGImage? svgImage,
  }) {
    return Setting18GraphViewState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      svgImage: svgImage ?? this.svgImage,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        svgImage,
      ];
}
