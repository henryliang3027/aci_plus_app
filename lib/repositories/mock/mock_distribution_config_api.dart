import 'package:aci_plus_app/repositories/distribution_config.dart';
import 'package:aci_plus_app/repositories/distribution_config_api.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<DistributionConfig> {}

class MockDistributionConfigApi extends DistributionConfigApi {
  MockDistributionConfigApi() : super(distributionConfigBox: _createMockBox());

  static Box<DistributionConfig> _createMockBox() {
    final mockBox = MockBox();
    final storage = <dynamic, DistributionConfig>{};

    when(() => mockBox.values).thenAnswer((_) => storage.values);
    when(() => mockBox.keys).thenAnswer((_) => storage.keys);
    when(() => mockBox.length).thenAnswer((_) => storage.length);
    when(() => mockBox.isEmpty).thenAnswer((_) => storage.isEmpty);
    when(() => mockBox.isNotEmpty).thenAnswer((_) => storage.isNotEmpty);
    when(() => mockBox.name).thenReturn('MockDistributionConfigBox');
    when(() => mockBox.isOpen).thenReturn(true);

    // 使用具體類型
    when(() => mockBox.get(any<dynamic>(),
            defaultValue: any<DistributionConfig?>(named: 'defaultValue')))
        .thenAnswer((invocation) {
      final key = invocation.positionalArguments[0];
      final defaultValue =
          invocation.namedArguments[#defaultValue] as DistributionConfig?;
      return storage[key] ?? defaultValue;
    });

    when(() => mockBox.put(any<dynamic>(), any<DistributionConfig>()))
        .thenAnswer((invocation) async {
      final key = invocation.positionalArguments[0];
      final value = invocation.positionalArguments[1] as DistributionConfig;
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
