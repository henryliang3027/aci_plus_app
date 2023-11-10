import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/dsim18_ccor_node_parser.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_chart/speed_chart.dart';

part 'chart18_ccor_node_event.dart';
part 'chart18_ccor_node_state.dart';

class Chart18CCorNodeBloc
    extends Bloc<Chart18CCorNodeEvent, Chart18CCorNodeState> {
  Chart18CCorNodeBloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const Chart18CCorNodeState()) {
    on<LogRequested>(_onLogRequested);
    on<MoreLogRequested>(_onMoreLogRequested);
    on<Event1P8GCCorNodeRequested>(_onEvent1P8GCCorNodeRequested);
    on<DataExported>(_onDataExported);
    on<DataShared>(_onDataShared);
    on<AllDataDownloaded>(_onAllDataDownloaded);
    on<AllDataExported>(_onAllDataExported);
  }

  final DsimRepository _dsimRepository;

  Future<void> _onLogRequested(
    LogRequested event,
    Emitter<Chart18CCorNodeState> emit,
  ) async {
    emit(state.copyWith(
      logRequestStatus: FormStatus.requestInProgress,
      // rfDataRequestStatus: FormStatus.none,
      // dataExportStatus: FormStatus.none,
      // dataShareStatus: FormStatus.none,
      // allDataExportStatus: FormStatus.none,
    ));

    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int i = 0; i < 3; i++) {
      List<dynamic> resultOfLog1p8G =
          await _dsimRepository.requestCommand1p8GCCorNodeLogChunk(0);

      if (resultOfLog1p8G[0]) {
        bool hasNextChunk = resultOfLog1p8G[1];
        List<Log1p8GCCorNode> log1p8Gs = resultOfLog1p8G[2];

        List<List<ValuePair>> dateValueCollectionOfLog =
            _dsimRepository.get1p8GCCorNodeDateValueCollectionOfLogs(log1p8Gs);

        // 清除 cache
        _dsimRepository.clearLoadMoreLog1p8GCCorNodes();

        // 將 log 寫入 cache
        _dsimRepository.writeLoadMoreLog1p8GCCorNodes(log1p8Gs);

        emit(
          state.copyWith(
            logRequestStatus: FormStatus.requestSuccess,
            log1p8Gs: log1p8Gs,
            dateValueCollectionOfLog: dateValueCollectionOfLog,
            chunkIndex: 1,
            hasNextChunk: hasNextChunk,
          ),
        );

        break;
      } else {
        if (i == 2) {
          emit(state.copyWith(
            logRequestStatus: FormStatus.requestFailure,
            errorMessage: 'load logs failed',
          ));
        } else {
          continue;
        }
      }
    }
  }

  Future<void> _onMoreLogRequested(
    MoreLogRequested event,
    Emitter<Chart18CCorNodeState> emit,
  ) async {
    emit(state.copyWith(
      logRequestStatus: FormStatus.requestInProgress,
      // dataExportStatus: FormStatus.none,
      // dataShareStatus: FormStatus.none,
      // allDataExportStatus: FormStatus.none,
    ));

    List<Log1p8GCCorNode> log1p8Gs = [];
    log1p8Gs.addAll(state.log1p8Gs);

    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int i = 0; i < 3; i++) {
      List<dynamic> resultOfLog1p8G = await _dsimRepository
          .requestCommand1p8GCCorNodeLogChunk(state.chunkIndex);

      if (resultOfLog1p8G[0]) {
        log1p8Gs.addAll(resultOfLog1p8G[2]);

        List<List<ValuePair>> dateValueCollectionOfLog =
            _dsimRepository.get1p8GCCorNodeDateValueCollectionOfLogs(log1p8Gs);

        // // 將新的 log 寫入 cache
        // _dsimRepository.writeLoadMoreLog1p8Gs(resultOfLog1p8G[2]);

        emit(
          state.copyWith(
            logRequestStatus: FormStatus.requestSuccess,
            log1p8Gs: log1p8Gs,
            dateValueCollectionOfLog: dateValueCollectionOfLog,
            chunkIndex: state.chunkIndex + 1,
            hasNextChunk: resultOfLog1p8G[1],
          ),
        );

        break;
      } else {
        if (i == 2) {
          emit(state.copyWith(
            logRequestStatus: FormStatus.requestFailure,
            errorMessage: 'load logs failed',
          ));
        } else {
          continue;
        }
      }
    }
  }

  Future<void> _onEvent1P8GCCorNodeRequested(
    Event1P8GCCorNodeRequested event,
    Emitter<Chart18CCorNodeState> emit,
  ) async {
    emit(state.copyWith(
      eventRequestStatus: FormStatus.requestInProgress,
      // dataExportStatus: FormStatus.none,
      // dataShareStatus: FormStatus.none,
      // allDataExportStatus: FormStatus.none,
    ));

    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int i = 0; i < 3; i++) {
      List<dynamic> resultOfEvent1p8G =
          await _dsimRepository.requestCommand1p8GCCorNodeEvent();

      if (resultOfEvent1p8G[0]) {
        List<Event1p8GCCorNode> event1p8Gs = resultOfEvent1p8G[1];

        // // 清除 cache
        // _dsimRepository.clearEvent1p8Gs();

        // // 將 event 寫入 cache
        // _dsimRepository.writeEvent1p8Gs(event1p8Gs);

        emit(
          state.copyWith(
            eventRequestStatus: FormStatus.requestSuccess,
            event1p8Gs: event1p8Gs,
          ),
        );

        break;
      } else {
        if (i == 2) {
          emit(state.copyWith(
            eventRequestStatus: FormStatus.requestFailure,
            errorMessage: 'load events failed',
          ));
        } else {
          continue;
        }
      }
    }
  }

  void _onDataExported(
    DataExported event,
    Emitter<Chart18CCorNodeState> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.requestInProgress,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.none,
    ));

    final List<dynamic> result =
        await _dsimRepository.export1p8GCCorNodeRecords(
      log1p8Gs: state.log1p8Gs,
      event1p8Gs: state.event1p8Gs,
    );

    if (result[0]) {
      emit(state.copyWith(
        dataExportStatus: FormStatus.requestSuccess,
        dataExportPath: result[2],
      ));
    } else {
      emit(state.copyWith(
        dataExportStatus: FormStatus.requestFailure,
        dataExportPath: result[2],
      ));
    }
  }

  void _onDataShared(
    DataShared event,
    Emitter<Chart18CCorNodeState> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.requestInProgress,
      allDataExportStatus: FormStatus.none,
    ));

    final List<dynamic> result =
        await _dsimRepository.export1p8GCCorNodeRecords(
      log1p8Gs: state.log1p8Gs,
      event1p8Gs: state.event1p8Gs,
    );

    if (result[0]) {
      emit(state.copyWith(
        dataShareStatus: FormStatus.requestSuccess,
        exportFileName: result[1],
        dataExportPath: result[2],
      ));
    } else {
      emit(state.copyWith(
        dataShareStatus: FormStatus.requestFailure,
        exportFileName: result[1],
        dataExportPath: result[2],
      ));
    }
  }

  void _onAllDataDownloaded(
    AllDataDownloaded event,
    Emitter<Chart18CCorNodeState> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataExportStatus: FormStatus.requestInProgress,
    ));
  }

  void _onAllDataExported(
    AllDataExported event,
    Emitter<Chart18CCorNodeState> emit,
  ) async {
    if (event.isSuccessful) {
      // _dsimRepository.writeAllLog1p8GCCorNodes(event.log1p8Gs);
      final List<dynamic> result =
          await _dsimRepository.exportAll1p8GCCorNodeRecords(
        log1p8Gs: event.log1p8Gs,
        event1p8Gs: state.event1p8Gs,
      );

      if (result[0]) {
        emit(state.copyWith(
          allDataExportStatus: FormStatus.requestSuccess,
          dataExportPath: result[2],
        ));
      } else {
        emit(state.copyWith(
          allDataExportStatus: FormStatus.requestFailure,
          dataExportPath: result[2],
        ));
      }
    } else {
      emit(state.copyWith(
        allDataExportStatus: FormStatus.requestFailure,
        errorMessage: event.errorMessage,
      ));
    }
  }
}
