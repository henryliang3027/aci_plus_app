// Mock API 類別，不依賴 Hive
import 'package:aci_plus_app/repositories/trunk_config.dart';
import 'package:aci_plus_app/repositories/trunk_config_api.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<TrunkConfig> {}

class MockTrunkConfigApi extends TrunkConfigApi {
  MockTrunkConfigApi() : super(trunkConfigBox: _createMockBox());

  static Box<TrunkConfig> _createMockBox() {
    final mockBox = MockBox();
    final storage = <dynamic, TrunkConfig>{};

    when(() => mockBox.values).thenAnswer((_) => storage.values);
    when(() => mockBox.keys).thenAnswer((_) => storage.keys);
    when(() => mockBox.length).thenAnswer((_) => storage.length);
    when(() => mockBox.isEmpty).thenAnswer((_) => storage.isEmpty);
    when(() => mockBox.isNotEmpty).thenAnswer((_) => storage.isNotEmpty);
    when(() => mockBox.name).thenReturn('MockTrunkConfigBox');
    when(() => mockBox.isOpen).thenReturn(true);

    // 使用更具體的 matcher 而不是 any()
    when(() => mockBox.get(any<dynamic>(),
            defaultValue: any<TrunkConfig?>(named: 'defaultValue')))
        .thenAnswer((invocation) {
      final key = invocation.positionalArguments[0];
      final defaultValue =
          invocation.namedArguments[#defaultValue] as TrunkConfig?;
      return storage[key] ?? defaultValue;
    });

    when(() => mockBox.put(any<dynamic>(), any<TrunkConfig>()))
        .thenAnswer((invocation) async {
      final key = invocation.positionalArguments[0];
      final value = invocation.positionalArguments[1] as TrunkConfig;
      storage[key] = value;
    });

    when(() => mockBox.delete(any<dynamic>())).thenAnswer((invocation) async {
      final key = invocation.positionalArguments[0];
      storage.remove(key);
    });

    when(() => mockBox.deleteAll(any<Iterable>()))
        .thenAnswer((invocation) async {
      final keys = invocation.positionalArguments[0] as Iterable;
      for (final key in keys) {
        storage.remove(key);
      }
    });

    when(() => mockBox.clear()).thenAnswer((_) async {
      final count = storage.length;
      storage.clear();
      return count;
    });

    when(() => mockBox.containsKey(any<dynamic>())).thenAnswer((invocation) {
      final key = invocation.positionalArguments[0];
      return storage.containsKey(key);
    });

    when(() => mockBox.toMap()).thenAnswer((_) => Map.from(storage));
    when(() => mockBox.close()).thenAnswer((_) async {});
    when(() => mockBox.compact()).thenAnswer((_) async {});

    return mockBox;
  }
}
