import 'package:aci_plus_app/repositories/dsim18_ccor_node_parser.dart';

class Dsim18CCorNodeChartCache {
  Dsim18CCorNodeChartCache();

  final List<Event1p8GCCorNode> _event1p8Gs = [];
  final List<Log1p8GCCorNode> _loadMoreLog1p8Gs = [];
  final List<Log1p8GCCorNode> _allLog1p8Gs = [];

  void writeEvent1p8Gs(List<Event1p8GCCorNode> event1p8Gs) {
    _event1p8Gs.addAll(event1p8Gs);
  }

  List<Event1p8GCCorNode> readEvent1p8Gs() {
    return _event1p8Gs;
  }

  void writeLoadMoreLog1p8Gs(List<Log1p8GCCorNode> log1p8Gs) {
    _loadMoreLog1p8Gs.addAll(log1p8Gs);
  }

  List<Log1p8GCCorNode> readLoadMoreLog1p8Gs() {
    return _loadMoreLog1p8Gs;
  }

  void writeAllLog1p8Gs(List<Log1p8GCCorNode> log1p8Gs) {
    _allLog1p8Gs.addAll(log1p8Gs);
  }

  List<Log1p8GCCorNode> readAllLog1p8Gs() {
    return _allLog1p8Gs;
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
}
