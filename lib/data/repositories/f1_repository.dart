import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../datasources/f1_remote_datasource.dart';
import '../datasources/driver_local_datasource.dart';
import '../models/race_model.dart';
import '../models/driver_standing_model.dart';
import '../models/news_model.dart';
import '../models/custom_driver_model.dart';

class F1Repository {
  final F1RemoteDatasource remote;
  final DriverLocalDatasource local;

  F1Repository({
    F1RemoteDatasource? remote,
    DriverLocalDatasource? local,
  })  : remote = remote ?? F1RemoteDatasource(),
        local = local ?? DriverLocalDatasource();

  Future<List<Race>> getRaceSchedule() async {
    try {
      final races = await remote.getRaceSchedule();
      if (races.isNotEmpty) return races;
      return _mockRaces();
    } catch (e) {
      return _mockRaces();
    }
  }

  Future<List<Race>> getLastRaceResults() async {
    try {
      return await remote.getLastRaceResults();
    } catch (e) {
      return [];
    }
  }

  Future<List<DriverStanding>> getDriverStandings() async {
    try {
      final result = await remote.getDriverStandings();
      if (result.isNotEmpty) return result;
      return _mockDriverStandings();
    } catch (e) {
      return _mockDriverStandings();
    }
  }

  Future<List<ConstructorStanding>> getConstructorStandings() async {
    try {
      final result = await remote.getConstructorStandings();
      if (result.isNotEmpty) return result;
      return _mockConstructorStandings();
    } catch (e) {
      return _mockConstructorStandings();
    }
  }

  Future<List<NewsArticle>> getNews() async {
    try {
      return await remote.getF1News();
    } catch (e) {
      return NewsArticle.mockArticles;
    }
  }

  List<CustomDriver> getAllCustomDrivers() => local.getAllDrivers();
  Future<void> addCustomDriver(CustomDriver driver) => local.addDriver(driver);
  Future<void> updateCustomDriver(CustomDriver driver) => local.updateDriver(driver);
  Future<void> deleteCustomDriver(String id) => local.deleteDriver(id);

  List<DriverStanding> _mockDriverStandings() => [
    DriverStanding(position: '1', points: '136', wins: '4', driverId: 'verstappen', givenName: 'Max', familyName: 'Verstappen', nationality: 'Dutch', constructorName: 'Red Bull'),
    DriverStanding(position: '2', points: '113', wins: '3', driverId: 'norris', givenName: 'Lando', familyName: 'Norris', nationality: 'British', constructorName: 'McLaren'),
    DriverStanding(position: '3', points: '98', wins: '2', driverId: 'leclerc', givenName: 'Charles', familyName: 'Leclerc', nationality: 'Monegasque', constructorName: 'Ferrari'),
    DriverStanding(position: '4', points: '87', wins: '1', driverId: 'hamilton', givenName: 'Lewis', familyName: 'Hamilton', nationality: 'British', constructorName: 'Ferrari'),
    DriverStanding(position: '5', points: '76', wins: '1', driverId: 'piastri', givenName: 'Oscar', familyName: 'Piastri', nationality: 'Australian', constructorName: 'McLaren'),
    DriverStanding(position: '6', points: '63', wins: '0', driverId: 'russell', givenName: 'George', familyName: 'Russell', nationality: 'British', constructorName: 'Mercedes'),
    DriverStanding(position: '7', points: '52', wins: '0', driverId: 'sainz', givenName: 'Carlos', familyName: 'Sainz', nationality: 'Spanish', constructorName: 'Williams'),
    DriverStanding(position: '8', points: '41', wins: '0', driverId: 'perez', givenName: 'Sergio', familyName: 'Perez', nationality: 'Mexican', constructorName: 'Red Bull'),
    DriverStanding(position: '9', points: '30', wins: '0', driverId: 'alonso', givenName: 'Fernando', familyName: 'Alonso', nationality: 'Spanish', constructorName: 'Aston Martin'),
    DriverStanding(position: '10', points: '21', wins: '0', driverId: 'stroll', givenName: 'Lance', familyName: 'Stroll', nationality: 'Canadian', constructorName: 'Aston Martin'),
  ];

  List<ConstructorStanding> _mockConstructorStandings() => [
    ConstructorStanding(position: '1', points: '209', wins: '5', constructorId: 'mclaren', name: 'McLaren', nationality: 'British'),
    ConstructorStanding(position: '2', points: '196', wins: '4', constructorId: 'redbull', name: 'Red Bull', nationality: 'Austrian'),
    ConstructorStanding(position: '3', points: '185', wins: '3', constructorId: 'ferrari', name: 'Ferrari', nationality: 'Italian'),
    ConstructorStanding(position: '4', points: '112', wins: '0', constructorId: 'mercedes', name: 'Mercedes', nationality: 'German'),
    ConstructorStanding(position: '5', points: '56', wins: '0', constructorId: 'aston', name: 'Aston Martin', nationality: 'British'),
  ];

  List<Race> _mockRaces() => [
    // ─── 2025 RACES ───
    const Race(season: '2025', round: '1', raceName: 'Australian Grand Prix', circuitName: 'Albert Park Circuit', country: 'Australia', locality: 'Melbourne', date: '2025-03-16'),
    const Race(season: '2025', round: '2', raceName: 'Chinese Grand Prix', circuitName: 'Shanghai International Circuit', country: 'China', locality: 'Shanghai', date: '2025-03-23'),
    const Race(season: '2025', round: '3', raceName: 'Japanese Grand Prix', circuitName: 'Suzuka Circuit', country: 'Japan', locality: 'Suzuka', date: '2025-04-06'),
    const Race(season: '2025', round: '4', raceName: 'Bahrain Grand Prix', circuitName: 'Bahrain International Circuit', country: 'Bahrain', locality: 'Sakhir', date: '2025-04-13'),
    const Race(season: '2025', round: '5', raceName: 'Saudi Arabian Grand Prix', circuitName: 'Jeddah Corniche Circuit', country: 'Saudi Arabia', locality: 'Jeddah', date: '2025-04-20'),
    const Race(season: '2025', round: '6', raceName: 'Miami Grand Prix', circuitName: 'Miami International Autodrome', country: 'USA', locality: 'Miami', date: '2025-05-04'),
    const Race(season: '2025', round: '7', raceName: 'Emilia Romagna Grand Prix', circuitName: 'Autodromo Enzo e Dino Ferrari', country: 'Italy', locality: 'Imola', date: '2025-05-18'),
    const Race(season: '2025', round: '8', raceName: 'Monaco Grand Prix', circuitName: 'Circuit de Monaco', country: 'Monaco', locality: 'Monte-Carlo', date: '2025-05-25'),
    const Race(season: '2025', round: '9', raceName: 'Spanish Grand Prix', circuitName: 'Circuit de Barcelona-Catalunya', country: 'Spain', locality: 'Barcelona', date: '2025-06-01'),
    const Race(season: '2025', round: '10', raceName: 'Canadian Grand Prix', circuitName: 'Circuit Gilles Villeneuve', country: 'Canada', locality: 'Montreal', date: '2025-06-15'),
    const Race(season: '2025', round: '11', raceName: 'Austrian Grand Prix', circuitName: 'Red Bull Ring', country: 'Austria', locality: 'Spielberg', date: '2025-06-29'),
    const Race(season: '2025', round: '12', raceName: 'British Grand Prix', circuitName: 'Silverstone Circuit', country: 'UK', locality: 'Silverstone', date: '2025-07-06'),
    const Race(season: '2025', round: '13', raceName: 'Belgian Grand Prix', circuitName: 'Circuit de Spa-Francorchamps', country: 'Belgium', locality: 'Spa', date: '2025-07-27'),
    const Race(season: '2025', round: '14', raceName: 'Hungarian Grand Prix', circuitName: 'Hungaroring', country: 'Hungary', locality: 'Budapest', date: '2025-08-03'),
    const Race(season: '2025', round: '15', raceName: 'Dutch Grand Prix', circuitName: 'Circuit Zandvoort', country: 'Netherlands', locality: 'Zandvoort', date: '2025-08-31'),
    const Race(season: '2025', round: '16', raceName: 'Italian Grand Prix', circuitName: 'Autodromo Nazionale Monza', country: 'Italy', locality: 'Monza', date: '2025-09-07'),
    const Race(season: '2025', round: '17', raceName: 'Azerbaijan Grand Prix', circuitName: 'Baku City Circuit', country: 'Azerbaijan', locality: 'Baku', date: '2025-09-21'),
    const Race(season: '2025', round: '18', raceName: 'Singapore Grand Prix', circuitName: 'Marina Bay Street Circuit', country: 'Singapore', locality: 'Singapore', date: '2025-10-05'),
    const Race(season: '2025', round: '19', raceName: 'United States Grand Prix', circuitName: 'Circuit of the Americas', country: 'USA', locality: 'Austin', date: '2025-10-19'),
    const Race(season: '2025', round: '20', raceName: 'Mexico City Grand Prix', circuitName: 'Autodromo Hermanos Rodriguez', country: 'Mexico', locality: 'Mexico City', date: '2025-10-26'),
    const Race(season: '2025', round: '21', raceName: 'São Paulo Grand Prix', circuitName: 'Autodromo Jose Carlos Pace', country: 'Brazil', locality: 'São Paulo', date: '2025-11-09'),
    const Race(season: '2025', round: '22', raceName: 'Las Vegas Grand Prix', circuitName: 'Las Vegas Strip Circuit', country: 'USA', locality: 'Las Vegas', date: '2025-11-22'),
    const Race(season: '2025', round: '23', raceName: 'Qatar Grand Prix', circuitName: 'Losail International Circuit', country: 'Qatar', locality: 'Lusail', date: '2025-11-30'),
    const Race(season: '2025', round: '24', raceName: 'Abu Dhabi Grand Prix', circuitName: 'Yas Marina Circuit', country: 'UAE', locality: 'Abu Dhabi', date: '2025-12-07'),
    // ─── 2026 UPCOMING RACES ───
    const Race(season: '2026', round: '1', raceName: 'Australian Grand Prix 2026', circuitName: 'Albert Park Circuit', country: 'Australia', locality: 'Melbourne', date: '2026-03-08'),
    const Race(season: '2026', round: '2', raceName: 'Chinese Grand Prix 2026', circuitName: 'Shanghai International Circuit', country: 'China', locality: 'Shanghai', date: '2026-03-15'),
    const Race(season: '2026', round: '3', raceName: 'Japanese Grand Prix 2026', circuitName: 'Suzuka Circuit', country: 'Japan', locality: 'Suzuka', date: '2026-03-29'),
    const Race(season: '2026', round: '4', raceName: 'Miami Grand Prix 2026', circuitName: 'Miami International Autodrome', country: 'USA', locality: 'Miami', date: '2026-05-03'),
    const Race(season: '2026', round: '5', raceName: 'Canadian Grand Prix 2026', circuitName: 'Circuit Gilles Villeneuve', country: 'Canada', locality: 'Montreal', date: '2026-05-24'),
    const Race(season: '2026', round: '6', raceName: 'Monaco Grand Prix 2026', circuitName: 'Circuit de Monaco', country: 'Monaco', locality: 'Monte-Carlo', date: '2026-06-07'),
    const Race(season: '2026', round: '7', raceName: 'Spanish Grand Prix 2026', circuitName: 'Circuit de Barcelona-Catalunya', country: 'Spain', locality: 'Barcelona', date: '2026-06-14'),
    const Race(season: '2026', round: '8', raceName: 'Austrian Grand Prix 2026', circuitName: 'Red Bull Ring', country: 'Austria', locality: 'Spielberg', date: '2026-06-28'),
    const Race(season: '2026', round: '9', raceName: 'British Grand Prix 2026', circuitName: 'Silverstone Circuit', country: 'UK', locality: 'Silverstone', date: '2026-07-05'),
    const Race(season: '2026', round: '10', raceName: 'Belgian Grand Prix 2026', circuitName: 'Circuit de Spa-Francorchamps', country: 'Belgium', locality: 'Spa', date: '2026-07-19'),
    const Race(season: '2026', round: '11', raceName: 'Hungarian Grand Prix 2026', circuitName: 'Hungaroring', country: 'Hungary', locality: 'Budapest', date: '2026-07-26'),
    const Race(season: '2026', round: '12', raceName: 'Dutch Grand Prix 2026', circuitName: 'Circuit Zandvoort', country: 'Netherlands', locality: 'Zandvoort', date: '2026-08-30'),
    const Race(season: '2026', round: '13', raceName: 'Italian Grand Prix 2026', circuitName: 'Autodromo Nazionale Monza', country: 'Italy', locality: 'Monza', date: '2026-09-06'),
  ];
}