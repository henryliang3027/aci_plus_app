import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'downloader18_rf_out_event.dart';
part 'downloader18_rf_out_state.dart';

class Downloader18RFOutBloc
    extends Bloc<Downloader18RFOutEvent, Downloader18RFOutState> {
  Downloader18RFOutBloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const Downloader18RFOutState()) {
    on<DownloadStarted>(_onDownloadStarted);

    add(const DownloadStarted());
  }

  final Amp18Repository _amp18Repository;

  Future<List> getRFOutChunkWithRetry(int chunkIndex) async {
    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int j = 0; j < 3; j++) {
      List<dynamic> resultOfRFOut =
          await _amp18Repository.requestCommand1p8GRFOutputLogChunk(chunkIndex);

      if (resultOfRFOut[0]) {
        return resultOfRFOut;
      } else {
        if (j == 2) {
          break;
        } else {
          if (resultOfRFOut[2] == CharacteristicError.writeDataError.name) {
            break;
          } else {
            continue;
          }
        }
      }
    }
    return [false];
  }

  Future<void> _onDownloadStarted(
    DownloadStarted event,
    Emitter<Downloader18RFOutState> emit,
  ) async {
    List<RFOutputLog> rfOutputLog1p8Gs = [];

    for (int i = 0; i < 1; i++) {
      List<dynamic> resultOfRFOut = await getRFOutChunkWithRetry(i);
      print('resultOfRFOut $i: ${resultOfRFOut[0]}');

      if (resultOfRFOut[0]) {
        rfOutputLog1p8Gs.addAll(resultOfRFOut[2]);

        bool hasNextChunk = resultOfRFOut[1];

        if (hasNextChunk) {
          emit(state.copyWith(
            status: FormStatus.requestInProgress,
            currentProgress: i + 1,
            errorMessage: '',
          ));
        } else {
          emit(state.copyWith(
            status: FormStatus.requestSuccess,
            currentProgress: 10,
            rfOutputLog1p8Gs: rfOutputLog1p8Gs,
            errorMessage: '',
          ));
          break;
        }
      } else {
        emit(state.copyWith(
          status: FormStatus.requestFailure,
          currentProgress: 0,
          rfOutputLog1p8Gs: const [],
          errorMessage: 'Failed to download logs',
        ));
        break;
      }
    }
  }
}
