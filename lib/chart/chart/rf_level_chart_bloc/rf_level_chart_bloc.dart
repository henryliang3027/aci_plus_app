import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim18_parser.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_chart/speed_chart.dart';

part 'rf_level_chart_event.dart';
part 'rf_level_chart_state.dart';

class RFLevelChartBloc extends Bloc<RFLevelChartEvent, RFLevelChartState> {
  RFLevelChartBloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const RFLevelChartState()) {
    on<RFInOutRequested>(_onRFInOutRequested);
  }

  final DsimRepository _dsimRepository;

  Future<void> _onRFInOutRequested(
    RFInOutRequested event,
    Emitter<RFLevelChartState> emit,
  ) async {
    emit(state.copyWith(
      rfInOutRequestStatus: FormStatus.requestInProgress,
      // dataRequestStatus: FormStatus.none,
      // dataExportStatus: FormStatus.none,
      // dataShareStatus: FormStatus.none,
      // allDataDownloadStatus: FormStatus.none,
    ));

    List<RFInOut> rfInOuts = [];
    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int i = 0; i < 3; i++) {
      List<dynamic> resultOf1p8G3 = await _dsimRepository.requestCommand1p8G3();

      if (resultOf1p8G3[0]) {
        rfInOuts.addAll(resultOf1p8G3[1]);

        // 清除 cache
        _dsimRepository.clearRFInOuts();

        // 將 RFInOuts 寫入 cache
        _dsimRepository.writeRFInOuts(rfInOuts);

        List<List<ValuePair>> dateValueCollectionOfLog =
            _dsimRepository.get1p8GValueCollectionOfRFInOut(rfInOuts);

        emit(
          state.copyWith(
            rfInOutRequestStatus: FormStatus.requestSuccess,
            rfInOuts: rfInOuts,
            valueCollectionOfRFInOut: dateValueCollectionOfLog,
          ),
        );

        break;
      } else {
        if (i == 2) {
          emit(state.copyWith(
            rfInOutRequestStatus: FormStatus.requestFailure,
            errorMessage: 'Data loading failed',
          ));
        } else {
          continue;
        }
      }
    }
  }
}
