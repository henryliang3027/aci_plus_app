import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_parser.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'downloader18_ccor_node_event.dart';
part 'downloader18_ccor_node_state.dart';

class Downloader18CCorNodeBloc
    extends Bloc<Downloader18CCorNodeEvent, Downloader18CCorNodeState> {
  Downloader18CCorNodeBloc({
    required Amp18CCorNodeRepository amp18CCorNodeRepository,
  })  : _amp18CCorNodeRepository = amp18CCorNodeRepository,
        super(const Downloader18CCorNodeState()) {
    on<DownloadStarted>(_onDownloadStarted);

    add(const DownloadStarted());
  }

  final Amp18CCorNodeRepository _amp18CCorNodeRepository;

  Future<List> getLogChunkWithRetry(int chunkIndex) async {
    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int j = 0; j < 3; j++) {
      List<dynamic> resultOfLog = await _amp18CCorNodeRepository
          .requestCommand1p8GCCorNodeLogChunk(chunkIndex);

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
    Downloader18CCorNodeEvent event,
    Emitter<Downloader18CCorNodeState> emit,
  ) async {
    List<Log1p8GCCorNode> log1p8Gs = [];

    for (int i = 0; i < 10; i++) {
      List<dynamic> resultOfLog = await getLogChunkWithRetry(i);
      print('resultOfLog $i: ${resultOfLog[0]}');

      if (resultOfLog[0]) {
        log1p8Gs.addAll(resultOfLog[2]);

        bool hasNextChunk = resultOfLog[1];
        print('resultOfLog $i: $hasNextChunk');

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
