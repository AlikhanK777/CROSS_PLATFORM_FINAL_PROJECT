import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:f1_hub/bloc/standings/standings_bloc.dart';
import 'package:f1_hub/data/repositories/f1_repository.dart';
import 'package:f1_hub/data/models/driver_standing_model.dart';

class MockF1Repository extends Mock implements F1Repository {}

void main() {
  late MockF1Repository mockRepo;
  final mockDrivers = [
    DriverStanding(position: '1', points: '136', wins: '4',
        driverId: 'verstappen', givenName: 'Max',
        familyName: 'Verstappen', nationality: 'Dutch',
        constructorName: 'Red Bull'),
  ];
  final mockConstructors = [
    ConstructorStanding(position: '1', points: '209', wins: '5',
        constructorId: 'mclaren', name: 'McLaren', nationality: 'British'),
  ];
  setUp(() { mockRepo = MockF1Repository(); });
  group('StandingsBloc', () {
    test('initial state is StandingsInitial', () {
      expect(StandingsBloc(repository: mockRepo).state, isA<StandingsInitial>());
    });
    blocTest<StandingsBloc, StandingsState>(
      'emits Loading then Loaded on LoadStandings',
      build: () {
        when(() => mockRepo.getDriverStandings()).thenAnswer((_) async => mockDrivers);
        when(() => mockRepo.getConstructorStandings()).thenAnswer((_) async => mockConstructors);
        return StandingsBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(LoadStandings()),
      expect: () => [isA<StandingsLoading>(), isA<StandingsLoaded>()],
    );
    blocTest<StandingsBloc, StandingsState>(
      'emits Loading then Error when fetch throws',
      build: () {
        when(() => mockRepo.getDriverStandings()).thenThrow(Exception('error'));
        when(() => mockRepo.getConstructorStandings()).thenAnswer((_) async => []);
        return StandingsBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(LoadStandings()),
      expect: () => [isA<StandingsLoading>(), isA<StandingsError>()],
    );
  });
}
