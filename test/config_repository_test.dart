import 'package:flutter_test/flutter_test.dart';

import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/trunk_config_api.dart';
import 'package:aci_plus_app/repositories/distribution_config_api.dart';
import 'package:mocktail/mocktail.dart';

// Mock TrunkConfigApi
class MockTrunkConfigApi extends Mock implements TrunkConfigApi {}

// Mock DistributionConfigApi
class MockDistributionConfigApi extends Mock implements DistributionConfigApi {}

void main() {
  group('ConfigRepository', () {
    late ConfigRepository configRepository;
    late MockTrunkConfigApi mockTrunkConfigApi;
    late MockDistributionConfigApi mockDistributionConfigApi;

    setUp(() {
      mockTrunkConfigApi = MockTrunkConfigApi();
      mockDistributionConfigApi = MockDistributionConfigApi();
      configRepository = ConfigRepository(
        trunkConfigApi: mockTrunkConfigApi,
        distributionConfigApi: mockDistributionConfigApi,
      );
    });

    test('putConfig adds trunk config correctly', () async {
      // Arrange
      when(() => mockTrunkConfigApi.putConfig(
            id: any(named: 'id'),
            name: any(named: 'name'),
            splitOption: any(named: 'splitOption'),
            firstChannelLoadingFrequency:
                any(named: 'firstChannelLoadingFrequency'),
            firstChannelLoadingLevel: any(named: 'firstChannelLoadingLevel'),
            lastChannelLoadingFrequency:
                any(named: 'lastChannelLoadingFrequency'),
            lastChannelLoadingLevel: any(named: 'lastChannelLoadingLevel'),
            isDefault: any(named: 'isDefault'),
          )).thenAnswer((_) => Future.value());

      // Act
      await configRepository.putConfig(
        groupId: '0',
        name: 'TestTrunkConfig',
        splitOption: 'TestSplitOption',
        firstChannelLoadingFrequency: 'TestFirstFrequency',
        firstChannelLoadingLevel: 'TestFirstLevel',
        lastChannelLoadingFrequency: 'TestLastFrequency',
        lastChannelLoadingLevel: 'TestLastLevel',
        isDefault: '0',
      );

      // Assert
      verify(() => mockTrunkConfigApi.putConfig(
            id: any(named: 'id'),
            name: 'TestTrunkConfig',
            splitOption: 'TestSplitOption',
            firstChannelLoadingFrequency: 'TestFirstFrequency',
            firstChannelLoadingLevel: 'TestFirstLevel',
            lastChannelLoadingFrequency: 'TestLastFrequency',
            lastChannelLoadingLevel: 'TestLastLevel',
            isDefault: '0',
          )).called(1);

      expect(configRepository.getEmptyNameId(groupId: '0'), 1);
    });

    test('putConfig adds distribution config correctly', () async {
      // Arrange
      when(() => mockDistributionConfigApi.putConfig(
            id: any(named: 'id'),
            name: any(named: 'name'),
            splitOption: any(named: 'splitOption'),
            firstChannelLoadingFrequency:
                any(named: 'firstChannelLoadingFrequency'),
            firstChannelLoadingLevel: any(named: 'firstChannelLoadingLevel'),
            lastChannelLoadingFrequency:
                any(named: 'lastChannelLoadingFrequency'),
            lastChannelLoadingLevel: any(named: 'lastChannelLoadingLevel'),
            isDefault: any(named: 'isDefault'),
          )).thenAnswer((_) => Future.value());

      // Act
      await configRepository.putConfig(
        groupId: '1',
        name: 'TestDistributionConfig',
        splitOption: 'TestSplitOption',
        firstChannelLoadingFrequency: 'TestFirstFrequency',
        firstChannelLoadingLevel: 'TestFirstLevel',
        lastChannelLoadingFrequency: 'TestLastFrequency',
        lastChannelLoadingLevel: 'TestLastLevel',
        isDefault: '0',
      );

      // Assert
      verify(() => mockDistributionConfigApi.putConfig(
            id: any(named: 'id'),
            name: 'TestDistributionConfig',
            splitOption: 'TestSplitOption',
            firstChannelLoadingFrequency: 'TestFirstFrequency',
            firstChannelLoadingLevel: 'TestFirstLevel',
            lastChannelLoadingFrequency: 'TestLastFrequency',
            lastChannelLoadingLevel: 'TestLastLevel',
            isDefault: '0',
          )).called(1);
      expect(configRepository.getEmptyNameId(groupId: '1'), 1);
    });

    // Add more tests for other methods as needed
  });
}
