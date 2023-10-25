import 'package:dsim_app/repositories/dsim18_parser.dart';

class Dsim18ChartCache {
  Dsim18ChartCache();

  final List<Event1p8G> _event1p8Gs = [];
  final List<Log1p8G> _loadMoreLogs = [];
  final List<Log1p8G> _all1p8GLogs = [];
  final List<RFInOut> _rfInOuts = [];

  void writeEvent1p8Gs(List<Event1p8G> event1p8Gs) {
    _event1p8Gs.addAll(event1p8Gs);
  }

  List<Event1p8G> readEvent1p8Gs() {
    return _event1p8Gs;
  }

  void writeLoadMoreLog1p8Gs(List<Log1p8G> log1p8Gs) {
    _loadMoreLogs.addAll(log1p8Gs);
  }

  List<Log1p8G> readLoadMoreLog1p8Gs() {
    return _loadMoreLogs;
  }

  void writeAllLog1p8Gs(List<Log1p8G> log1p8Gs) {
    _all1p8GLogs.addAll(log1p8Gs);
  }

  List<Log1p8G> readAllLog1p8Gs() {
    return _all1p8GLogs;
  }

  void clearCache() {
    _event1p8Gs.clear();
    _loadMoreLogs.clear();
    _all1p8GLogs.clear();
  }
}
