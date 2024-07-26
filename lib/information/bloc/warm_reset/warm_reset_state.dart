part of 'warm_reset_bloc.dart';

class WarmResetState extends Equatable {
  const WarmResetState({
    this.submissionStatus = SubmissionStatus.none,
    this.message = '',
    this.currentProgress = 0.0,
  });

  final SubmissionStatus submissionStatus;
  final String message;
  final double currentProgress;

  WarmResetState copyWith({
    SubmissionStatus? submissionStatus,
    String? message,
    double? currentProgress,
  }) {
    return WarmResetState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        message,
        currentProgress,
      ];
}
