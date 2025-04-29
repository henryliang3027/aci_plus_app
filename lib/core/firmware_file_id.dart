class FirmwareFileTable {
  static const Map<String, List<int>> fileIDMap = {
    '1': [
      76,
      56,
      52,
      54,
      84,
      67,
      50,
      82,
      78,
      56,
    ], // SDLE 'L846TC2RN0'
    '2': [
      65,
      77,
      84,
      45,
      66,
      76,
      56,
      52,
      54,
      84,
      67,
      50,
      82,
      78,
      50,
    ], // MOTO BLE 'AMT-BL846TC2RN0'
    '3': [
      65,
      77,
      84,
      45,
      77,
      66,
      56,
      53,
      49,
      84,
      67,
      50,
      82,
      78,
      48,
    ], // MOTO MB 'AMT-MB851TC2RN0'
    '4': [
      65,
      70,
      77,
      56,
      45,
      79,
      77,
      45,
      50,
    ], // C-Cor Node 'AFM8-OM-2'
    '5': [
      65,
      70,
      77,
      56,
      45,
      84,
      52,
      49,
      84,
      67,
      50,
      82,
      78,
      48,
    ], // C-Cor TR 'AFM8-T41TC2RN0'
    '6': [
      65,
      70,
      77,
      56,
      45,
      66,
      53,
      49,
      84,
      67,
      50,
      82,
      78,
      48,
    ], // C-Cor BR 'AFM8-B51TC2RN0'
    '7': [
      65,
      70,
      77,
      56,
      45,
      76,
      52,
      54,
      84,
      67,
      50,
      82,
      78,
      48,
    ],
    // C-Cor LE 'AFM8-L46TC2RN0'
    '8': [
      84,
      56,
      52,
      49,
      84,
      67,
      50,
      82,
      78,
      48,
    ], // SDAT 'T841TC2RN0'
    '9': [
      77,
      56,
      53,
      49,
      84,
      67,
      50,
      82,
      78,
      48,
    ], // SDAM 'M851TC2RN0'
    '10': [
      77,
      70,
      84,
      56,
      52,
      48,
      80,
      67,
      83,
      54,
      55,
      57,
      32,
      45,
      50,
    ], // MFT8 'MFT840PCS679 -2'
    '11': [
      83,
      68,
      65,
      56,
      45,
      76,
      69,
      52,
      54,
      84,
      67,
      50,
      82,
      84,
      48
    ], // SDA8-LE46TC2RT0
    '12': [
      65,
      77,
      84,
      56,
      45,
      66,
      76,
      52,
      54,
      84,
      67,
      50,
      82,
      84,
      48
    ], // AMT8-BL46TC2RT0
    '13': [
      65,
      77,
      84,
      56,
      45,
      77,
      66,
      53,
      49,
      84,
      67,
      50,
      82,
      84,
      48
    ], // AMT8-MB51TC2RT0
    '15': [
      65,
      70,
      77,
      56,
      45,
      84,
      82,
      52,
      50,
      84,
      67,
      50,
      82,
      84,
      48
    ], // AFM8-TR42TC2RT0
    '16': [
      65,
      70,
      77,
      56,
      45,
      66,
      82,
      53,
      49,
      84,
      67,
      50,
      82,
      84,
      48
    ], // AFM8-BR51TC2RT0
    '17': [
      65,
      70,
      77,
      56,
      45,
      76,
      69,
      52,
      54,
      84,
      67,
      50,
      82,
      84,
      48
    ], // AFM8-LE46TC2RT0
    '18': [
      83,
      68,
      65,
      56,
      45,
      84,
      82,
      52,
      49,
      84,
      67,
      50,
      82,
      84,
      48
    ], // SDA8-TR41TC2RT0
    '19': [
      83,
      68,
      65,
      56,
      45,
      77,
      66,
      52,
      54,
      84,
      67,
      50,
      82,
      84,
      48
    ], // SDA8-MB46TC2RT0
    '21': [
      65,
      71,
      77,
      56,
      45,
      66,
      84,
      53,
      49,
      84,
      67,
      50,
      82,
      84,
      48
    ], // AGM8-BT51TC2RT0
    '22': [
      65,
      71,
      77,
      56,
      45,
      72,
      68,
      53,
      49,
      84,
      67,
      50,
      82,
      84,
      48
    ], // AGM8-HD51TC2RT0
    '23': [
      65,
      71,
      77,
      56,
      45,
      76,
      69,
      52,
      54,
      84,
      67,
      50,
      82,
      84,
      48
    ], // AGM8-LE46TC2RT0
  };

  // static const Map<String, String> filePathMap = {
  //   '1': 'assets/firmwares/SDLE_R145.bin', // SDLE
  //   '2': 'assets/firmwares/BLE_R145.bin', // MOTO BLE
  //   '3': 'assets/firmwares/MB_R145.bin', // MOTO MB
  //   '4': 'assets/firmwares/AOM_R135.bin', // C-Cor Node
  //   '5': 'assets/firmwares/TR_R143.bin', // C-Cor TR
  //   '6': 'assets/firmwares/BR_R143.bin', // C-Cor BR
  //   '7': 'assets/firmwares/LE_R145.bin', // C-Cor LE
  //   '8': 'assets/firmwares/SDAT_R145.bin', // SDAT
  //   '9': 'assets/firmwares/SDAM_R145.bin', // SDAM
  // };

  // static const Map<String, String> qFilePathMap = {
  //   '1': '', // SDLE
  //   '2': 'assets/firmwares/BLE_R145q.bin', // MOTO BLE
  //   '3': '', // MOTO MB
  //   '4': 'assets/firmwares/AOM_R141q.bin', // C-Cor Node
  //   '5': 'assets/firmwares/TR_R145q.bin', // C-Cor TR
  //   '6': 'assets/firmwares/BR_R145q.bin', // C-Cor BR
  //   '7': '', // C-Cor LE
  //   '8': '', // SDAT
  //   '9': '', // SDAM
  // };
}
