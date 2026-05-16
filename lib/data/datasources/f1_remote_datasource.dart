import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/race_model.dart';
import '../models/driver_standing_model.dart';
import '../models/news_model.dart';
import '../../core/constants/api_constants.dart';

class F1RemoteDatasource {
  final http.Client client;

  F1RemoteDatasource({http.Client? client}) : client = client ?? http.Client();

  Future<List<Race>> getRaceSchedule() async {
    final response = await client
        .get(Uri.parse(ApiConstants.raceSchedule))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final races = data['MRData']['RaceTable']['Races'] as List;
      return races.map((r) => Race.fromJson(r)).toList();
    } else {
      throw Exception('Failed to load race schedule: ${response.statusCode}');
    }
  }

  Future<List<Race>> getLastRaceResults() async {
    final response = await client
        .get(Uri.parse(ApiConstants.lastRaceResults))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final races = data['MRData']['RaceTable']['Races'] as List;
      return races.map((r) => Race.fromJson(r)).toList();
    } else {
      throw Exception('Failed to load race results');
    }
  }

  Future<List<DriverStanding>> getDriverStandings() async {
    final response = await client
        .get(Uri.parse(ApiConstants.driverStandings))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final standingsList = data['MRData']['StandingsTable']
          ['StandingsLists'] as List;
      if (standingsList.isEmpty) return [];
      final drivers = standingsList[0]['DriverStandings'] as List;
      return drivers.map((d) => DriverStanding.fromJson(d)).toList();
    } else {
      throw Exception('Failed to load driver standings');
    }
  }

  Future<List<ConstructorStanding>> getConstructorStandings() async {
    final response = await client
        .get(Uri.parse(ApiConstants.constructorStandings))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final standingsList = data['MRData']['StandingsTable']
          ['StandingsLists'] as List;
      if (standingsList.isEmpty) return [];
      final constructors = standingsList[0]['ConstructorStandings'] as List;
      return constructors
          .map((c) => ConstructorStanding.fromJson(c))
          .toList();
    } else {
      throw Exception('Failed to load constructor standings');
    }
  }

  Future<List<NewsArticle>> getF1News() async {
    // Return mock articles as fallback (API key needed for real news)
    // To use real news, replace with actual API call:
    // final response = await client.get(Uri.parse(ApiConstants.f1NewsUrl));
    return NewsArticle.mockArticles;
  }
}
