import 'package:aci_plus_app/core/control_item_minmax.dart';
import 'package:aci_plus_app/core/data_key.dart';

class ControlItemValue {
  static Map<String, Map<String, Map<String, Map<DataKey, MinMax>>>>
      allValueCollections = {
    '1.8': valueCollection,
    '1.2': valueCollection1P2G,
  };

  static Map<String, Map<String, Map<DataKey, MinMax>>> valueCollection = {
    '0': {
      // no DFU
      '0': Item1P8G.mftj1_0,
      '1': Item1P8G.sdle1_1,
      '2': Item1P8G.ble1_2,
      '3': Item1P8G.mb1_3,
      '4': Item1P8G.ccorNode1_4,
      '5': Item1P8G.tr1_5,
      '6': Item1P8G.br1_6,
      '7': Item1P8G.le1_7,
      '8': Item1P8G.sdat1_8,
      '9': Item1P8G.sdam1_9,
      '10': Item1P8G.mft8_1_10,
      '11': Item1P8G.sdleOnBoard1_11,
      '12': Item1P8G.bleOnBoard1_12,
      '13': Item1P8G.mbOnBoard1_13,
      '15': Item1P8G.trOnBoard1_15,
      '16': Item1P8G.brOnBoard1_16,
      '17': Item1P8G.leOnBoard1_17,
      '18': Item1P8G.sdatOnBoard1_18,
      '19': Item1P8G.sdamOnBoard1_19,
    },
    '1': {
      //204/258
      '0': Item1P8G.mftj1_0,
      '1': Item1P8G.sdle1_1,
      '2': Item1P8G.ble1_2,
      '3': Item1P8G.mb1_3,
      '4': Item1P8G.ccorNode1_4,
      '5': Item1P8G.tr1_5,
      '6': Item1P8G.br1_6,
      '7': Item1P8G.le1_7,
      '8': Item1P8G.sdat1_8,
      '9': Item1P8G.sdam1_9,
      '10': Item1P8G.mft8_1_10,
      '11': Item1P8G.sdleOnBoard1_11,
      '12': Item1P8G.bleOnBoard1_12,
      '13': Item1P8G.mbOnBoard1_13,
      '15': Item1P8G.trOnBoard1_15,
      '16': Item1P8G.brOnBoard1_16,
      '17': Item1P8G.leOnBoard1_17,
      '18': Item1P8G.sdatOnBoard1_18,
      '19': Item1P8G.sdamOnBoard1_19,
    },
    '2': {
      // 300/372
      '0': Item1P8G.mftj2_0,
      '1': Item1P8G.sdle2_1,
      '2': Item1P8G.ble2_2,
      '3': Item1P8G.mb2_3,
      '4': Item1P8G.ccorNode2_4,
      '5': Item1P8G.tr2_5,
      '6': Item1P8G.br2_6,
      '7': Item1P8G.le2_7,
      '8': Item1P8G.sdat2_8,
      '9': Item1P8G.sdam2_9,
      '10': Item1P8G.mft8_2_10,
      '11': Item1P8G.sdleOnBoard2_11,
      '12': Item1P8G.bleOnBoard2_12,
      '13': Item1P8G.mbOnBoard2_13,
      '15': Item1P8G.trOnBoard2_15,
      '16': Item1P8G.brOnBoard2_16,
      '17': Item1P8G.leOnBoard2_17,
      '18': Item1P8G.sdatOnBoard2_18,
      '19': Item1P8G.sdamOnBoard2_19,
    },
    '3': {
      // 396/492
      '0': Item1P8G.mftj3_0,
      '1': Item1P8G.sdle3_1,
      '2': Item1P8G.ble3_2,
      '3': Item1P8G.mb3_3,
      '4': Item1P8G.ccorNode3_4,
      '5': Item1P8G.tr3_5,
      '6': Item1P8G.br3_6,
      '7': Item1P8G.le3_7,
      '8': Item1P8G.sdat3_8,
      '9': Item1P8G.sdam3_9,
      '10': Item1P8G.mft8_3_10,
      '11': Item1P8G.sdleOnBoard3_11,
      '12': Item1P8G.bleOnBoard3_12,
      '13': Item1P8G.mbOnBoard3_13,
      '15': Item1P8G.trOnBoard3_15,
      '16': Item1P8G.brOnBoard3_16,
      '17': Item1P8G.leOnBoard3_17,
      '18': Item1P8G.sdatOnBoard3_18,
      '19': Item1P8G.sdamOnBoard3_19,
    },
    '4': {
      // 492/606
      '0': Item1P8G.mftj4_0,
      '1': Item1P8G.sdle4_1,
      '2': Item1P8G.ble4_2,
      '3': Item1P8G.mb4_3,
      '4': Item1P8G.ccorNode4_4,
      '5': Item1P8G.tr4_5,
      '6': Item1P8G.br4_6,
      '7': Item1P8G.le4_7,
      '8': Item1P8G.sdat4_8,
      '9': Item1P8G.sdam4_9,
      '10': Item1P8G.mft8_4_10,
      '11': Item1P8G.sdleOnBoard4_11,
      '12': Item1P8G.bleOnBoard4_12,
      '13': Item1P8G.mbOnBoard4_13,
      '15': Item1P8G.trOnBoard4_15,
      '16': Item1P8G.brOnBoard4_16,
      '17': Item1P8G.leOnBoard4_17,
      '18': Item1P8G.sdatOnBoard4_18,
      '19': Item1P8G.sdamOnBoard4_19,
    },
    '5': {
      // 684/834
      '0': Item1P8G.mftj5_0,
      '1': Item1P8G.sdle5_1,
      '2': Item1P8G.ble5_2,
      '3': Item1P8G.mb5_3,
      '4': Item1P8G.ccorNode5_4,
      '5': Item1P8G.tr5_5,
      '6': Item1P8G.br5_6,
      '7': Item1P8G.le5_7,
      '8': Item1P8G.sdat5_8,
      '9': Item1P8G.sdam5_9,
      '10': Item1P8G.mft8_5_10,
      '11': Item1P8G.sdleOnBoard5_11,
      '12': Item1P8G.bleOnBoard5_12,
      '13': Item1P8G.mbOnBoard5_13,
      '15': Item1P8G.trOnBoard5_15,
      '16': Item1P8G.brOnBoard5_16,
      '17': Item1P8G.leOnBoard5_17,
      '18': Item1P8G.sdatOnBoard5_18,
      '19': Item1P8G.sdamOnBoard5_19,
    },
    '6': {
      // 85/105
      '0': Item1P8G.mftj6_0,
      '1': Item1P8G.sdle6_1,
      '2': Item1P8G.ble6_2,
      '3': Item1P8G.mb6_3,
      '4': Item1P8G.ccorNode6_4,
      '5': Item1P8G.tr6_5,
      '6': Item1P8G.br6_6,
      '7': Item1P8G.le6_7,
      '8': Item1P8G.sdat6_8,
      '9': Item1P8G.sdam6_9,
      '10': Item1P8G.mft8_6_10,
      '11': Item1P8G.sdleOnBoard6_11,
      '12': Item1P8G.bleOnBoard6_12,
      '13': Item1P8G.mbOnBoard6_13,
      '15': Item1P8G.trOnBoard6_15,
      '16': Item1P8G.brOnBoard6_16,
      '17': Item1P8G.leOnBoard6_17,
      '18': Item1P8G.sdatOnBoard6_18,
      '19': Item1P8G.sdamOnBoard6_19,
    },
  };

  static Map<String, Map<String, Map<DataKey, MinMax>>> valueCollection1P2G = {
    '0': {
      // no DFU
      '0': Item1P2G.mftj1_0,
      '1': Item1P2G.sdle1_1,
      '2': Item1P2G.ble1_2,
      '3': Item1P2G.mb1_3,
      '4': Item1P2G.ccorNode1_4,
      '5': Item1P2G.tr1_5,
      '6': Item1P2G.br1_6,
      '7': Item1P2G.le1_7,
      '8': Item1P2G.sdat1_8,
      '9': Item1P2G.sdam1_9,
      '10': Item1P2G.mft8_1_10,
      '11': Item1P2G.sdleOnBoard1_11,
      '12': Item1P2G.bleOnBoard1_12,
      '13': Item1P2G.mbOnBoard1_13,
      '15': Item1P2G.trOnBoard1_15,
      '16': Item1P2G.brOnBoard1_16,
      '17': Item1P2G.leOnBoard1_17,
      '18': Item1P2G.sdatOnBoard1_18,
      '19': Item1P2G.sdamOnBoard1_19,
    },
    '1': {
      // 204/258
      '0': Item1P2G.mftj1_0,
      '1': Item1P2G.sdle1_1,
      '2': Item1P2G.ble1_2,
      '3': Item1P2G.mb1_3,
      '4': Item1P2G.ccorNode1_4,
      '5': Item1P2G.tr1_5,
      '6': Item1P2G.br1_6,
      '7': Item1P2G.le1_7,
      '8': Item1P2G.sdat1_8,
      '9': Item1P2G.sdam1_9,
      '10': Item1P2G.mft8_1_10,
      '11': Item1P2G.sdleOnBoard1_11,
      '12': Item1P2G.bleOnBoard1_12,
      '13': Item1P2G.mbOnBoard1_13,
      '15': Item1P2G.trOnBoard1_15,
      '16': Item1P2G.brOnBoard1_16,
      '17': Item1P2G.leOnBoard1_17,
      '18': Item1P2G.sdatOnBoard1_18,
      '19': Item1P2G.sdamOnBoard1_19,
    },
    '2': {
      // 300/372
      '0': Item1P2G.mftj2_0,
      '1': Item1P2G.sdle2_1,
      '2': Item1P2G.ble2_2,
      '3': Item1P2G.mb2_3,
      '4': Item1P2G.ccorNode2_4,
      '5': Item1P2G.tr2_5,
      '6': Item1P2G.br2_6,
      '7': Item1P2G.le2_7,
      '8': Item1P2G.sdat2_8,
      '9': Item1P2G.sdam2_9,
      '10': Item1P2G.mft8_2_10,
      '11': Item1P2G.sdleOnBoard2_11,
      '12': Item1P2G.bleOnBoard2_12,
      '13': Item1P2G.mbOnBoard2_13,
      '15': Item1P2G.trOnBoard2_15,
      '16': Item1P2G.brOnBoard2_16,
      '17': Item1P2G.leOnBoard2_17,
      '18': Item1P2G.sdatOnBoard2_18,
      '19': Item1P2G.sdamOnBoard2_19,
    },
    '3': {
      // 396/492
      '0': Item1P2G.mftj3_0,
      '1': Item1P2G.sdle3_1,
      '2': Item1P2G.ble3_2,
      '3': Item1P2G.mb3_3,
      '4': Item1P2G.ccorNode3_4,
      '5': Item1P2G.tr3_5,
      '6': Item1P2G.br3_6,
      '7': Item1P2G.le3_7,
      '8': Item1P2G.sdat3_8,
      '9': Item1P2G.sdam3_9,
      '10': Item1P2G.mft8_3_10,
      '11': Item1P2G.sdleOnBoard3_11,
      '12': Item1P2G.bleOnBoard3_12,
      '13': Item1P2G.mbOnBoard3_13,
      '15': Item1P2G.trOnBoard3_15,
      '16': Item1P2G.brOnBoard3_16,
      '17': Item1P2G.leOnBoard3_17,
      '18': Item1P2G.sdatOnBoard3_18,
      '19': Item1P2G.sdamOnBoard3_19,
    },
    '4': {
      // 492/606
      '0': Item1P2G.mftj4_0,
      '1': Item1P2G.sdle4_1,
      '2': Item1P2G.ble4_2,
      '3': Item1P2G.mb4_3,
      '4': Item1P2G.ccorNode4_4,
      '5': Item1P2G.tr4_5,
      '6': Item1P2G.br4_6,
      '7': Item1P2G.le4_7,
      '8': Item1P2G.sdat4_8,
      '9': Item1P2G.sdam4_9,
      '10': Item1P2G.mft8_4_10,
      '11': Item1P2G.sdleOnBoard4_11,
      '12': Item1P2G.bleOnBoard4_12,
      '13': Item1P2G.mbOnBoard4_13,
      '15': Item1P2G.trOnBoard4_15,
      '16': Item1P2G.brOnBoard4_16,
      '17': Item1P2G.leOnBoard4_17,
      '18': Item1P2G.sdatOnBoard4_18,
      '19': Item1P2G.sdamOnBoard4_19,
    },
    '5': {
      // 684/834
      '0': Item1P2G.mftj5_0,
      '1': Item1P2G.sdle5_1,
      '2': Item1P2G.ble5_2,
      '3': Item1P2G.mb5_3,
      '4': Item1P2G.ccorNode5_4,
      '5': Item1P2G.tr5_5,
      '6': Item1P2G.br5_6,
      '7': Item1P2G.le5_7,
      '8': Item1P2G.sdat5_8,
      '9': Item1P2G.sdam5_9,
      '10': Item1P2G.mft8_5_10,
      '11': Item1P2G.sdleOnBoard5_11,
      '12': Item1P2G.bleOnBoard5_12,
      '13': Item1P2G.mbOnBoard5_13,
      '15': Item1P2G.trOnBoard5_15,
      '16': Item1P2G.brOnBoard5_16,
      '17': Item1P2G.leOnBoard5_17,
      '18': Item1P2G.sdatOnBoard5_18,
      '19': Item1P2G.sdamOnBoard5_19,
    },
    '6': {
      // 85/105
      '0': Item1P2G.mftj6_0,
      '1': Item1P2G.sdle6_1,
      '2': Item1P2G.ble6_2,
      '3': Item1P2G.mb6_3,
      '4': Item1P2G.ccorNode6_4,
      '5': Item1P2G.tr6_5,
      '6': Item1P2G.br6_6,
      '7': Item1P2G.le6_7,
      '8': Item1P2G.sdat6_8,
      '9': Item1P2G.sdam6_9,
      '10': Item1P2G.mft8_6_10,
      '11': Item1P2G.sdleOnBoard6_11,
      '12': Item1P2G.bleOnBoard6_12,
      '13': Item1P2G.mbOnBoard6_13,
      '15': Item1P2G.trOnBoard6_15,
      '16': Item1P2G.brOnBoard6_16,
      '17': Item1P2G.leOnBoard6_17,
      '18': Item1P2G.sdatOnBoard6_18,
      '19': Item1P2G.sdamOnBoard6_19,
    },
  };
}

class MinMax {
  const MinMax({
    required this.min,
    required this.max,
  });

  final double min;
  final double max;
}
