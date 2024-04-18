import 'package:aci_plus_app/repositories/amp18_parser.dart';

class Amp18ChartCache {
  Amp18ChartCache();

  final List<Event1p8G> _event1p8Gs = [];
  final List<Log1p8G> _loadMoreLog1p8Gs = [];
  final List<Log1p8G> _allLog1p8Gs = [];
  final List<RFInOut> _rfInOuts = [];
  final List<RFOutputLog> _rfOutputLogs = [];

  void writeEvent1p8Gs(List<Event1p8G> event1p8Gs) {
    _event1p8Gs.addAll(event1p8Gs);
  }

  List<Event1p8G> readEvent1p8Gs() {
    return _event1p8Gs;
  }

  void writeLoadMoreLog1p8Gs(List<Log1p8G> log1p8Gs) {
    _loadMoreLog1p8Gs.addAll(log1p8Gs);
  }

  List<Log1p8G> readLoadMoreLog1p8Gs() {
    return _loadMoreLog1p8Gs;
  }

  void writeAllLog1p8Gs(List<Log1p8G> log1p8Gs) {
    _allLog1p8Gs.addAll(log1p8Gs);
  }

  List<Log1p8G> readAllLog1p8Gs() {
    return _allLog1p8Gs;
  }

  void writeRFInOuts(List<RFInOut> rfInOuts) {
    _rfInOuts.addAll(rfInOuts);
  }

  List<RFInOut> readRFInOuts() {
    return _rfInOuts;
  }

  void writeRFOutputLogs(List<RFOutputLog> rfOutputLogs) {
    _rfOutputLogs.addAll(rfOutputLogs);
  }

  List<RFOutputLog> readRFOutputLogs() {
    return _rfOutputLogs;
  }

  void clearEvent1p8Gs() {
    _event1p8Gs.clear();
  }

  void clearLoadMoreLog1p8Gs() {
    _loadMoreLog1p8Gs.clear();
  }

  void clearAllLog1p8Gs() {
    _allLog1p8Gs.clear();
  }

  void clearRFInOuts() {
    _rfInOuts.clear();
  }

  void clearRFOutputLogs() {
    _rfOutputLogs.clear();
  }
}
