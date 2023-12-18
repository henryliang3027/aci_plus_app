part of 'setting18_config_bloc.dart';

class Setting18ConfigState extends Equatable {
  const Setting18ConfigState({
    this.formStatus = FormStatus.none,
    this.partIds = const [
      '2',
      '3',
      '5',
      '6',
      '7',
    ],
  });

  final FormStatus formStatus;
  final List<String> partIds;

  @override
  List<Object> get props => [
        formStatus,
        partIds,
      ];
}
