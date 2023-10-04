part of 'rf_level_chart_bloc.dart';

class RFLevelChartState extends Equatable {
  const RFLevelChartState({
    this.dataRequestStatus = FormStatus.none,
    this.rfInOuts = const [],
  });

  final FormStatus dataRequestStatus;
  final List<RFInOut> rfInOuts;

  @override
  List<Object> get props => [];
}
