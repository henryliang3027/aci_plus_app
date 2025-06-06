import 'package:aci_plus_app/core/data_key.dart';

enum SettingConfiruration {
  location,
  coordinates,
  splitOptions,
  pilotFrequencySelect,
  startFrequency,
  stopFrequency,
  startLevel, // 為了匯出 configuration 資料而加的
  stopLevel, // 為了匯出 configuration 資料而加的
  rfLevelFineTuner, // 微調 startLevel, stopLevel
  pilot1,
  pilot2,
  agcMode,
  alcMode,
  logInterval,
  rfOutputLogInterval,
  cableLength,
  forwardConfigMode, // 只有 C-Cor Node 有
  forwardMode, // 只有 C-Cor Node 有
}

enum SettingThreshold {
  workingMode,
  splitOptions,
  temperature,
  inputVoltage24V,
  inputVoltage8V,
  inputVoltage5p2V,
  inputVoltage3p3V,
  inputVoltageRipple24V,
  inputPower1p8G,
  outputPower,
  outputPower1,
  outputPower2,
  outputPower3,
  outputPower4,
  outputPower5,
  outputPower6,
  pilot1Status,
  pilot2Status,
  startFrequencyOutputLevel,
  stopFrequencyOutputLevel,
  operatingSlope,
  outputAttenuation1,
  outputAttenuation2,
  outputAttenuation3,
  outputAttenuation4,
  outputAttenuation5,
  outputAttenuation6,
  outputEqualizer1,
  outputEqualizer2,
  outputEqualizer3,
  outputEqualizer4,
  outputEqualizer5,
  outputEqualizer6,
}

enum SettingControl {
  forwardInputAttenuation1,
  forwardInputAttenuation2,
  forwardInputAttenuation3,
  forwardInputAttenuation4,
  forwardInputAttenuation5,
  forwardInputAttenuation6,
  forwardInputEqualizer1,
  forwardInputEqualizer2,
  forwardInputEqualizer3,
  forwardInputEqualizer4,
  forwardInputEqualizer5,
  forwardInputEqualizer6,
  forwardOutputEqualizer1,
  forwardOutputEqualizer2,
  forwardOutputEqualizer3,
  forwardOutputEqualizer4,
  forwardOutputEqualizer5,
  forwardOutputEqualizer6,
  forwardOutputEqualizer2And3,
  forwardOutputEqualizer3And4,
  forwardOutputEqualizer5And6,
  forwardOutputAttenuation1,
  forwardOutputAttenuation3,
  forwardOutputAttenuation4,
  forwardOutputAttenuation6,
  forwardOutputAttenuation2And3,
  forwardOutputAttenuation3And4,
  forwardOutputAttenuation5And6,
  forwardBiasCurrent1,
  forwardBiasCurrent3,
  forwardBiasCurrent4,
  forwardBiasCurrent6,
  returnOutputAttenuation1,
  returnOutputEqualizer1,
  returnInputAttenuation1,
  returnInputAttenuation2,
  returnInputAttenuation3,
  returnInputAttenuation4,
  returnInputAttenuation5,
  returnInputAttenuation6,
  returnInputAttenuation2And3,
  returnInputAttenuation5And6,
  returnIngressSetting1,
  returnIngressSetting2,
  returnIngressSetting3,
  returnIngressSetting4,
  returnIngressSetting5,
  returnIngressSetting6,
  returnIngressSetting2And3,
  returnIngressSetting5And6,
}

enum EQType {
  none,
  board,
  module,
}

enum BenchMode {
  frequency1p8G,
  frequency1p2G,
}

// 0: MFTJ (預留, app不適用)
// 1: SDLE
// 2: MOTO BLE
// 3: MOTO MB
// 4: C-Cor Node
// 5: C-Cor TR
// 6: C-Cor BR
// 7: C-Cor LE
// 8: SDAT
// 9: SDAM
// 10: MFT8

const Map<String, EQType> eqTypeMap = {
  'd': EQType.none, // DSIM
  '0': EQType.module, // MFTJ (預留, app不適用)
  '1': EQType.module, // SDLE
  '2': EQType.module, // MOTO BLE
  '3': EQType.module, // MOTO MB
  '4': EQType.module, // C-Cor Node
  '5': EQType.module, // C-Cor TR
  '6': EQType.module, // C-Cor BR
  '7': EQType.module, // C-Cor LE
  '8': EQType.module, // SDAT
  '9': EQType.module, // SDAM
  '10': EQType.board, // MFT8
  '11': EQType.board, // SDLE EQ on board
  '12': EQType.board, // MOTO BLE EQ on board
  '13': EQType.board, // MOTO MB EQ on board
  '15': EQType.module, // C-Cor TR EQ on board
  '16': EQType.module, // C-Cor BR EQ on board
  '17': EQType.module, // C-Cor LE EQ on board
  '18': EQType.module, // SDAT EQ on board
  '19': EQType.module, // SDAM EQ on board
  '21': EQType.module, // SA BT EQ on board
  '22': EQType.module, // SA HD EQ on board
  '23': EQType.module, // SA LE EQ on board
};

const Map<String, String> settingGraphFilePath = {
  '1': 'assets/circuits/SDLE_1.8G_20240822.svg', // SDLE
  '2': 'assets/circuits/BLE_1.8G_20240822.svg', // BLE
  '3': 'assets/circuits/MB_1.8G_20240822.svg', // MB
  '4': 'assets/circuits/NODE_1.8G_20240822.svg', // C-Cor Node
  '5': 'assets/circuits/TR_1.8G_20240822.svg', // C-Cor TR
  '6': 'assets/circuits/BR_1.8G_20250411.svg', // C-Cor BR
  '7': 'assets/circuits/LE_1.8G_20240822.svg', // C-Cor LE
  '8': 'assets/circuits/SDAT_1.8G_20240822.svg', // SDAT
  '9': 'assets/circuits/SDAM_1.8G_20240822.svg', // SDAM
  '10': 'assets/circuits/MFT8_1.8G_20250206.svg', // MFT8
  '11': 'assets/circuits/SDLE_1.8G_20240822.svg', // SDLE (EQ on board)
  '12': 'assets/circuits/BLE_1.8G_20240822.svg', // BLE (EQ on board)
  '13': 'assets/circuits/MB_1.8G_20240822.svg', // MB (EQ on board)
  '15': 'assets/circuits/TR_1.8G_20240822.svg', // C-Cor TR (EQ on board)
  '16': 'assets/circuits/BR_1.8G_20250411.svg', // C-Cor BR (EQ on board)
  '17': 'assets/circuits/LE_1.8G_20240822.svg', // C-Cor LE (EQ on board)
  '18': 'assets/circuits/SDAT_1.8G_20240822.svg', // SDAT (EQ on board)
  '19': 'assets/circuits/SDAM_1.8G_20240822.svg', // SDAM (EQ on board)
};

const Map<String, String> namePlateFilePath = {
  '1': '',
  '2': 'assets/nameplates/BLE.png',
  '3': 'assets/nameplates/MB.png',
  '4': 'assets/nameplates/NODE.png',
  '5': 'assets/nameplates/TR.png',
  '6': 'assets/nameplates/BR.png',
  '7': 'assets/nameplates/LE.png',
  '8': '',
  '9': '',
};

class SettingItemTable {
  static Map<String, List<Enum>> itemsMap = {
    '1': [
      // SDLE
      SettingConfiruration.location,
      SettingConfiruration.coordinates,
      // SettingConfiruration.splitOptions,
      SettingConfiruration.pilotFrequencySelect,
      SettingConfiruration.startFrequency,
      SettingConfiruration.stopFrequency,
      SettingConfiruration.rfLevelFineTuner,
      SettingConfiruration.pilot1,
      SettingConfiruration.pilot2,
      SettingConfiruration.agcMode,
      SettingConfiruration.alcMode,
      SettingConfiruration.logInterval,
      SettingConfiruration.rfOutputLogInterval,
      SettingConfiruration.cableLength,
      SettingThreshold.workingMode,
      // SettingThreshold.splitOptions,
      SettingThreshold.temperature,
      SettingThreshold.inputVoltage24V,
      SettingThreshold.inputVoltageRipple24V,
      SettingThreshold.outputPower,
      SettingThreshold.pilot1Status,
      SettingThreshold.pilot2Status,
      SettingThreshold.startFrequencyOutputLevel,
      SettingThreshold.stopFrequencyOutputLevel,
      SettingControl.forwardInputAttenuation1,
      SettingControl.forwardInputEqualizer1,
      SettingControl.returnOutputAttenuation1,
      SettingControl.returnOutputEqualizer1,
      SettingControl.returnInputAttenuation2,
      SettingControl.returnIngressSetting2,
    ],
    '2': [
      // Moto BLE
      SettingConfiruration.location,
      SettingConfiruration.coordinates,
      // SettingConfiruration.splitOptions,
      SettingConfiruration.pilotFrequencySelect,
      SettingConfiruration.startFrequency,
      SettingConfiruration.stopFrequency,
      SettingConfiruration.rfLevelFineTuner,
      SettingConfiruration.pilot1,
      SettingConfiruration.pilot2,
      SettingConfiruration.agcMode,
      SettingConfiruration.alcMode,
      SettingConfiruration.logInterval,
      SettingConfiruration.rfOutputLogInterval,
      SettingConfiruration.cableLength,
      SettingThreshold.workingMode,
      // SettingThreshold.splitOptions,
      SettingThreshold.temperature,
      SettingThreshold.inputVoltage24V,
      SettingThreshold.inputVoltageRipple24V,
      SettingThreshold.outputPower,
      SettingThreshold.pilot1Status,
      SettingThreshold.pilot2Status,
      SettingThreshold.startFrequencyOutputLevel,
      SettingThreshold.stopFrequencyOutputLevel,
      SettingControl.forwardInputAttenuation1,
      SettingControl.forwardInputEqualizer1,
      SettingControl.returnOutputAttenuation1,
      SettingControl.returnOutputEqualizer1,
      SettingControl.returnInputAttenuation2,
      SettingControl.returnIngressSetting2,
    ],
    '3': [
      // Moto MB
      SettingConfiruration.location,
      SettingConfiruration.coordinates,
      // SettingConfiruration.splitOptions,
      SettingConfiruration.pilotFrequencySelect,
      SettingConfiruration.startFrequency,
      SettingConfiruration.stopFrequency,
      SettingConfiruration.rfLevelFineTuner,
      SettingConfiruration.pilot1,
      SettingConfiruration.pilot2,
      SettingConfiruration.agcMode,
      SettingConfiruration.alcMode,
      SettingConfiruration.logInterval,
      SettingConfiruration.rfOutputLogInterval,
      SettingConfiruration.cableLength,
      SettingThreshold.workingMode,
      // SettingThreshold.splitOptions,
      SettingThreshold.temperature,
      SettingThreshold.inputVoltage24V,
      SettingThreshold.inputVoltageRipple24V,
      SettingThreshold.outputPower,
      SettingThreshold.pilot1Status,
      SettingThreshold.pilot2Status,
      SettingThreshold.startFrequencyOutputLevel,
      SettingThreshold.stopFrequencyOutputLevel,
      SettingControl.forwardInputAttenuation1,
      SettingControl.forwardInputEqualizer1,
      SettingControl.forwardOutputAttenuation3And4,
      SettingControl.returnOutputAttenuation1,
      SettingControl.returnOutputEqualizer1,
      SettingControl.returnInputAttenuation2,
      SettingControl.returnInputAttenuation3,
      SettingControl.returnInputAttenuation4,
      SettingControl.returnIngressSetting2,
      SettingControl.returnIngressSetting3,
      SettingControl.returnIngressSetting4,
    ],
    '4': [
      // C-Cor Node
      SettingConfiruration.location,
      SettingConfiruration.coordinates,
      SettingConfiruration.forwardMode,
      SettingConfiruration.forwardConfigMode,
      // SettingConfiruration.splitOptions,
      SettingConfiruration.logInterval,
      // SettingThreshold.splitOptions,
      SettingThreshold.temperature,
      SettingThreshold.inputVoltage24V,
      SettingThreshold.outputPower,
      SettingThreshold.outputPower1,
      SettingThreshold.outputPower3,
      SettingThreshold.outputPower4,
      SettingThreshold.outputPower6,
      SettingThreshold.outputAttenuation1,
      SettingThreshold.outputAttenuation3,
      SettingThreshold.outputAttenuation4,
      SettingThreshold.outputAttenuation6,
      SettingThreshold.outputEqualizer1,
      SettingThreshold.outputEqualizer3,
      SettingThreshold.outputEqualizer4,
      SettingThreshold.outputEqualizer6,
      SettingControl.forwardOutputAttenuation1,
      SettingControl.forwardOutputAttenuation3,
      SettingControl.forwardOutputAttenuation4,
      SettingControl.forwardOutputAttenuation6,
      SettingControl.forwardOutputEqualizer1,
      SettingControl.forwardOutputEqualizer3,
      SettingControl.forwardOutputEqualizer4,
      SettingControl.forwardOutputEqualizer6,
      SettingControl.forwardBiasCurrent1,
      SettingControl.forwardBiasCurrent3,
      SettingControl.forwardBiasCurrent4,
      SettingControl.forwardBiasCurrent6,
      SettingControl.returnInputAttenuation1,
      SettingControl.returnInputAttenuation3,
      SettingControl.returnInputAttenuation4,
      SettingControl.returnInputAttenuation6,
      SettingControl.returnIngressSetting1,
      SettingControl.returnIngressSetting3,
      SettingControl.returnIngressSetting4,
      SettingControl.returnIngressSetting6,
    ],
    '5': [
      // C-Cor TR
      SettingConfiruration.location,
      SettingConfiruration.coordinates,
      // SettingConfiruration.splitOptions,
      SettingConfiruration.pilotFrequencySelect,
      SettingConfiruration.startFrequency,
      SettingConfiruration.stopFrequency,
      SettingConfiruration.rfLevelFineTuner,
      SettingConfiruration.pilot1,
      SettingConfiruration.pilot2,
      SettingConfiruration.agcMode,
      SettingConfiruration.alcMode,
      SettingConfiruration.logInterval,
      SettingConfiruration.rfOutputLogInterval,
      SettingConfiruration.cableLength,
      SettingThreshold.workingMode,
      // SettingThreshold.splitOptions,
      SettingThreshold.temperature,
      SettingThreshold.inputVoltage24V,
      SettingThreshold.inputVoltageRipple24V,
      SettingThreshold.outputPower,
      SettingThreshold.pilot1Status,
      SettingThreshold.pilot2Status,
      SettingThreshold.startFrequencyOutputLevel,
      SettingThreshold.stopFrequencyOutputLevel,
      SettingControl.forwardInputAttenuation1,
      SettingControl.forwardInputEqualizer1,
      SettingControl.forwardOutputAttenuation2And3,
      SettingControl.forwardOutputAttenuation5And6,
      SettingControl.forwardOutputEqualizer2And3,
      SettingControl.forwardOutputEqualizer5And6,
      SettingControl.returnOutputAttenuation1,
      SettingControl.returnOutputEqualizer1,
      SettingControl.returnInputAttenuation4,
      SettingControl.returnInputAttenuation2And3,
      SettingControl.returnInputAttenuation5And6,
      SettingControl.returnIngressSetting4,
      SettingControl.returnIngressSetting2And3,
      SettingControl.returnIngressSetting5And6,
    ],
    '6': [
      // C-Cor BR
      SettingConfiruration.location,
      SettingConfiruration.coordinates,
      // SettingConfiruration.splitOptions,
      SettingConfiruration.pilotFrequencySelect,
      SettingConfiruration.startFrequency,
      SettingConfiruration.stopFrequency,
      SettingConfiruration.rfLevelFineTuner,
      SettingConfiruration.pilot1,
      SettingConfiruration.pilot2,
      SettingConfiruration.agcMode,
      SettingConfiruration.alcMode,
      SettingConfiruration.logInterval,
      SettingConfiruration.rfOutputLogInterval,
      SettingConfiruration.cableLength,
      SettingThreshold.workingMode,
      // SettingThreshold.splitOptions,
      SettingThreshold.temperature,
      SettingThreshold.inputVoltage24V,
      SettingThreshold.inputVoltageRipple24V,
      SettingThreshold.outputPower,
      SettingThreshold.pilot1Status,
      SettingThreshold.pilot2Status,
      SettingThreshold.startFrequencyOutputLevel,
      SettingThreshold.stopFrequencyOutputLevel,
      SettingControl.forwardInputAttenuation1,
      SettingControl.forwardInputEqualizer1,
      SettingControl.forwardOutputAttenuation2And3,
      SettingControl.forwardOutputEqualizer2And3,
      SettingControl.forwardOutputAttenuation5And6,
      SettingControl.forwardOutputEqualizer5And6,
      SettingControl.returnOutputAttenuation1,
      SettingControl.returnOutputEqualizer1,
      SettingControl.returnInputAttenuation2And3,
      SettingControl.returnInputAttenuation5And6,
      SettingControl.returnIngressSetting2And3,
      SettingControl.returnIngressSetting5And6,
    ],
    '7': [
      // C-Cor LE
      SettingConfiruration.location,
      SettingConfiruration.coordinates,
      // SettingConfiruration.splitOptions,
      SettingConfiruration.pilotFrequencySelect,
      SettingConfiruration.startFrequency,
      SettingConfiruration.stopFrequency,
      SettingConfiruration.rfLevelFineTuner,
      SettingConfiruration.pilot1,
      SettingConfiruration.pilot2,
      SettingConfiruration.agcMode,
      SettingConfiruration.alcMode,
      SettingConfiruration.logInterval,
      SettingConfiruration.rfOutputLogInterval,
      SettingConfiruration.cableLength,
      SettingThreshold.workingMode,
      // SettingThreshold.splitOptions,
      SettingThreshold.temperature,
      SettingThreshold.inputVoltage24V,
      SettingThreshold.inputVoltageRipple24V,
      SettingThreshold.outputPower,
      SettingThreshold.pilot1Status,
      SettingThreshold.pilot2Status,
      SettingThreshold.startFrequencyOutputLevel,
      SettingThreshold.stopFrequencyOutputLevel,
      SettingControl.forwardInputAttenuation1,
      SettingControl.forwardInputEqualizer1,
      SettingControl.returnOutputAttenuation1,
      SettingControl.returnOutputEqualizer1,
      SettingControl.returnInputAttenuation2,
      SettingControl.returnIngressSetting2,
    ],
    '8': [
      // SDAT
      SettingConfiruration.location,
      SettingConfiruration.coordinates,
      // SettingConfiruration.splitOptions,
      SettingConfiruration.pilotFrequencySelect,
      SettingConfiruration.startFrequency,
      SettingConfiruration.stopFrequency,
      SettingConfiruration.rfLevelFineTuner,
      SettingConfiruration.pilot1,
      SettingConfiruration.pilot2,
      SettingConfiruration.agcMode,
      SettingConfiruration.alcMode,
      SettingConfiruration.logInterval,
      SettingConfiruration.rfOutputLogInterval,
      SettingConfiruration.cableLength,
      SettingThreshold.workingMode,
      // SettingThreshold.splitOptions,
      SettingThreshold.temperature,
      SettingThreshold.inputVoltage24V,
      SettingThreshold.inputVoltageRipple24V,
      SettingThreshold.outputPower,
      SettingThreshold.pilot1Status,
      SettingThreshold.pilot2Status,
      SettingThreshold.startFrequencyOutputLevel,
      SettingThreshold.stopFrequencyOutputLevel,
      SettingControl.forwardInputAttenuation1,
      SettingControl.forwardInputEqualizer1,
      SettingControl.forwardOutputAttenuation3,
      SettingControl.forwardOutputEqualizer3,
      SettingControl.forwardOutputAttenuation4,
      SettingControl.forwardOutputEqualizer4,
      SettingControl.returnOutputAttenuation1,
      SettingControl.returnOutputEqualizer1,
      SettingControl.returnInputAttenuation2,
      SettingControl.returnInputAttenuation3,
      SettingControl.returnInputAttenuation4,
      SettingControl.returnIngressSetting2,
      SettingControl.returnIngressSetting3,
      SettingControl.returnIngressSetting4,
    ],
    '9': [
      // SDAM
      SettingConfiruration.location,
      SettingConfiruration.coordinates,
      // SettingConfiruration.splitOptions,
      SettingConfiruration.pilotFrequencySelect,
      SettingConfiruration.startFrequency,
      SettingConfiruration.stopFrequency,
      SettingConfiruration.rfLevelFineTuner,
      SettingConfiruration.pilot1,
      SettingConfiruration.pilot2,
      SettingConfiruration.agcMode,
      SettingConfiruration.alcMode,
      SettingConfiruration.logInterval,
      SettingConfiruration.rfOutputLogInterval,
      SettingConfiruration.cableLength,
      SettingThreshold.workingMode,
      // SettingThreshold.splitOptions,
      SettingThreshold.temperature,
      SettingThreshold.inputVoltage24V,
      SettingThreshold.inputVoltageRipple24V,
      SettingThreshold.outputPower,
      SettingThreshold.pilot1Status,
      SettingThreshold.pilot2Status,
      SettingThreshold.startFrequencyOutputLevel,
      SettingThreshold.stopFrequencyOutputLevel,
      SettingControl.forwardInputAttenuation1,
      SettingControl.forwardInputEqualizer1,
      SettingControl.forwardOutputAttenuation3And4,
      SettingControl.returnOutputAttenuation1,
      SettingControl.returnOutputEqualizer1,
      SettingControl.returnInputAttenuation2,
      SettingControl.returnInputAttenuation3,
      SettingControl.returnInputAttenuation4,
      SettingControl.returnIngressSetting2,
      SettingControl.returnIngressSetting3,
      SettingControl.returnIngressSetting4,
    ],
    '10': [
      // MFT8
      SettingConfiruration.location,
      SettingConfiruration.coordinates,
      // SettingConfiruration.splitOptions,
      SettingConfiruration.pilotFrequencySelect,
      SettingConfiruration.startFrequency,
      SettingConfiruration.stopFrequency,
      SettingConfiruration.rfLevelFineTuner,
      SettingConfiruration.pilot1,
      SettingConfiruration.pilot2,
      SettingConfiruration.agcMode,
      SettingConfiruration.alcMode,
      SettingConfiruration.logInterval,
      SettingConfiruration.rfOutputLogInterval,
      SettingConfiruration.cableLength,
      SettingThreshold.workingMode,
      // SettingThreshold.splitOptions,
      SettingThreshold.temperature,
      SettingThreshold.inputVoltage24V,
      SettingThreshold.inputVoltageRipple24V,
      SettingThreshold.outputPower,
      SettingThreshold.pilot1Status,
      SettingThreshold.pilot2Status,
      SettingThreshold.startFrequencyOutputLevel,
      SettingThreshold.stopFrequencyOutputLevel,
      SettingControl.forwardInputAttenuation1,
      SettingControl.forwardInputEqualizer1,
      SettingControl.returnOutputAttenuation1,
      SettingControl.returnOutputEqualizer1,
      SettingControl.returnInputAttenuation2,
      SettingControl.returnIngressSetting2,
    ],
  };

  static Map<String, List<Map<Enum, DataKey>>> controlItemDataMapCollection = {
    '1': sdleControlItem,
    '2': bleControlItem,
    '3': mbControlItem,
    '4': ccorNodeControlItem,
    '5': trControlItem,
    '6': brControlItem,
    '7': leControlItem,
    '8': sdatControlItem,
    '9': sdamControlItem,
    '10': mft8ControlItem,
    '11': sdleControlItem,
    '12': bleControlItem,
    '13': mbControlItem,
    '15': trControlItem,
    '16': brControlItem,
    '17': leControlItem,
    '18': sdatControlItem,
    '19': sdamControlItem,
  };

  static List<Map<Enum, DataKey>> sdleControlItem = [
    // SDLE
    {
      SettingControl.forwardInputAttenuation1: DataKey.dsVVA1,
      SettingControl.forwardInputEqualizer1: DataKey.dsSlope1,
    },
    {
      SettingControl.returnOutputAttenuation1: DataKey.usVCA2,
      SettingControl.returnOutputEqualizer1: DataKey.eREQ,
      SettingControl.returnInputAttenuation2: DataKey.usVCA1,
      SettingControl.returnIngressSetting2: DataKey.ingressSetting2,
    }
  ];

  static List<Map<Enum, DataKey>> bleControlItem = [
    // Moto BLE
    {
      SettingControl.forwardInputAttenuation1: DataKey.dsVVA1,
      SettingControl.forwardInputEqualizer1: DataKey.dsSlope1,
    },
    {
      SettingControl.returnOutputAttenuation1: DataKey.usVCA2,
      SettingControl.returnOutputEqualizer1: DataKey.eREQ,
      SettingControl.returnInputAttenuation2: DataKey.usVCA1,
      SettingControl.returnIngressSetting2: DataKey.ingressSetting2,
    }
  ];

  static List<Map<Enum, DataKey>> mbControlItem = [
    // Moto MB
    {
      SettingControl.forwardInputAttenuation1: DataKey.dsVVA1,
      SettingControl.forwardInputEqualizer1: DataKey.dsSlope1,
      SettingControl.forwardOutputAttenuation3And4: DataKey.dsVVA4,
    },
    {
      SettingControl.returnOutputAttenuation1: DataKey.usVCA2,
      SettingControl.returnOutputEqualizer1: DataKey.eREQ,
      SettingControl.returnInputAttenuation2: DataKey.usVCA1,
      SettingControl.returnInputAttenuation3: DataKey.usVCA3,
      SettingControl.returnInputAttenuation4: DataKey.usVCA4,
      SettingControl.returnIngressSetting2: DataKey.ingressSetting2,
      SettingControl.returnIngressSetting3: DataKey.ingressSetting3,
      SettingControl.returnIngressSetting4: DataKey.ingressSetting4,
    },
  ];

  static List<Map<Enum, DataKey>> ccorNodeControlItem = [
    // C-Cor Node
    {
      SettingControl.forwardInputAttenuation1: DataKey.dsVVA1,
      SettingControl.forwardInputAttenuation3: DataKey.dsVVA3,
      SettingControl.forwardInputAttenuation4: DataKey.dsVVA4,
      SettingControl.forwardInputAttenuation6: DataKey.dsVVA6,
      SettingControl.forwardOutputEqualizer1: DataKey.dsOutSlope1,
      SettingControl.forwardOutputEqualizer3: DataKey.dsOutSlope3,
      SettingControl.forwardOutputEqualizer4: DataKey.dsOutSlope4,
      SettingControl.forwardOutputEqualizer6: DataKey.dsOutSlope6,
      SettingControl.forwardBiasCurrent1: DataKey.biasCurrent1,
      SettingControl.forwardBiasCurrent3: DataKey.biasCurrent3,
      SettingControl.forwardBiasCurrent4: DataKey.biasCurrent4,
      SettingControl.forwardBiasCurrent6: DataKey.biasCurrent6,
    },
    {
      SettingControl.returnInputAttenuation1: DataKey.usVCA1,
      SettingControl.returnInputAttenuation3: DataKey.usVCA3,
      SettingControl.returnInputAttenuation4: DataKey.usVCA4,
      SettingControl.returnInputAttenuation6: DataKey.usVCA6,
      SettingControl.returnIngressSetting1: DataKey.ingressSetting1,
      SettingControl.returnIngressSetting3: DataKey.ingressSetting3,
      SettingControl.returnIngressSetting4: DataKey.ingressSetting4,
      SettingControl.returnIngressSetting6: DataKey.ingressSetting6,
    },
  ];

  static List<Map<Enum, DataKey>> trControlItem = [
    {
      // C-Cor TR
      SettingControl.forwardInputAttenuation1: DataKey.dsVVA1,
      SettingControl.forwardInputEqualizer1: DataKey.dsSlope1,
      SettingControl.forwardOutputAttenuation2And3: DataKey.dsVVA4,
      SettingControl.forwardOutputAttenuation5And6: DataKey.dsVVA5,
      SettingControl.forwardOutputEqualizer2And3: DataKey.dsSlope3,
      SettingControl.forwardOutputEqualizer5And6: DataKey.dsSlope4,
    },
    {
      SettingControl.returnOutputAttenuation1: DataKey.usVCA2,
      SettingControl.returnOutputEqualizer1: DataKey.eREQ,
      SettingControl.returnInputAttenuation4: DataKey.usVCA1,
      SettingControl.returnInputAttenuation2And3: DataKey.usVCA3,
      SettingControl.returnInputAttenuation5And6: DataKey.usVCA4,
      SettingControl.returnIngressSetting4: DataKey.ingressSetting2,
      SettingControl.returnIngressSetting2And3: DataKey.ingressSetting3,
      SettingControl.returnIngressSetting5And6: DataKey.ingressSetting4,
    }
  ];

  static List<Map<Enum, DataKey>> brControlItem = [
    {
      // C-Cor BR
      SettingControl.forwardInputAttenuation1: DataKey.dsVVA1,
      SettingControl.forwardInputEqualizer1: DataKey.dsSlope1,
      SettingControl.forwardOutputAttenuation2And3: DataKey.dsVVA4,
      SettingControl.forwardOutputAttenuation5And6: DataKey.dsVVA5,
      SettingControl.forwardOutputEqualizer2And3: DataKey.dsSlope3,
      SettingControl.forwardOutputEqualizer5And6: DataKey.dsSlope4,
    },
    {
      SettingControl.returnOutputAttenuation1: DataKey.usVCA2,
      SettingControl.returnOutputEqualizer1: DataKey.eREQ,
      SettingControl.returnInputAttenuation2And3: DataKey.usVCA3,
      SettingControl.returnInputAttenuation5And6: DataKey.usVCA4,
      SettingControl.returnIngressSetting2And3: DataKey.ingressSetting3,
      SettingControl.returnIngressSetting5And6: DataKey.ingressSetting4,
    }
  ];

  static List<Map<Enum, DataKey>> leControlItem = [
    {
      // C-Cor LE
      SettingControl.forwardInputAttenuation1: DataKey.dsVVA1,
      SettingControl.forwardInputEqualizer1: DataKey.dsSlope1,
    },
    {
      SettingControl.returnOutputAttenuation1: DataKey.usVCA2,
      SettingControl.returnOutputEqualizer1: DataKey.eREQ,
      SettingControl.returnInputAttenuation2: DataKey.usVCA1,
      SettingControl.returnIngressSetting2: DataKey.ingressSetting2,
    }
  ];

  static List<Map<Enum, DataKey>> sdatControlItem = [
    {
      // SDAT
      SettingControl.forwardInputAttenuation1: DataKey.dsVVA1,
      SettingControl.forwardInputEqualizer1: DataKey.dsSlope1,
      SettingControl.forwardOutputAttenuation3: DataKey.dsVVA4,
      SettingControl.forwardOutputEqualizer3: DataKey.dsSlope3,
      SettingControl.forwardOutputAttenuation4: DataKey.dsVVA5,
      SettingControl.forwardOutputEqualizer4: DataKey.dsSlope4,
    },
    {
      SettingControl.returnOutputAttenuation1: DataKey.usVCA2,
      SettingControl.returnOutputEqualizer1: DataKey.eREQ,
      SettingControl.returnInputAttenuation2: DataKey.usVCA1,
      SettingControl.returnInputAttenuation3: DataKey.usVCA3,
      SettingControl.returnInputAttenuation4: DataKey.usVCA4,
      SettingControl.returnIngressSetting2: DataKey.ingressSetting2,
      SettingControl.returnIngressSetting3: DataKey.ingressSetting3,
      SettingControl.returnIngressSetting4: DataKey.ingressSetting4,
    }
  ];

  static List<Map<Enum, DataKey>> sdamControlItem = [
    {
      // SDAM
      SettingControl.forwardInputAttenuation1: DataKey.dsVVA1,
      SettingControl.forwardInputEqualizer1: DataKey.dsSlope1,
      SettingControl.forwardOutputAttenuation3And4: DataKey.dsVVA4,
    },
    {
      SettingControl.returnOutputAttenuation1: DataKey.usVCA2,
      SettingControl.returnOutputEqualizer1: DataKey.eREQ,
      SettingControl.returnInputAttenuation2: DataKey.usVCA1,
      SettingControl.returnInputAttenuation3: DataKey.usVCA3,
      SettingControl.returnInputAttenuation4: DataKey.usVCA4,
      SettingControl.returnIngressSetting2: DataKey.ingressSetting2,
      SettingControl.returnIngressSetting3: DataKey.ingressSetting3,
      SettingControl.returnIngressSetting4: DataKey.ingressSetting4,
    }
  ];

  static List<Map<Enum, DataKey>> mft8ControlItem = [
    // MFT8
    {
      SettingControl.forwardInputAttenuation1: DataKey.dsVVA1,
      SettingControl.forwardInputEqualizer1: DataKey.dsSlope1,
    },
    {
      SettingControl.returnOutputAttenuation1: DataKey.usVCA2,
      SettingControl.returnOutputEqualizer1: DataKey.eREQ,
      SettingControl.returnInputAttenuation2: DataKey.usVCA1,
      SettingControl.returnIngressSetting2: DataKey.ingressSetting2,
    }
  ];
}
