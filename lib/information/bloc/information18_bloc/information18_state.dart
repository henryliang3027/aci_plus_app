part of 'information18_bloc.dart';

class Information18State extends Equatable {
  const Information18State({
    // this.isLoadConfigEnabled = false,
    this.configs = const [],
    this.alarmUSeverity = 'default',
    this.alarmTSeverity = 'default',
    this.alarmPSeverity = 'default',
    // this.namePlateImage = const SVGImage(
    //   width: 0.0,
    //   height: 0.0,
    //   components: [],
    //   boxes: [],
    // ),
    this.errorMessage = '',
  });

  // final bool isLoadConfigEnabled;
  final List<Config> configs;
  final String alarmUSeverity;
  final String alarmTSeverity;
  final String alarmPSeverity;
  // final SVGImage namePlateImage;
  final String errorMessage;

  Information18State copyWith({
    // bool? isLoadConfigEnabled,
    List<Config>? configs,
    String? alarmUSeverity,
    String? alarmTSeverity,
    String? alarmPSeverity,
    // SVGImage? namePlateImage,
    String? errorMessage,
  }) {
    return Information18State(
      // isLoadConfigEnabled: isLoadConfigEnabled ?? this.isLoadConfigEnabled,
      configs: configs ?? this.configs,
      alarmUSeverity: alarmUSeverity ?? this.alarmUSeverity,
      alarmTSeverity: alarmTSeverity ?? this.alarmTSeverity,
      alarmPSeverity: alarmPSeverity ?? this.alarmPSeverity,
      // namePlateImage: namePlateImage ?? this.namePlateImage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        // isLoadConfigEnabled,
        configs,
        alarmUSeverity,
        alarmTSeverity,
        alarmPSeverity,
        // namePlateImage,
        errorMessage,
      ];
}
