part of 'warm_reset_bloc.dart';

sealed class WarmResetEvent extends Equatable {
  const WarmResetEvent();

  @override
  List<Object> get props => [];
}

class ResetStarted extends WarmResetEvent {
  const ResetStarted();

  @override
  List<Object> get props => [];
}

class MessageReceived extends WarmResetEvent {
  const MessageReceived({
    required this.message,
    required this.currentProgress,
  });

  final String message;
  final double currentProgress;

  @override
  List<Object> get props => [
        message,
        currentProgress,
      ];
}
