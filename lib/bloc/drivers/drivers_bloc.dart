import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/custom_driver_model.dart';
import '../../data/repositories/f1_repository.dart';

// Events
abstract class DriversEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDrivers extends DriversEvent {}

class AddDriver extends DriversEvent {
  final CustomDriver driver;
  AddDriver(this.driver);
  @override
  List<Object?> get props => [driver];
}

class UpdateDriver extends DriversEvent {
  final CustomDriver driver;
  UpdateDriver(this.driver);
  @override
  List<Object?> get props => [driver];
}

class DeleteDriver extends DriversEvent {
  final String id;
  DeleteDriver(this.id);
  @override
  List<Object?> get props => [id];
}

// States
abstract class DriversState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DriversInitial extends DriversState {}

class DriversLoading extends DriversState {}

class DriversLoaded extends DriversState {
  final List<CustomDriver> drivers;
  DriversLoaded(this.drivers);
  @override
  List<Object?> get props => [drivers];
}

class DriversError extends DriversState {
  final String message;
  DriversError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class DriversBloc extends Bloc<DriversEvent, DriversState> {
  final F1Repository repository;

  DriversBloc({required this.repository}) : super(DriversInitial()) {
    on<LoadDrivers>(_onLoad);
    on<AddDriver>(_onAdd);
    on<UpdateDriver>(_onUpdate);
    on<DeleteDriver>(_onDelete);
  }

  void _onLoad(LoadDrivers event, Emitter<DriversState> emit) {
    emit(DriversLoading());
    try {
      final drivers = repository.getAllCustomDrivers();
      emit(DriversLoaded(drivers));
    } catch (e) {
      emit(DriversError('Failed to load drivers: $e'));
    }
  }

  Future<void> _onAdd(AddDriver event, Emitter<DriversState> emit) async {
    try {
      await repository.addCustomDriver(event.driver);
      final drivers = repository.getAllCustomDrivers();
      emit(DriversLoaded(drivers));
    } catch (e) {
      emit(DriversError('Failed to add driver: $e'));
    }
  }

  Future<void> _onUpdate(UpdateDriver event, Emitter<DriversState> emit) async {
    try {
      await repository.updateCustomDriver(event.driver);
      final drivers = repository.getAllCustomDrivers();
      emit(DriversLoaded(drivers));
    } catch (e) {
      emit(DriversError('Failed to update driver: $e'));
    }
  }

  Future<void> _onDelete(DeleteDriver event, Emitter<DriversState> emit) async {
    try {
      await repository.deleteCustomDriver(event.id);
      final drivers = repository.getAllCustomDrivers();
      emit(DriversLoaded(drivers));
    } catch (e) {
      emit(DriversError('Failed to delete driver: $e'));
    }
  }
}
