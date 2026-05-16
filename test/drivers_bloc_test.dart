import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:f1_hub/bloc/drivers/drivers_bloc.dart';
import 'package:f1_hub/data/repositories/f1_repository.dart';
import 'package:f1_hub/data/models/custom_driver_model.dart';

class MockF1Repository extends Mock implements F1Repository {}

void main() {
  late MockF1Repository mockRepo;
  final testDriver = CustomDriver(
    id: '1', name: 'Max Verstappen', team: 'Red Bull',
    nationality: 'Dutch', number: 1,
    wins: 4, podiums: 6, poles: 3, points: 136,
  );
  setUp(() { mockRepo = MockF1Repository(); });
  group('DriversBloc', () {
    test('initial state is DriversInitial', () {
      when(() => mockRepo.getAllCustomDrivers()).thenReturn([]);
      expect(DriversBloc(repository: mockRepo).state, isA<DriversInitial>());
    });
    blocTest<DriversBloc, DriversState>(
      'emits Loading then Loaded on LoadDrivers',
      build: () {
        when(() => mockRepo.getAllCustomDrivers()).thenReturn([testDriver]);
        return DriversBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(LoadDrivers()),
      expect: () => [isA<DriversLoading>(), isA<DriversLoaded>()],
    );
  });
}
