part of 'setting18_tabbar_bloc.dart';

class Setting18TabBarState extends Equatable {
  const Setting18TabBarState({
    this.forwardCEQStatus = FormStatus.none,
    this.isForwardCEQIndexChanged = false,
    this.message = '',
  });

  final FormStatus forwardCEQStatus;
  final bool isForwardCEQIndexChanged;
  final String message;

  Setting18TabBarState copyWith({
    FormStatus? forwardCEQStatus,
    bool? isForwardCEQIndexChanged,
    String? message,
  }) {
    return Setting18TabBarState(
      forwardCEQStatus: forwardCEQStatus ?? this.forwardCEQStatus,
      isForwardCEQIndexChanged:
          isForwardCEQIndexChanged ?? this.isForwardCEQIndexChanged,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        forwardCEQStatus,
        isForwardCEQIndexChanged,
        message,
      ];
}
