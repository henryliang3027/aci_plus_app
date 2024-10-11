import 'dart:convert';
import 'dart:io';

import 'package:aci_plus_app/core/utils.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/distribution_config.dart';
// import 'package:aci_plus_app/repositories/dongle.dart';
import 'package:aci_plus_app/core/form_status.dart';
import 'package:aci_plus_app/repositories/node_config.dart';
import 'package:aci_plus_app/repositories/trunk_config.dart';
import 'package:camera_checker/camera_checker.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zxing2/qrcode.dart';

part 'setting18_config_event.dart';
part 'setting18_config_state.dart';

class Setting18ConfigBloc
    extends Bloc<Setting18ConfigEvent, Setting18ConfigState> {
  Setting18ConfigBloc({
    required ConfigRepository configRepository,
  })  : _configRepository = configRepository,
        super(const Setting18ConfigState()) {
    on<ConfigsRequested>(_onConfigsRequested);
    on<ConfigDeleted>(_onConfigDeleted);
    on<QRDataGenerated>(_onQRDataGenerated);
    on<QRDataScanned>(_onQRDataScanned);
    on<QRImagePicked>(_onQRImagePicked);
    on<QRImageRead>(_onQRImageRead);
    on<CameraAvailabilityChecked>(_onCameraAvailabilityChecked);

    add(const ConfigsRequested());

    if (Platform.isWindows) {
      add(const CameraAvailabilityChecked());
    }
  }

  final ConfigRepository _configRepository;

  Future<void> _onConfigsRequested(
    ConfigsRequested event,
    Emitter<Setting18ConfigState> emit,
  ) async {
    print(await Permission.camera.status.isGranted);
    emit(state.copyWith(
      encodeStaus: FormStatus.none,
      decodeStatus: FormStatus.none,
      pickImageStatus: FormStatus.none,
      formStatus: FormStatus.requestInProgress,
    ));

    List<TrunkConfig> trunkConfigs = _configRepository.getAllTrunkConfigs();
    List<DistributionConfig> distributionConfigs =
        _configRepository.getAllDistributionConfigs();
    List<NodeConfig> nodeConfigs = _configRepository.getAllNodeConfigs();

    emit(state.copyWith(
      formStatus: FormStatus.requestSuccess,
      trunkConfigs: trunkConfigs,
      distributionConfigs: distributionConfigs,
      nodeConfigs: nodeConfigs,
    ));
  }

  Future<void> _onConfigDeleted(
    ConfigDeleted event,
    Emitter<Setting18ConfigState> emit,
  ) async {
    await _configRepository.deleteConfig(
      groupId: event.groupId,
      id: event.id,
    );

    List<TrunkConfig> trunkConfigs = _configRepository.getAllTrunkConfigs();
    List<DistributionConfig> distributionConfigs =
        _configRepository.getAllDistributionConfigs();
    List<NodeConfig> nodeConfigs = _configRepository.getAllNodeConfigs();

    emit(state.copyWith(
      encodeStaus: FormStatus.none,
      decodeStatus: FormStatus.none,
      pickImageStatus: FormStatus.none,
      formStatus: FormStatus.requestSuccess,
      trunkConfigs: trunkConfigs,
      distributionConfigs: distributionConfigs,
      nodeConfigs: nodeConfigs,
    ));
  }

  void _onQRDataGenerated(
    QRDataGenerated event,
    Emitter<Setting18ConfigState> emit,
  ) {
    emit(state.copyWith(
      encodeStaus: FormStatus.requestInProgress,
      decodeStatus: FormStatus.none,
      pickImageStatus: FormStatus.none,
    ));

    // Dongle dongle = const Dongle();
    // String encodedData = jsonEncode(dongle.toJson());

    List<String> trunkConfigJsons = [
      for (TrunkConfig trunkConfig in state.trunkConfigs) ...[
        jsonEncode(trunkConfig.toJson())
      ]
    ];

    List<String> distributionConfigJsons = [
      for (DistributionConfig distributionConfig in state
          .distributionConfigs) ...[jsonEncode(distributionConfig.toJson())]
    ];

    List<String> nodeConfigJsons = [
      for (NodeConfig nodeConfig in state.nodeConfigs) ...[
        jsonEncode(nodeConfig.toJson())
      ]
    ];

    String strTrunkConfigJsons =
        trunkConfigJsons.join(',').isNotEmpty ? trunkConfigJsons.join(',') : '';
    String strDistributionConfigJsons = distributionConfigJsons.join(',');
    String strNodeConfigJsons = nodeConfigJsons.join(',');

    String encodedData =
        '$strTrunkConfigJsons $strDistributionConfigJsons $strNodeConfigJsons';

    print(trunkConfigJsons.join(','));
    print(distributionConfigJsons.join(','));
    print(nodeConfigJsons.join(','));
    print('data:$encodedData');

    emit(state.copyWith(
      encodeStaus: FormStatus.requestSuccess,
      encodedData: encodedData,
    ));
  }

  List<String> getSplitRawData(String rawData) {
    List<String> splitRawData = rawData.split(' ');

    // 2.2.0 版本沒有 Node config, 賦予空字串
    if (splitRawData.length == 2) {
      splitRawData.add('');
    }

    return splitRawData;
  }

  Future<List<List>> parseConfigData(String rawData) async {
    List<TrunkConfig> trunkConfigs = [];
    List<DistributionConfig> distributionConfigs = [];
    List<NodeConfig> nodeConfigs = [];

    RegExp mapRegex = RegExp(r'(\{[^{}]*\})');

    List<String> splitRawData = getSplitRawData(rawData);

    String trunkRawData = splitRawData[0];
    String distributionRawData = splitRawData[1];
    String nodeRawData = splitRawData[2];
    // print('-----trunk------');
    // print(trunkRawData);
    // print('-----distribution------');
    // print(distributionRawData);

    Iterable<Match> trunkConfigMatches = mapRegex.allMatches(trunkRawData);
    Iterable<Match> distributionConfigMatches =
        mapRegex.allMatches(distributionRawData);
    Iterable<Match> nodeConfigMatches = mapRegex.allMatches(nodeRawData);

    print('-----trunk------');

    for (int i = 0; i < trunkConfigMatches.length; i++) {
      if (i == 3) {
        break;
      }
      Match match = trunkConfigMatches.elementAt(i);
      String json = match[0]!;
      print(json);
      TrunkConfig trunkConfig = TrunkConfig.fromJson(jsonDecode(json));
      trunkConfigs.add(trunkConfig);
    }

    print('-----distribution------');

    for (int i = 0; i < distributionConfigMatches.length; i++) {
      if (i == 3) {
        break;
      }
      Match match = distributionConfigMatches.elementAt(i);
      String json = match[0]!;
      print(json);
      DistributionConfig distributionConfig =
          DistributionConfig.fromJson(jsonDecode(json));
      distributionConfigs.add(distributionConfig);
    }

    print('-----node------');

    for (int i = 0; i < nodeConfigMatches.length; i++) {
      if (i == 3) {
        break;
      }
      Match match = nodeConfigMatches.elementAt(i);
      String json = match[0]!;
      print(json);
      NodeConfig nodeConfig = NodeConfig.fromJson(jsonDecode(json));
      nodeConfigs.add(nodeConfig);
    }

    await _configRepository.updateConfigsByQRCode(
      trunkConfigs: trunkConfigs,
      distributionConfigs: distributionConfigs,
      nodeConfigs: nodeConfigs,
    );

    return [trunkConfigs, distributionConfigs, nodeConfigs];
  }

  Future<void> _onQRDataScanned(
    QRDataScanned event,
    Emitter<Setting18ConfigState> emit,
  ) async {
    emit(state.copyWith(
      encodeStaus: FormStatus.none,
      decodeStatus: FormStatus.requestInProgress,
      pickImageStatus: FormStatus.none,
    ));

    List<List> configs = await parseConfigData(event.rawData);

    // Extract the individual lists from the returned result
    List<TrunkConfig> trunkConfigs = configs[0] as List<TrunkConfig>;
    List<DistributionConfig> distributionConfigs =
        configs[1] as List<DistributionConfig>;
    List<NodeConfig> nodeConfigs = configs[2] as List<NodeConfig>;

    emit(state.copyWith(
      decodeStatus: FormStatus.requestSuccess,
      trunkConfigs: trunkConfigs,
      distributionConfigs: distributionConfigs,
      nodeConfigs: nodeConfigs,
    ));
  }

  Future<void> _onQRImagePicked(
    QRImagePicked event,
    Emitter<Setting18ConfigState> emit,
  ) async {
    emit(state.copyWith(
      encodeStaus: FormStatus.none,
      decodeStatus: FormStatus.none,
      pickImageStatus: FormStatus.requestInProgress,
    ));

    FilePickerResult? fileResult = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    String imageFilePath =
        fileResult != null ? fileResult.files.single.path! : '';

    emit(state.copyWith(
      encodeStaus: FormStatus.none,
      decodeStatus: FormStatus.requestInProgress,
      pickImageStatus: FormStatus.requestSuccess,
      imageFilePath: imageFilePath,
    ));
  }

  Future<void> _onQRImageRead(
    QRImageRead event,
    Emitter<Setting18ConfigState> emit,
  ) async {
    emit(state.copyWith(
      encodeStaus: FormStatus.none,
      decodeStatus: FormStatus.requestInProgress,
      pickImageStatus: FormStatus.none,
    ));

    Image? qrImage = decodePng(File(state.imageFilePath).readAsBytesSync());

    if (qrImage != null) {
      LuminanceSource source = RGBLuminanceSource(
          qrImage.width,
          qrImage.height,
          qrImage
              .convert(numChannels: 4)
              .getBytes(order: ChannelOrder.abgr)
              .buffer
              .asInt32List());
      BinaryBitmap bitmap = BinaryBitmap(GlobalHistogramBinarizer(source));
      QRCodeReader reader = QRCodeReader();

      try {
        Result rawData = reader.decode(bitmap);

        if (RegexUtil.configJsonRegex.hasMatch(rawData.text) ||
            RegexUtil.configJsonRegex220.hasMatch(rawData.text)) {
          List<List> configs = await parseConfigData(rawData.text);

          // Extract the individual lists from the returned result
          List<TrunkConfig> trunkConfigs = configs[0] as List<TrunkConfig>;
          List<DistributionConfig> distributionConfigs =
              configs[1] as List<DistributionConfig>;
          List<NodeConfig> nodeConfigs = configs[2] as List<NodeConfig>;

          emit(state.copyWith(
            decodeStatus: FormStatus.requestSuccess,
            trunkConfigs: trunkConfigs,
            distributionConfigs: distributionConfigs,
            nodeConfigs: nodeConfigs,
          ));
        } else {
          emit(state.copyWith(
            decodeStatus: FormStatus.requestFailure,
            pickImageStatus: FormStatus.requestSuccess,
            trunkConfigs: state.trunkConfigs,
            distributionConfigs: state.distributionConfigs,
            nodeConfigs: state.nodeConfigs,
          ));
        }
      } catch (e) {
        // decode code 內容失敗時 emit 失敗的狀態
        emit(state.copyWith(
          decodeStatus: FormStatus.requestFailure,
          pickImageStatus: FormStatus.requestSuccess,
          trunkConfigs: state.trunkConfigs,
          distributionConfigs: state.distributionConfigs,
          nodeConfigs: state.nodeConfigs,
        ));
      }
    } else {
      // decode image 失敗時 emit 失敗的狀態
      emit(state.copyWith(
        decodeStatus: FormStatus.requestFailure,
        pickImageStatus: FormStatus.requestSuccess,
        trunkConfigs: state.trunkConfigs,
        distributionConfigs: state.distributionConfigs,
        nodeConfigs: state.nodeConfigs,
      ));
    }
  }

  Future<void> _onCameraAvailabilityChecked(
    CameraAvailabilityChecked event,
    Emitter<Setting18ConfigState> emit,
  ) async {
    final CameraChecker cameraChecker = CameraChecker();
    bool isCameraAvailable = await cameraChecker.isCameraAvailable() ?? false;

    emit(state.copyWith(
      isCameraAvailable: isCameraAvailable,
    ));
  }
}
