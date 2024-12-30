// event 紀錄中 EQ, DFU 各個代號代表的意思

class Event1p8GValue {
  static Map<int, String> equalizerValueMap = {
    0: 'DNI',
    1: 'CEQ',
    112: 'ACEQ(1.2G)',
    118: 'ACEQ(1.8G)',
    120: 'EQ(1.2G)',
    180: 'EQ(1.8G)'
  };

  static Map<int, String> splitOptionValueMap = {
    0: 'DNI',
    1: '204/258',
    2: '300/372',
    3: '396/492',
    4: '492/606',
    5: '684/834'
  };
}
