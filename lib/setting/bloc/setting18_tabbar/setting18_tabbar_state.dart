part of 'setting18_tabbar_bloc.dart';

class Setting18TabBarState extends Equatable {
  const Setting18TabBarState({
    this.isForwardCEQIndexChanged = false,
    this.message = '',
  });

  final bool isForwardCEQIndexChanged;
  final String message;

  Setting18TabBarState copyWith({
    bool? isForwardCEQIndexChanged,
    String? message,
  }) {
    return Setting18TabBarState(
      isForwardCEQIndexChanged:
          isForwardCEQIndexChanged ?? this.isForwardCEQIndexChanged,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        isForwardCEQIndexChanged,
        message,
      ];
}
