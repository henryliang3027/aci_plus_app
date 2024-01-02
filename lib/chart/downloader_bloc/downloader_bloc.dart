import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'downloader_event.dart';
part 'downloader_state.dart';

class DownloaderBloc extends Bloc<DownloaderEvent, DownloaderState> {
  DownloaderBloc({
    required Function(int) requestLogChunk,
  })  : _requestLogChunk = requestLogChunk,
        super(const DownloaderState()) {
    on<DownloadStarted>(_onDownloadStarted);

    add(const DownloadStarted());
  }

  // final Amp18Repository _amp18Repository;
  final Function(int) _requestLogChunk;

  Future<List> getLogChunkWithRetry(int chunkIndex) async {
    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int j = 0; j < 3; j++) {
      List<dynamic> resultOfLog = await _requestLogChunk(chunkIndex);

      if (resultOfLog[0]) {
        return resultOfLog;
      } else {
        if (j == 2) {
          break;
        } else {
          if (resultOfLog[2] == CharacteristicError.writeDataError.name) {
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
    DownloaderEvent event,
    Emitter<DownloaderState> emit,
  ) async {
    List<Log1p8G> log1p8Gs = [];

    for (int i = 0; i < 10; i++) {
      List<dynamic> resultOfLog = await getLogChunkWithRetry(i);
      print('resultOfLog $i: ${resultOfLog[0]}');

      if (resultOfLog[0]) {
        log1p8Gs.addAll(resultOfLog[2]);

        bool hasNextChunk = resultOfLog[1];

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
            log1p8Gs: log1p8Gs,
            errorMessage: '',
          ));
          break;
        }
      } else {
        emit(state.copyWith(
          status: FormStatus.requestFailure,
          currentProgress: 0,
          errorMessage: 'Failed to load logs',
        ));
        break;
      }
    }
  }
}
