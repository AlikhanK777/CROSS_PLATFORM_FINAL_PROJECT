import 'package:equatable/equatable.dart';

class DriverStanding extends Equatable {
  final String position;
  final String points;
  final String wins;
  final String driverId;
  final String givenName;
  final String familyName;
  final String nationality;
  final String constructorName;
  final String? permanentNumber;

  const DriverStanding({
    required this.position,
    required this.points,
    required this.wins,
    required this.driverId,
    required this.givenName,
    required this.familyName,
    required this.nationality,
    required this.constructorName,
    this.permanentNumber,
  });

  String get fullName => '$givenName $familyName';

  factory DriverStanding.fromJson(Map<String, dynamic> json) {
    final driver = json['Driver'] ?? {};
    final constructors = json['Constructors'] as List?;
    return DriverStanding(
      position: json['position'] ?? '0',
      points: json['points'] ?? '0',
      wins: json['wins'] ?? '0',
      driverId: driver['driverId'] ?? '',
      givenName: driver['givenName'] ?? '',
      familyName: driver['familyName'] ?? '',
      nationality: driver['nationality'] ?? '',
      constructorName:
          constructors?.isNotEmpty == true ? constructors![0]['name'] : '',
      permanentNumber: driver['permanentNumber'],
    );
  }

  @override
  List<Object?> get props => [driverId, position, points];
}

class ConstructorStanding extends Equatable {
  final String position;
  final String points;
  final String wins;
  final String constructorId;
  final String name;
  final String nationality;

  const ConstructorStanding({
    required this.position,
    required this.points,
    required this.wins,
    required this.constructorId,
    required this.name,
    required this.nationality,
  });

  factory ConstructorStanding.fromJson(Map<String, dynamic> json) {
    final constructor = json['Constructor'] ?? {};
    return ConstructorStanding(
      position: json['position'] ?? '0',
      points: json['points'] ?? '0',
      wins: json['wins'] ?? '0',
      constructorId: constructor['constructorId'] ?? '',
      name: constructor['name'] ?? '',
      nationality: constructor['nationality'] ?? '',
    );
  }

  @override
  List<Object?> get props => [constructorId, position, points];
}
