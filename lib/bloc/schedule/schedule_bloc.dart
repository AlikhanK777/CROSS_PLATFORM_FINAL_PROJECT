import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/race_model.dart';
import '../../data/repositories/f1_repository.dart';

// Events
abstract class ScheduleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSchedule extends ScheduleEvent {}

class RefreshSchedule extends ScheduleEvent {}

// States
abstract class ScheduleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<Race> races;
  final List<Race> upcomingRaces;
  final List<Race> pastRaces;
  final Race? nextRace;

  ScheduleLoaded({
    required this.races,
  })  : upcomingRaces = races.where((r) => r.isUpcoming).toList(),
        pastRaces = races.where((r) => !r.isUpcoming).toList(),
        nextRace = races.where((r) => r.isUpcoming).isNotEmpty
            ? races.where((r) => r.isUpcoming).first
            : null;

  @override
  List<Object?> get props => [races];
}

class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final F1Repository repository;

  ScheduleBloc({required this.repository}) : super(ScheduleInitial()) {
    on<LoadSchedule>(_onLoadSchedule);
    on<RefreshSchedule>(_onRefreshSchedule);
  }

  Future<void> _onLoadSchedule(
      LoadSchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      final races = await repository.getRaceSchedule();
      emit(ScheduleLoaded(races: races));
    } catch (e) {
      emit(ScheduleError('Failed to load schedule: $e'));
    }
  }

  Future<void> _onRefreshSchedule(
      RefreshSchedule event, Emitter<ScheduleState> emit) async {
    try {
      final races = await repository.getRaceSchedule();
      emit(ScheduleLoaded(races: races));
    } catch (e) {
      emit(ScheduleError('Failed to refresh schedule: $e'));
    }
  }
}
