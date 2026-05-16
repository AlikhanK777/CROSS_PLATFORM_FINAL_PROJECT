import 'package:equatable/equatable.dart';

class Race extends Equatable {
  final String season;
  final String round;
  final String raceName;
  final String circuitName;
  final String country;
  final String locality;
  final String date;
  final String? time;
  final RaceResults? results;

  const Race({
    required this.season,
    required this.round,
    required this.raceName,
    required this.circuitName,
    required this.country,
    required this.locality,
    required this.date,
    this.time,
    this.results,
  });

  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      season: json['season'] ?? '',
      round: json['round'] ?? '',
      raceName: json['raceName'] ?? '',
      circuitName: json['Circuit']?['circuitName'] ?? '',
      country: json['Circuit']?['Location']?['country'] ?? '',
      locality: json['Circuit']?['Location']?['locality'] ?? '',
      date: json['date'] ?? '',
      time: json['time'],
      results: json['Results'] != null
          ? RaceResults.fromJson(json['Results'] as List)
          : null,
    );
  }

  bool get isUpcoming {
    try {
      final raceDate = DateTime.parse(date);
      return raceDate.isAfter(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  Duration get timeUntilRace {
    try {
      final raceDate = DateTime.parse(date);
      return raceDate.difference(DateTime.now());
    } catch (_) {
      return Duration.zero;
    }
  }

  @override
  List<Object?> get props => [season, round, raceName, date];
}

class RaceResults extends Equatable {
  final String driverName;
  final String team;
  final String position;
  final String points;

  const RaceResults({
    required this.driverName,
    required this.team,
    required this.position,
    required this.points,
  });

  factory RaceResults.fromJson(List json) {
    if (json.isEmpty) {
      return const RaceResults(
          driverName: 'N/A', team: 'N/A', position: 'N/A', points: '0');
    }
    final winner = json[0];
    return RaceResults(
      driverName:
          '${winner['Driver']?['givenName']} ${winner['Driver']?['familyName']}',
      team: winner['Constructor']?['name'] ?? '',
      position: winner['position'] ?? '1',
      points: winner['points'] ?? '25',
    );
  }

  @override
  List<Object?> get props => [driverName, team, position];
}
