class WorkingModeTable {
  static const Map<String, String> workingModeMap = {
    '12': 'Auto Pilot (1ch & Last ch), AGC ON (Unlocked)',
    '13': 'Auto Pilot (1ch & Last ch), AGC ON (Locked)',
    '14': 'Auto Pilot (1ch & Last ch), Loss Pilot(In TGC)',
    '22': 'Manual Pilot, In AGC (Unlocked)',
    '23': 'Manual Pilot, In AGC (In Lock)',
    '24': 'Manual Pilot, Loss Pilot(In TGC)',
    '71': 'TGC + Log Input PAD',
    '72': 'TGC + Manual Input PAD',
    '81': 'Test - Manual All the DS Control',
    '82': 'Testing - TGC + VVA1 and Slope1 in LOG',
    '83': 'Testing - TGC + Manual VVA1 and Slope1',
  };
}
