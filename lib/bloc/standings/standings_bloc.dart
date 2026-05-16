import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/driver_standing_model.dart';
import '../../data/repositories/f1_repository.dart';

// Events
abstract class StandingsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadStandings extends StandingsEvent {}

class ToggleStandingsView extends StandingsEvent {}

// States
abstract class StandingsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StandingsInitial extends StandingsState {}

class StandingsLoading extends StandingsState {}

class StandingsLoaded extends StandingsState {
  final List<DriverStanding> driverStandings;
  final List<ConstructorStanding> constructorStandings;
  final bool showDrivers;

  StandingsLoaded({
    required this.driverStandings,
    required this.constructorStandings,
    this.showDrivers = true,
  });

  StandingsLoaded copyWith({bool? showDrivers}) => StandingsLoaded(
        driverStandings: driverStandings,
        constructorStandings: constructorStandings,
        showDrivers: showDrivers ?? this.showDrivers,
      );

  @override
  List<Object?> get props => [driverStandings, constructorStandings, showDrivers];
}

class StandingsError extends StandingsState {
  final String message;
  StandingsError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class StandingsBloc extends Bloc<StandingsEvent, StandingsState> {
  final F1Repository repository;

  StandingsBloc({required this.repository}) : super(StandingsInitial()) {
    on<LoadStandings>(_onLoad);
    on<ToggleStandingsView>(_onToggle);
  }

  Future<void> _onLoad(LoadStandings event, Emitter<StandingsState> emit) async {
    emit(StandingsLoading());
    try {
      final drivers = await repository.getDriverStandings();
      final constructors = await repository.getConstructorStandings();
      emit(StandingsLoaded(
          driverStandings: drivers, constructorStandings: constructors));
    } catch (e) {
      emit(StandingsError('Failed to load standings: $e'));
    }
  }

  void _onToggle(ToggleStandingsView event, Emitter<StandingsState> emit) {
    if (state is StandingsLoaded) {
      final loaded = state as StandingsLoaded;
      emit(loaded.copyWith(showDrivers: !loaded.showDrivers));
    }
  }
}
