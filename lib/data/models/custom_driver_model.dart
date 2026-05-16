import 'package:hive/hive.dart';

part 'custom_driver_model.g.dart';

@HiveType(typeId: 0)
class CustomDriver extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String team;

  @HiveField(3)
  late String nationality;

  @HiveField(4)
  late int number;

  @HiveField(5)
  late String? bio;

  @HiveField(6)
  late int wins;

  @HiveField(7)
  late int podiums;

  @HiveField(8)
  late int poles;

  @HiveField(9)
  late double points;

  CustomDriver({
    required this.id,
    required this.name,
    required this.team,
    required this.nationality,
    required this.number,
    this.bio,
    this.wins = 0,
    this.podiums = 0,
    this.poles = 0,
    this.points = 0.0,
  });
}
