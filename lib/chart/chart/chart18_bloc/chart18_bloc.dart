import 'package:dsim_app/core/form_status.dart';
import 'package:dsim_app/repositories/dsim18_parser.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_chart/speed_chart.dart';

part 'chart18_event.dart';
part 'chart18_state.dart';

class Chart18Bloc extends Bloc<Chart18Event, Chart18State> {
  Chart18Bloc({
    required DsimRepository dsimRepository,
  })  : _dsimRepository = dsimRepository,
        super(const Chart18State()) {
    on<DataExported>(_onDataExported);
    on<DataShared>(_onDataShared);
    on<MoreDataRequested>(_onMoreDataRequested);
    on<RFInOutDataRequested>(_onRFInOutDataRequested);
    on<AllDataDownloaded>(_onAllDataDownloaded);
    on<AllDataExported>(_onAllDataExported);
  }

  final DsimRepository _dsimRepository;

  void _onDataExported(
    DataExported event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.requestInProgress,
      dataShareStatus: FormStatus.none,
      allDataDownloadStatus: FormStatus.none,
    ));

    final List<dynamic> result =
        await _dsimRepository.export1p8GRecords(state.log1p8Gs);

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
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.requestInProgress,
      allDataDownloadStatus: FormStatus.none,
    ));

    final List<dynamic> result =
        await _dsimRepository.export1p8GRecords(state.log1p8Gs);

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
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataDownloadStatus: FormStatus.requestInProgress,
    ));

    // for (int i = 0; i < 10; i++) {
    //   await Future.delayed(Duration(seconds: 1));

    //   emit(state.copyWith(
    //     dataExportStatus: FormStatus.none,
    //     dataShareStatus: FormStatus.none,
    //     allDataDownloadStatus: FormStatus.none,
    //     chunckIndex: i + 1,
    //   ));
    // }

    // if (result[0]) {
    //   emit(state.copyWith(
    //     dataExportStatus: FormStatus.requestSuccess,
    //     dataExportPath: result[2],
    //   ));
    // } else {
    //   emit(state.copyWith(
    //     dataExportStatus: FormStatus.requestFailure,
    //     dataExportPath: result[2],
    //   ));
    // }
  }

  void _onAllDataExported(
    AllDataExported event,
    Emitter<Chart18State> emit,
  ) async {
    if (event.isSuccessful) {
      final List<dynamic> result =
          await _dsimRepository.export1p8GRecords(event.log1p8Gs);

      if (result[0]) {
        emit(state.copyWith(
          allDataDownloadStatus: FormStatus.requestSuccess,
          dataExportPath: result[2],
        ));
      } else {
        emit(state.copyWith(
          allDataDownloadStatus: FormStatus.requestFailure,
          dataExportPath: result[2],
        ));
      }
    } else {
      emit(state.copyWith(
        allDataDownloadStatus: FormStatus.requestFailure,
        errorMessage: event.errorMessage,
      ));
    }
  }

  Future<void> _onMoreDataRequested(
    MoreDataRequested event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      dataRequestStatus: FormStatus.requestInProgress,
      // rfDataRequestStatus: FormStatus.none,
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataDownloadStatus: FormStatus.none,
    ));

    List<Log1p8G> log1p8Gs = [];
    log1p8Gs.addAll(state.log1p8Gs);

    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int i = 0; i < 3; i++) {
      List<dynamic> resultOfLog1p8G = await _dsimRepository
          .requestCommand1p8GForLogChunk(state.chunckIndex);

      if (resultOfLog1p8G[0]) {
        log1p8Gs.addAll(resultOfLog1p8G[2]);

        List<List<ValuePair>> dateValueCollectionOfLog =
            _dsimRepository.get1p8GDateValueCollectionOfLogs(log1p8Gs);

        emit(
          state.copyWith(
            dataRequestStatus: FormStatus.requestSuccess,
            log1p8Gs: log1p8Gs,
            dateValueCollectionOfLog: dateValueCollectionOfLog,
            chunckIndex: state.chunckIndex + 1,
            hasNextChunk: resultOfLog1p8G[1],
          ),
        );

        break;
      } else {
        if (i == 2) {
          emit(state.copyWith(
            dataRequestStatus: FormStatus.requestFailure,
            errorMessage: 'Data loading failed',
          ));
        } else {
          continue;
        }
      }
    }
  }

  Future<void> _onRFInOutDataRequested(
    RFInOutDataRequested event,
    Emitter<Chart18State> emit,
  ) async {
    emit(state.copyWith(
      rfDataRequestStatus: FormStatus.requestInProgress,
      // dataRequestStatus: FormStatus.none,
      dataExportStatus: FormStatus.none,
      dataShareStatus: FormStatus.none,
      allDataDownloadStatus: FormStatus.none,
    ));

    List<RFInOut> rfInOuts = [];
    // 最多 retry 3 次, 連續失敗3次就視為失敗
    for (int i = 0; i < 3; i++) {
      List<dynamic> resultOf1p8G3 = await _dsimRepository.requestCommand1p8G3();

      if (resultOf1p8G3[0]) {
        rfInOuts.addAll(resultOf1p8G3[1]);

        List<List<ValuePair>> dateValueCollectionOfLog =
            _dsimRepository.get1p8GValueCollectionOfRFInOut(rfInOuts);

        emit(
          state.copyWith(
            rfDataRequestStatus: FormStatus.requestSuccess,
            rfInOuts: rfInOuts,
            valueCollectionOfRFInOut: dateValueCollectionOfLog,
          ),
        );

        break;
      } else {
        if (i == 2) {
          emit(state.copyWith(
            rfDataRequestStatus: FormStatus.requestFailure,
            errorMessage: 'Data loading failed',
          ));
        } else {
          continue;
        }
      }
    }
  }
}
