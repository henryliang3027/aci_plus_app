class WorkingModeTable {
  static const Map<String, String> workingModeMap = {
    '12': 'Bandwidth Pilot (1ch & Last ch), AGC ON (Unlocked)',
    '13': 'Bandwidth Pilot (1ch & Last ch), AGC ON (Locked)',
    '14': 'Bandwidth Pilot (1ch & Last ch), Loss Pilot(In TGC)',
    '22': 'User Setting Pilot, In AGC (Unlocked)',
    '23': 'User Setting Pilot, In AGC (In Lock)',
    '24': 'User Setting Pilot, Loss Pilot(In TGC)',
    '71': 'TGC + Log Input PAD',
    '72': 'TGC + Manual Input PAD',
    '81': 'Bench Test for Network Analyzer',
    '82': 'TGC + VVA1 and Slope1 in LOG',
    '83': 'TGC + Manual VVA1 and Slope1',
  };
}
