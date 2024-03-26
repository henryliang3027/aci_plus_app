import 'package:json_annotation/json_annotation.dart';

part 'dongle.g.dart';

@JsonSerializable()
class Dongle {
  const Dongle({
    this.alignChannel1 = 2,
    this.alignChannelMode1 = 1,
    this.alignChannel2 = 2,
    this.alignChannelMode2 = 1,
    this.sdleTGCCableLength = 9,
    this.sdleSplitOption = 1,
    this.sdlePilotFrequencyMode = 0,
    this.sdleAGCMode = 1,
    this.sdleALCMode = 1,
    this.sdleFirstChannelLoadingFrequency = 258,
    this.sdleLastChannelLoadingFrequency = 1794,
    this.sdleFirstChannelLoadingLevel = 340,
    this.sdleLastChannelLoadingLevel = 511,
    this.sdlePilotFrequency1 = 330,
    this.sdlePilotFrequency2 = 1785,
    this.sdleDSVVA1 = 0,
    this.sdleDSSlope1 = 60,
    this.sdleUSVCA2 = 40,
    this.sdleEREQ = 30,
    this.sdleUSVCA1 = 0,
    this.bleTGCCableLength = 9,
    this.bleSplitOption = 1,
    this.blePilotFrequencyMode = 0,
    this.bleAGCMode = 1,
    this.bleALCMode = 1,
    this.bleFirstChannelLoadingFrequency = 258,
    this.bleLastChannelLoadingFrequency = 1794,
    this.bleFirstChannelLoadingLevel = 340,
    this.bleLastChannelLoadingLevel = 511,
    this.blePilotFrequency1 = 330,
    this.blePilotFrequency2 = 1785,
    this.bleDSVVA1 = 0,
    this.bleDSSlope1 = 60,
    this.bleUSVCA2 = 40,
    this.bleEREQ = 30,
    this.bleUSVCA1 = 0,
    this.mbTGCCableLength = 9,
    this.mbSplitOption = 1,
    this.mbPilotFrequencyMode = 0,
    this.mbAGCMode = 1,
    this.mbALCMode = 1,
    this.mbFirstChannelLoadingFrequency = 258,
    this.mbLastChannelLoadingFrequency = 1794,
    this.mbFirstChannelLoadingLevel = 340,
    this.mbLastChannelLoadingLevel = 511,
    this.mbPilotFrequency1 = 330,
    this.mbPilotFrequency2 = 1785,
    this.mbDSVVA1 = 0,
    this.mbDSSlope1 = 0,
    this.mbUSVCA2 = 60,
    this.mbEREQ = 0,
    this.mbDSVVA4 = 15,
    this.mbUSVCA1 = 0,
    this.mbUSVCA3 = 0,
    this.mbUSVCA4 = 0,
    this.nodeSplitOption = 1,
    this.nodeDSVVA1 = 0,
    this.nodeDSInSlope1 = 0,
    this.nodeUSVCA1 = 0,
    this.nodeDSVVA3 = 0,
    this.nodeDSInSlope3 = 0,
    this.nodeUSVCA3 = 0,
    this.nodeDSVVA4 = 0,
    this.nodeDSInSlope4 = 0,
    this.nodeUSVCA4 = 0,
    this.nodeDSVVA6 = 0,
    this.nodeDSInSlope6 = 0,
    this.nodeUSVCA6 = 0,
    this.trTGCCableLength = 9,
    this.trSplitOption = 1,
    this.trPilotFrequencyMode = 0,
    this.trAGCMode = 1,
    this.trALCMode = 1,
    this.trFirstChannelLoadingFrequency = 258,
    this.trLastChannelLoadingFrequency = 1794,
    this.trFirstChannelLoadingLevel = 340,
    this.trLastChannelLoadingLevel = 511,
    this.trPilotFrequency1 = 330,
    this.trPilotFrequency2 = 1785,
    this.trDSVVA1 = 10,
    this.trDSSlope1 = 30,
    this.trUSVCA2 = 50,
    this.trEREQ = 40,
    this.trDSVVA4 = 15,
    this.trDSVVA5 = 0,
    this.trDSSlope3 = 0,
    this.trDSSlope4 = 0,
    this.trUSVCA1 = 0,
    this.trUSVCA3 = 0,
    this.trUSVCA4 = 0,
    this.brTGCCableLength = 9,
    this.brSplitOption = 1,
    this.brPilotFrequencyMode = 0,
    this.brAGCMode = 1,
    this.brALCMode = 1,
    this.brFirstChannelLoadingFrequency = 258,
    this.brLastChannelLoadingFrequency = 1794,
    this.brFirstChannelLoadingLevel = 340,
    this.brLastChannelLoadingLevel = 511,
    this.brPilotFrequency1 = 330,
    this.brPilotFrequency2 = 1785,
    this.brDSVVA1 = 10,
    this.brDSSlope1 = 30,
    this.brUSVCA2 = 50,
    this.brEREQ = 40,
    this.brDSVVA4 = 15,
    this.brDSSlope3 = 0,
    this.brUSVCA3 = 0,
    this.brUSVCA4 = 0,
    this.leTGCCableLength = 9,
    this.leSplitOption = 1,
    this.lePilotFrequencyMode = 0,
    this.leAGCMode = 1,
    this.leALCMode = 1,
    this.leFirstChannelLoadingFrequency = 258,
    this.leLastChannelLoadingFrequency = 1794,
    this.leFirstChannelLoadingLevel = 340,
    this.leLastChannelLoadingLevel = 511,
    this.lePilotFrequency1 = 330,
    this.lePilotFrequency2 = 1785,
    this.leDSVVA1 = 0,
    this.leDSSlope1 = 60,
    this.leUSVCA2 = 75,
    this.leEREQ = 0,
    this.leUSVCA1 = 0,
  });

  @JsonKey(name: 'd_0')
  final int alignChannel1;

  @JsonKey(name: 'd_1')
  final int alignChannelMode1;

  @JsonKey(name: 'd_2')
  final int alignChannel2;

  @JsonKey(name: 'd_3')
  final int alignChannelMode2;

  @JsonKey(name: '1_0')
  final int sdleTGCCableLength;

  @JsonKey(name: '1_1')
  final int sdleSplitOption;

  @JsonKey(name: '1_2')
  final int sdlePilotFrequencyMode;

  @JsonKey(name: '1_3')
  final int sdleAGCMode;

  @JsonKey(name: '1_4')
  final int sdleALCMode;

  @JsonKey(name: '1_5')
  final int sdleFirstChannelLoadingFrequency;

  @JsonKey(name: '1_6')
  final int sdleLastChannelLoadingFrequency;

  @JsonKey(name: '1_7')
  final int sdleFirstChannelLoadingLevel;

  @JsonKey(name: '1_8')
  final int sdleLastChannelLoadingLevel;

  @JsonKey(name: '1_9')
  final int sdlePilotFrequency1;

  @JsonKey(name: '1_10')
  final int sdlePilotFrequency2;

  @JsonKey(name: '1_11')
  final int sdleDSVVA1;

  @JsonKey(name: '1_12')
  final int sdleDSSlope1;

  @JsonKey(name: '1_13')
  final int sdleUSVCA2;

  @JsonKey(name: '1_14')
  final int sdleEREQ;

  @JsonKey(name: '1_15')
  final int sdleUSVCA1;

  @JsonKey(name: '2_0')
  final int bleTGCCableLength;

  @JsonKey(name: '2_1')
  final int bleSplitOption;

  @JsonKey(name: '2_2')
  final int blePilotFrequencyMode;

  @JsonKey(name: '2_3')
  final int bleAGCMode;

  @JsonKey(name: '2_4')
  final int bleALCMode;

  @JsonKey(name: '2_5')
  final int bleFirstChannelLoadingFrequency;

  @JsonKey(name: '2_6')
  final int bleLastChannelLoadingFrequency;

  @JsonKey(name: '2_7')
  final int bleFirstChannelLoadingLevel;

  @JsonKey(name: '2_8')
  final int bleLastChannelLoadingLevel;

  @JsonKey(name: '2_9')
  final int blePilotFrequency1;

  @JsonKey(name: '2_10')
  final int blePilotFrequency2;

  @JsonKey(name: '2_11')
  final int bleDSVVA1;

  @JsonKey(name: '2_12')
  final int bleDSSlope1;

  @JsonKey(name: '2_13')
  final int bleUSVCA2;

  @JsonKey(name: '2_14')
  final int bleEREQ;

  @JsonKey(name: '2_15')
  final int bleUSVCA1;

  @JsonKey(name: '3_0')
  final int mbTGCCableLength;

  @JsonKey(name: '3_1')
  final int mbSplitOption;

  @JsonKey(name: '3_2')
  final int mbPilotFrequencyMode;

  @JsonKey(name: '3_3')
  final int mbAGCMode;

  @JsonKey(name: '3_4')
  final int mbALCMode;

  @JsonKey(name: '3_5')
  final int mbFirstChannelLoadingFrequency;

  @JsonKey(name: '3_6')
  final int mbLastChannelLoadingFrequency;

  @JsonKey(name: '3_7')
  final int mbFirstChannelLoadingLevel;

  @JsonKey(name: '3_8')
  final int mbLastChannelLoadingLevel;

  @JsonKey(name: '3_9')
  final int mbPilotFrequency1;

  @JsonKey(name: '3_10')
  final int mbPilotFrequency2;

  @JsonKey(name: '3_11')
  final int mbDSVVA1;

  @JsonKey(name: '3_12')
  final int mbDSSlope1;

  @JsonKey(name: '3_13')
  final int mbUSVCA2;

  @JsonKey(name: '3_14')
  final int mbEREQ;

  @JsonKey(name: '3_15')
  final int mbDSVVA4;

  @JsonKey(name: '3_16')
  final int mbUSVCA1;

  @JsonKey(name: '3_17')
  final int mbUSVCA3;

  @JsonKey(name: '3_18')
  final int mbUSVCA4;

  @JsonKey(name: '4_0')
  final int nodeSplitOption;

  @JsonKey(name: '4_1')
  final int nodeDSVVA1;

  @JsonKey(name: '4_2')
  final int nodeDSInSlope1;

  @JsonKey(name: '4_3')
  final int nodeUSVCA1;

  @JsonKey(name: '4_4')
  final int nodeDSVVA3;

  @JsonKey(name: '4_5')
  final int nodeDSInSlope3;

  @JsonKey(name: '4_6')
  final int nodeUSVCA3;

  @JsonKey(name: '4_7')
  final int nodeDSVVA4;

  @JsonKey(name: '4_8')
  final int nodeDSInSlope4;

  @JsonKey(name: '4_9')
  final int nodeUSVCA4;

  @JsonKey(name: '4_10')
  final int nodeDSVVA6;

  @JsonKey(name: '4_11')
  final int nodeDSInSlope6;

  @JsonKey(name: '4_12')
  final int nodeUSVCA6;

  @JsonKey(name: '5_0')
  final int trTGCCableLength;

  @JsonKey(name: '5_1')
  final int trSplitOption;

  @JsonKey(name: '5_2')
  final int trPilotFrequencyMode;

  @JsonKey(name: '5_3')
  final int trAGCMode;

  @JsonKey(name: '5_4')
  final int trALCMode;

  @JsonKey(name: '5_5')
  final int trFirstChannelLoadingFrequency;

  @JsonKey(name: '5_6')
  final int trLastChannelLoadingFrequency;

  @JsonKey(name: '5_7')
  final int trFirstChannelLoadingLevel;

  @JsonKey(name: '5_8')
  final int trLastChannelLoadingLevel;

  @JsonKey(name: '5_9')
  final int trPilotFrequency1;

  @JsonKey(name: '5_10')
  final int trPilotFrequency2;

  @JsonKey(name: '5_11')
  final int trDSVVA1;

  @JsonKey(name: '5_12')
  final int trDSSlope1;

  @JsonKey(name: '5_13')
  final int trUSVCA2;

  @JsonKey(name: '5_14')
  final int trEREQ;

  @JsonKey(name: '5_15')
  final int trDSVVA4;

  @JsonKey(name: '5_16')
  final int trDSVVA5;

  @JsonKey(name: '5_17')
  final int trDSSlope3;

  @JsonKey(name: '5_18')
  final int trDSSlope4;

  @JsonKey(name: '5_19')
  final int trUSVCA1;

  @JsonKey(name: '5_20')
  final int trUSVCA3;

  @JsonKey(name: '5_21')
  final int trUSVCA4;

  @JsonKey(name: '6_0')
  final int brTGCCableLength;

  @JsonKey(name: '6_1')
  final int brSplitOption;

  @JsonKey(name: '6_2')
  final int brPilotFrequencyMode;

  @JsonKey(name: '6_3')
  final int brAGCMode;

  @JsonKey(name: '6_4')
  final int brALCMode;

  @JsonKey(name: '6_5')
  final int brFirstChannelLoadingFrequency;

  @JsonKey(name: '6_6')
  final int brLastChannelLoadingFrequency;

  @JsonKey(name: '6_7')
  final int brFirstChannelLoadingLevel;

  @JsonKey(name: '6_8')
  final int brLastChannelLoadingLevel;

  @JsonKey(name: '6_9')
  final int brPilotFrequency1;

  @JsonKey(name: '6_10')
  final int brPilotFrequency2;

  @JsonKey(name: '6_11')
  final int brDSVVA1;

  @JsonKey(name: '6_12')
  final int brDSSlope1;

  @JsonKey(name: '6_13')
  final int brUSVCA2;

  @JsonKey(name: '6_14')
  final int brEREQ;

  @JsonKey(name: '6_15')
  final int brDSVVA4;

  @JsonKey(name: '6_16')
  final int brDSSlope3;

  @JsonKey(name: '6_17')
  final int brUSVCA3;

  @JsonKey(name: '6_18')
  final int brUSVCA4;

  @JsonKey(name: '7_0')
  final int leTGCCableLength;

  @JsonKey(name: '7_1')
  final int leSplitOption;

  @JsonKey(name: '7_2')
  final int lePilotFrequencyMode;

  @JsonKey(name: '7_3')
  final int leAGCMode;

  @JsonKey(name: '7_4')
  final int leALCMode;

  @JsonKey(name: '7_5')
  final int leFirstChannelLoadingFrequency;

  @JsonKey(name: '7_6')
  final int leLastChannelLoadingFrequency;

  @JsonKey(name: '7_7')
  final int leFirstChannelLoadingLevel;

  @JsonKey(name: '7_8')
  final int leLastChannelLoadingLevel;

  @JsonKey(name: '7_9')
  final int lePilotFrequency1;

  @JsonKey(name: '7_10')
  final int lePilotFrequency2;

  @JsonKey(name: '7_11')
  final int leDSVVA1;

  @JsonKey(name: '7_12')
  final int leDSSlope1;

  @JsonKey(name: '7_13')
  final int leUSVCA2;

  @JsonKey(name: '7_14')
  final int leEREQ;

  @JsonKey(name: '7_15')
  final int leUSVCA1;

  factory Dongle.fromJson(Map<String, dynamic> json) => _$DongleFromJson(json);

  Map<String, dynamic> toJson() => _$DongleToJson(this);
}
