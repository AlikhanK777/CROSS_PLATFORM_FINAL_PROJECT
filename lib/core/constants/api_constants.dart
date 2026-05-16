class ApiConstants {
  // Ergast F1 API
  static const String ergastBase = 'https://ergast.com/api/f1';
  static const String currentSeason = '$ergastBase/current';
  static const String raceSchedule = '$currentSeason.json';
  static const String driverStandings = '$currentSeason/driverStandings.json';
  static const String constructorStandings = '$currentSeason/constructorStandings.json';
  static const String lastRaceResults = '$ergastBase/current/last/results.json';
  static const String driverStats = '$ergastBase/drivers';

  // Open F1 API (modern alternative)
  static const String openF1Base = 'https://api.openf1.org/v1';

  // NewsData.io API for F1 news (free tier)
  // Replace with your actual API key
  static const String newsApiKey = 'YOUR_NEWSDATA_API_KEY';
  static const String newsBase = 'https://newsdata.io/api/1/news';
  static String get f1NewsUrl =>
      '$newsBase?apikey=$newsApiKey&q=Formula+1+F1&language=en&category=sports';

  // Fallback: GNews API
  static const String gnewsKey = 'YOUR_GNEWS_API_KEY';
  static String get f1GNewsUrl =>
      'https://gnews.io/api/v4/search?q=Formula+1&lang=en&token=$gnewsKey';
}
