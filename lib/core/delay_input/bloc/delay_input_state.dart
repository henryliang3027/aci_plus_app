part of 'delay_input_bloc.dart';

class DelayInputState extends Equatable {
  const DelayInputState({
    this.submissionStatus = SubmissionStatus.none,
    this.isInitialize = false,
    this.delay = '',
  });

  final SubmissionStatus submissionStatus;
  final bool isInitialize;
  final String delay;

  DelayInputState copyWith({
    SubmissionStatus? submissionStatus,
    bool? isInitialize,
    String? delay,
  }) {
    return DelayInputState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      isInitialize: isInitialize ?? this.isInitialize,
      delay: delay ?? this.delay,
    );
  }

  @override
  List<Object> get props => [
        submissionStatus,
        isInitialize,
        delay,
      ];
}
