import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_chart/speed_chart.dart';

part 'rf_level_chart_event.dart';
part 'rf_level_chart_state.dart';

class RFLevelChartBloc extends Bloc<RFLevelChartEvent, RFLevelChartState> {
  RFLevelChartBloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const RFLevelChartState()) {
    on<RFInOutRequested>(_onRFInOutRequested);
  }

  final Amp18Repository _amp18Repository;

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
      List<dynamic> resultOf1p8G3 =
          await _amp18Repository.requestCommand1p8G3();

      if (resultOf1p8G3[0]) {
        rfInOuts.addAll(resultOf1p8G3[1]);

        // 清除 cache
        _amp18Repository.clearRFInOuts();

        // 將 RFInOuts 寫入 cache
        _amp18Repository.writeRFInOuts(rfInOuts);

        // parse sample rf data
        // for (i = 0; i < 256; i++) {
        //   int frequency = 261 + i * 6;
        //   double rfIn = rfInputs[frequency] ?? 0.0;
        //   double rfOut = rfOutputs[frequency] ?? 0.0;
        //   rfInOuts.add(RFInOut(
        //     frequency: frequency,
        //     input: rfIn,
        //     output: rfOut,
        //   ));
        // }

        List<List<ValuePair>> dateValueCollectionOfLog =
            _amp18Repository.get1p8GValueCollectionOfRFInOut(rfInOuts);

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
            errorMessage: 'Failed to load data',
          ));
        } else {
          if (resultOf1p8G3[1] == CharacteristicError.writeDataError.name) {
            emit(state.copyWith(
              rfInOutRequestStatus: FormStatus.requestFailure,
              errorMessage: 'Failed to load data',
            ));
            break;
          } else {
            continue;
          }
        }
      }
    }
  }
}
