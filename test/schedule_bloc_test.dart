import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:f1_hub/bloc/schedule/schedule_bloc.dart';
import 'package:f1_hub/data/repositories/f1_repository.dart';
import 'package:f1_hub/data/models/race_model.dart';

class MockF1Repository extends Mock implements F1Repository {}

const mockRaces = [
  Race(season: '2025', round: '1', raceName: 'Australian GP',
      circuitName: 'Albert Park', country: 'Australia',
      locality: 'Melbourne', date: '2025-03-16'),
  Race(season: '2026', round: '1', raceName: 'Australian GP 2026',
      circuitName: 'Albert Park', country: 'Australia',
      locality: 'Melbourne', date: '2026-03-08'),
];

void main() {
  late MockF1Repository mockRepo;
  setUp(() { mockRepo = MockF1Repository(); });
  group('ScheduleBloc', () {
    test('initial state is ScheduleInitial', () {
      expect(ScheduleBloc(repository: mockRepo).state, isA<ScheduleInitial>());
    });
    blocTest<ScheduleBloc, ScheduleState>(
      'emits Loading then Loaded on LoadSchedule',
      build: () {
        when(() => mockRepo.getRaceSchedule()).thenAnswer((_) async => mockRaces);
        return ScheduleBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(LoadSchedule()),
      expect: () => [isA<ScheduleLoading>(), isA<ScheduleLoaded>()],
    );
    blocTest<ScheduleBloc, ScheduleState>(
      'emits Loading then Error when fetch throws',
      build: () {
        when(() => mockRepo.getRaceSchedule()).thenThrow(Exception('error'));
        return ScheduleBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(LoadSchedule()),
      expect: () => [isA<ScheduleLoading>(), isA<ScheduleError>()],
    );
  });
}
