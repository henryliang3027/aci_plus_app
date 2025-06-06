import 'package:aci_plus_app/core/control_item_value.dart';
import 'package:aci_plus_app/core/data_key.dart';

class Item1P8G {
// 命名規則 機種名稱+DFU編號+_partId
// DFU = 1 204/258
  static Map<DataKey, MinMax> mftj1_0 = {};

  static Map<DataKey, MinMax> sdle1_1 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ble1_2 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mb1_3 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ccorNode1_4 = {
    // C-Cor Node
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA6: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsOutSlope1: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope3: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope4: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope6: const MinMax(min: 0.0, max: 8.0),
    DataKey.biasCurrent1: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent3: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent4: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent6: const MinMax(min: 320, max: 520),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA6: const MinMax(min: 0.0, max: 25.0),
  };

  static Map<DataKey, MinMax> tr1_5 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> br1_6 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> le1_7 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdat1_8 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdam1_9 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mft8_1_10 = {
    // MFT8
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdleOnBoard1_11 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> bleOnBoard1_12 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mbOnBoard1_13 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> trOnBoard1_15 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> brOnBoard1_16 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> leOnBoard1_17 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdatOnBoard1_18 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdamOnBoard1_19 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

// DFU = 2 300/372
  static Map<DataKey, MinMax> mftj2_0 = {};

  static Map<DataKey, MinMax> sdle2_1 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ble2_2 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mb2_3 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> ccorNode2_4 = {
    // C-Cor Node
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA6: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsOutSlope1: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope3: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope4: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope6: const MinMax(min: 0.0, max: 8.0),
    DataKey.biasCurrent1: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent3: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent4: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent6: const MinMax(min: 320, max: 520),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA6: const MinMax(min: 0.0, max: 25.0),
    // DataKey.ingressSetting1,

    // DataKey.ingressSetting6,
  };

  static Map<DataKey, MinMax> tr2_5 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> br2_6 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> le2_7 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdat2_8 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdam2_9 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mft8_2_10 = {
    // MFT8
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdleOnBoard2_11 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> bleOnBoard2_12 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mbOnBoard2_13 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> trOnBoard2_15 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> brOnBoard2_16 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> leOnBoard2_17 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdatOnBoard2_18 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdamOnBoard2_19 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

// DFU = 3 396/492
  static Map<DataKey, MinMax> mftj3_0 = {};

  static Map<DataKey, MinMax> sdle3_1 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ble3_2 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mb3_3 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> ccorNode3_4 = {
    // C-Cor Node
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA6: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsOutSlope1: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope3: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope4: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope6: const MinMax(min: 0.0, max: 8.0),
    DataKey.biasCurrent1: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent3: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent4: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent6: const MinMax(min: 320, max: 520),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA6: const MinMax(min: 0.0, max: 25.0),
    // DataKey.ingressSetting1,

    // DataKey.ingressSetting6,
  };

  static Map<DataKey, MinMax> tr3_5 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> br3_6 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> le3_7 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdat3_8 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdam3_9 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mft8_3_10 = {
    // MFT8
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdleOnBoard3_11 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> bleOnBoard3_12 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mbOnBoard3_13 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> trOnBoard3_15 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> brOnBoard3_16 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> leOnBoard3_17 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdatOnBoard3_18 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdamOnBoard3_19 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

// DFU = 4 492/606
  static Map<DataKey, MinMax> mftj4_0 = {};

  static Map<DataKey, MinMax> sdle4_1 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ble4_2 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mb4_3 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> ccorNode4_4 = {
    // C-Cor Node
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA6: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsOutSlope1: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope3: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope4: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope6: const MinMax(min: 0.0, max: 8.0),
    DataKey.biasCurrent1: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent3: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent4: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent6: const MinMax(min: 320, max: 520),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA6: const MinMax(min: 0.0, max: 25.0),
    // DataKey.ingressSetting1,

    // DataKey.ingressSetting6,
  };

  static Map<DataKey, MinMax> tr4_5 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> br4_6 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> le4_7 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdat4_8 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdam4_9 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mft8_4_10 = {
    // MFT8
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdleOnBoard4_11 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> bleOnBoard4_12 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mbOnBoard4_13 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> trOnBoard4_15 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> brOnBoard4_16 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> leOnBoard4_17 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdatOnBoard4_18 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdamOnBoard4_19 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

// DFU = 5 684/834
  static Map<DataKey, MinMax> mftj5_0 = {};

  static Map<DataKey, MinMax> sdle5_1 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ble5_2 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mb5_3 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> ccorNode5_4 = {
    // C-Cor Node
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA6: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsOutSlope1: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope3: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope4: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope6: const MinMax(min: 0.0, max: 8.0),
    DataKey.biasCurrent1: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent3: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent4: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent6: const MinMax(min: 320, max: 520),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA6: const MinMax(min: 0.0, max: 25.0),
    // DataKey.ingressSetting1,

    // DataKey.ingressSetting6,
  };

  static Map<DataKey, MinMax> tr5_5 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> br5_6 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> le5_7 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdat5_8 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdam5_9 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mft8_5_10 = {
    // MFT8
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdleOnBoard5_11 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> bleOnBoard5_12 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mbOnBoard5_13 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> trOnBoard5_15 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> brOnBoard5_16 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> leOnBoard5_17 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdatOnBoard5_18 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdamOnBoard5_19 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

// DFU = 6 85/105
  static Map<DataKey, MinMax> mftj6_0 = {};

  static Map<DataKey, MinMax> sdle6_1 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ble6_2 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mb6_3 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> ccorNode6_4 = {
    // C-Cor Node
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA6: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsOutSlope1: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope3: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope4: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope6: const MinMax(min: 0.0, max: 8.0),
    DataKey.biasCurrent1: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent3: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent4: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent6: const MinMax(min: 320, max: 520),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA6: const MinMax(min: 0.0, max: 25.0),
    // DataKey.ingressSetting1,

    // DataKey.ingressSetting6,
  };

  static Map<DataKey, MinMax> tr6_5 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> br6_6 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> le6_7 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdat6_8 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdam6_9 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mft8_6_10 = {
    // MFT8
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdleOnBoard6_11 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> bleOnBoard6_12 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mbOnBoard6_13 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> trOnBoard6_15 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> brOnBoard6_16 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> leOnBoard6_17 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdatOnBoard6_18 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdamOnBoard6_19 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 13.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };
}

class Item1P2G {
// 命名規則 機種名稱+DFU編號+_partId
// DFU = 1 204/258
  static Map<DataKey, MinMax> mftj1_0 = {};

  static Map<DataKey, MinMax> sdle1_1 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ble1_2 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mb1_3 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ccorNode1_4 = {
    // C-Cor Node
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA6: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsOutSlope1: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope3: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope4: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope6: const MinMax(min: 0.0, max: 8.0),
    DataKey.biasCurrent1: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent3: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent4: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent6: const MinMax(min: 320, max: 520),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA6: const MinMax(min: 0.0, max: 25.0),
  };

  static Map<DataKey, MinMax> tr1_5 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> br1_6 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> le1_7 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdat1_8 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdam1_9 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mft8_1_10 = {
    // MFT8
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdleOnBoard1_11 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> bleOnBoard1_12 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mbOnBoard1_13 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> trOnBoard1_15 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> brOnBoard1_16 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> leOnBoard1_17 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdatOnBoard1_18 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdamOnBoard1_19 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

// DFU = 2 300/372
  static Map<DataKey, MinMax> mftj2_0 = {};

  static Map<DataKey, MinMax> sdle2_1 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ble2_2 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mb2_3 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> ccorNode2_4 = {
    // C-Cor Node
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA6: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsOutSlope1: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope3: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope4: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope6: const MinMax(min: 0.0, max: 8.0),
    DataKey.biasCurrent1: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent3: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent4: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent6: const MinMax(min: 320, max: 520),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA6: const MinMax(min: 0.0, max: 25.0),
    // DataKey.ingressSetting1,

    // DataKey.ingressSetting6,
  };

  static Map<DataKey, MinMax> tr2_5 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> br2_6 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> le2_7 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdat2_8 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdam2_9 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mft8_2_10 = {
    // MFT8
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdleOnBoard2_11 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> bleOnBoard2_12 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mbOnBoard2_13 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> trOnBoard2_15 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> brOnBoard2_16 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> leOnBoard2_17 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdatOnBoard2_18 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdamOnBoard2_19 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

// DFU = 3 396/492
  static Map<DataKey, MinMax> mftj3_0 = {};

  static Map<DataKey, MinMax> sdle3_1 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ble3_2 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mb3_3 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> ccorNode3_4 = {
    // C-Cor Node
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA6: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsOutSlope1: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope3: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope4: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope6: const MinMax(min: 0.0, max: 8.0),
    DataKey.biasCurrent1: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent3: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent4: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent6: const MinMax(min: 320, max: 520),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA6: const MinMax(min: 0.0, max: 25.0),
    // DataKey.ingressSetting1,

    // DataKey.ingressSetting6,
  };

  static Map<DataKey, MinMax> tr3_5 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> br3_6 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> le3_7 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdat3_8 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdam3_9 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mft8_3_10 = {
    // MFT8
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdleOnBoard3_11 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> bleOnBoard3_12 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mbOnBoard3_13 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> trOnBoard3_15 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> brOnBoard3_16 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> leOnBoard3_17 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdatOnBoard3_18 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdamOnBoard3_19 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

// DFU = 4 492/606
  static Map<DataKey, MinMax> mftj4_0 = {};

  static Map<DataKey, MinMax> sdle4_1 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ble4_2 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mb4_3 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> ccorNode4_4 = {
    // C-Cor Node
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA6: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsOutSlope1: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope3: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope4: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope6: const MinMax(min: 0.0, max: 8.0),
    DataKey.biasCurrent1: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent3: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent4: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent6: const MinMax(min: 320, max: 520),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA6: const MinMax(min: 0.0, max: 25.0),
    // DataKey.ingressSetting1,

    // DataKey.ingressSetting6,
  };

  static Map<DataKey, MinMax> tr4_5 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> br4_6 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> le4_7 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdat4_8 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdam4_9 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mft8_4_10 = {
    // MFT8
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdleOnBoard4_11 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> bleOnBoard4_12 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mbOnBoard4_13 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> trOnBoard4_15 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> brOnBoard4_16 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> leOnBoard4_17 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdatOnBoard4_18 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdamOnBoard4_19 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

// DFU = 5 684/834
  static Map<DataKey, MinMax> mftj5_0 = {};

  static Map<DataKey, MinMax> sdle5_1 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ble5_2 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mb5_3 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> ccorNode5_4 = {
    // C-Cor Node
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA6: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsOutSlope1: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope3: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope4: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope6: const MinMax(min: 0.0, max: 8.0),
    DataKey.biasCurrent1: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent3: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent4: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent6: const MinMax(min: 320, max: 520),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA6: const MinMax(min: 0.0, max: 25.0),
    // DataKey.ingressSetting1,

    // DataKey.ingressSetting6,
  };

  static Map<DataKey, MinMax> tr5_5 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> br5_6 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> le5_7 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdat5_8 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdam5_9 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mft8_5_10 = {
    // MFT8
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdleOnBoard5_11 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> bleOnBoard5_12 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mbOnBoard5_13 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> trOnBoard5_15 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> brOnBoard5_16 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> leOnBoard5_17 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdatOnBoard5_18 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdamOnBoard5_19 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

// DFU = 6 85/105
  static Map<DataKey, MinMax> mftj6_0 = {};

  static Map<DataKey, MinMax> sdle6_1 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> ble6_2 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mb6_3 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> ccorNode6_4 = {
    // C-Cor Node
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsVVA6: const MinMax(min: 0.0, max: 25.0),
    DataKey.dsOutSlope1: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope3: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope4: const MinMax(min: 0.0, max: 8.0),
    DataKey.dsOutSlope6: const MinMax(min: 0.0, max: 8.0),
    DataKey.biasCurrent1: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent3: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent4: const MinMax(min: 320, max: 520),
    DataKey.biasCurrent6: const MinMax(min: 320, max: 520),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 25.0),
    DataKey.usVCA6: const MinMax(min: 0.0, max: 25.0),
    // DataKey.ingressSetting1,

    // DataKey.ingressSetting6,
  };

  static Map<DataKey, MinMax> tr6_5 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> br6_6 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> le6_7 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdat6_8 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdam6_9 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mft8_6_10 = {
    // MFT8
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdleOnBoard6_11 = {
    // SDLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> bleOnBoard6_12 = {
    // Moto BLE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> mbOnBoard6_13 = {
    // Moto MB
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
    //  DataKey.ingressSetting2,
    //  DataKey.ingressSetting3,
    //  DataKey.ingressSetting4,
  };

  static Map<DataKey, MinMax> trOnBoard6_15 = {
    // C-Cor TR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> brOnBoard6_16 = {
    // C-Cor BR
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> leOnBoard6_17 = {
    // C-Cor LE
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdatOnBoard6_18 = {
    // SDAT
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA5: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope3: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsSlope4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };

  static Map<DataKey, MinMax> sdamOnBoard6_19 = {
    // SDAM
    DataKey.dsVVA1: const MinMax(min: 0.0, max: 20.0),
    DataKey.dsSlope1: const MinMax(min: 0.0, max: 10.0),
    DataKey.dsVVA4: const MinMax(min: 0.0, max: 10.0),
    DataKey.usVCA2: const MinMax(min: 0.0, max: 15.0),
    DataKey.eREQ: const MinMax(min: 0.0, max: 15.0),
    DataKey.usVCA1: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA3: const MinMax(min: 0.0, max: 29.0),
    DataKey.usVCA4: const MinMax(min: 0.0, max: 29.0),
  };
}
