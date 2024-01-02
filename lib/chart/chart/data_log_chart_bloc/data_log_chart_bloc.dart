import 'package:aci_plus_app/core/common_enum.dart';
import 'package:aci_plus_app/core/data_key.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/amp18_parser.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_chart/speed_chart.dart';

part 'data_log_chart_event.dart';
part 'data_log_chart_state.dart';

class DataLogChartBloc extends Bloc<DataLogChartEvent, DataLogChartState> {
  DataLogChartBloc({
    required Amp18Repository amp18Repository,
  })  : _amp18Repository = amp18Repository,
        super(const DataLogChartState()) {
    on<LogRequested>(_onLogRequested);
    on<Event1P8GRequested>(_onEvent1P8GDataRequested);
    on<MoreLogRequested>(_onMoreLogRequested);
    on<TestLogRequested>(_onTestLogRequested);
  }

  final Amp18Repository _amp18Repository;

  Future<void> _onTestLogRequested(
    TestLogRequested event,
    Emitter<DataLogChartState> emit,
  ) async {
    List<dynamic> resultOfLog1p8G =
        await _amp18Repository.requestCommand1p8GForLogChunk(0);

    print(resultOfLog1p8G[0]);
  }

  Future<void> _onLogRequested(
    LogRequested event,
    Emitter<DataLogChartState> emit,
  ) async {
    emit(state.copyWith(
      logRequestStatus: FormStatus.requestInProgress,
    ));

    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int i = 0; i < 3; i++) {
      List<dynamic> resultOfLog1p8G =
          await _amp18Repository.requestCommand1p8GForLogChunk(0);

      if (resultOfLog1p8G[0]) {
        bool hasNextChunk = resultOfLog1p8G[1];
        List<Log1p8G> log1p8Gs = resultOfLog1p8G[2];
        Map<DataKey, String> logStatistics = resultOfLog1p8G[3];

        List<List<ValuePair>> dateValueCollectionOfLog =
            _amp18Repository.get1p8GDateValueCollectionOfLogs(log1p8Gs);

        _amp18Repository.updateDataWithGivenValuePairs(logStatistics);

        // 清除 cache
        _amp18Repository.clearLoadMoreLog1p8Gs();

        // 將 log 寫入 cache
        _amp18Repository.writeLoadMoreLog1p8Gs(log1p8Gs);

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
            errorMessage: 'Failed to load logs',
          ));
        } else {
          if (resultOfLog1p8G[2] == CharacteristicError.writeDataError.name) {
            emit(state.copyWith(
              logRequestStatus: FormStatus.requestFailure,
              errorMessage: 'Failed to load logs',
            ));
            break;
          } else {
            continue;
          }
        }
      }
    }
  }

  Future<void> _onEvent1P8GDataRequested(
    Event1P8GRequested event,
    Emitter<DataLogChartState> emit,
  ) async {
    emit(state.copyWith(
      eventRequestStatus: FormStatus.requestInProgress,
    ));

    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int i = 0; i < 3; i++) {
      List<dynamic> resultOfEvent1p8G =
          await _amp18Repository.requestCommand1p8GEvent();

      if (resultOfEvent1p8G[0]) {
        List<Event1p8G> event1p8Gs = resultOfEvent1p8G[1];

        // 清除 cache
        _amp18Repository.clearEvent1p8Gs();

        // 將 event 寫入 cache
        _amp18Repository.writeEvent1p8Gs(event1p8Gs);

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
            errorMessage: 'Failed to load events',
          ));
        } else {
          if (resultOfEvent1p8G[1] == CharacteristicError.writeDataError.name) {
            emit(state.copyWith(
              eventRequestStatus: FormStatus.requestFailure,
              errorMessage: 'Failed to load events',
            ));
            break;
          } else {
            continue;
          }
        }
      }
    }
  }

  Future<void> _onMoreLogRequested(
    MoreLogRequested event,
    Emitter<DataLogChartState> emit,
  ) async {
    emit(state.copyWith(
      logRequestStatus: FormStatus.requestInProgress,
    ));

    List<Log1p8G> log1p8Gs = [];
    log1p8Gs.addAll(state.log1p8Gs);

    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int i = 0; i < 3; i++) {
      List<dynamic> resultOfLog1p8G = await _amp18Repository
          .requestCommand1p8GForLogChunk(state.chunkIndex);

      if (resultOfLog1p8G[0]) {
        log1p8Gs.addAll(resultOfLog1p8G[2]);

        List<List<ValuePair>> dateValueCollectionOfLog =
            _amp18Repository.get1p8GDateValueCollectionOfLogs(log1p8Gs);

        // 將新的 log 寫入 cache
        _amp18Repository.writeLoadMoreLog1p8Gs(resultOfLog1p8G[2]);

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
            errorMessage: 'Failed to load logs',
          ));
        } else {
          if (resultOfLog1p8G[2] == CharacteristicError.writeDataError.name) {
            emit(state.copyWith(
              logRequestStatus: FormStatus.requestFailure,
              errorMessage: 'Failed to load logs',
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
