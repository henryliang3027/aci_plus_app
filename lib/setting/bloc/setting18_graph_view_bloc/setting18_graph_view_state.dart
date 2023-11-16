part of 'setting18_graph_view_bloc.dart';

class Setting18GraphViewState extends Equatable {
  const Setting18GraphViewState({
    this.submissionStatus = SubmissionStatus.none,
    this.svgPaths = const [],
    this.boxes = const [],
  });

  final SubmissionStatus submissionStatus;
  final List<Component> svgPaths;
  final List<Box> boxes;

  Setting18GraphViewState copyWith({
    SubmissionStatus? submissionStatus,
    List<Component>? svgPaths,
    List<Box>? boxes,
  }) {
    return Setting18GraphViewState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      svgPaths: svgPaths ?? this.svgPaths,
      boxes: boxes ?? this.boxes,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        svgPaths,
        boxes,
      ];
}
