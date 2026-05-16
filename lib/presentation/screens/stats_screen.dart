import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/standings/standings_bloc.dart';
import '../../data/models/driver_standing_model.dart';
import '../../core/theme/app_theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StatsView();
  }
}

class _StatsView extends StatelessWidget {
  const _StatsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver Stats')),
      body: BlocBuilder<StandingsBloc, StandingsState>(
        builder: (context, state) {
          if (state is StandingsLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.f1Red));
          }
          if (state is StandingsLoaded) {
            return _StatsContent(drivers: state.driverStandings);
          }
          if (state is StandingsError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.grey)));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _StatsContent extends StatelessWidget {
  final List<DriverStanding> drivers;
  const _StatsContent({required this.drivers});

  @override
  Widget build(BuildContext context) {
    if (drivers.isEmpty) {
      return const Center(
          child: Text('No stats available',
              style: TextStyle(color: Colors.grey)));
    }
    final topScorer = drivers[0];
    final sorted = [...drivers]
      ..sort((a, b) => int.parse(b.wins).compareTo(int.parse(a.wins)));
    final topWinner = sorted[0];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('TOP PERFORMERS',
            style: TextStyle(
                color: AppTheme.f1Red,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 12)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _HighlightCard(
                    title: 'Points Leader',
                    value: topScorer.fullName,
                    sub: '${topScorer.points} pts',
                    icon: Icons.leaderboard,
                    color: AppTheme.f1Gold)),
            const SizedBox(width: 12),
            Expanded(
                child: _HighlightCard(
                    title: 'Most Wins',
                    value: topWinner.fullName,
                    sub: '${topWinner.wins} wins',
                    icon: Icons.emoji_events,
                    color: AppTheme.f1Red)),
          ],
        ),
        const SizedBox(height: 20),
        const Text('POINTS COMPARISON',
            style: TextStyle(
                color: AppTheme.f1Red,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontSize: 12)),
        const SizedBox(height: 12),
        ...drivers.take(10).map((d) => _BarRow(
              driver: d,
              maxPoints: double.parse(drivers[0].points),
            )),
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  final String title;
  final String value;
  final String sub;
  final IconData icon;
  final Color color;

  const _HighlightCard({
    required this.title,
    required this.value,
    required this.sub,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    color: AppTheme.f1White,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            Text(sub,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  final DriverStanding driver;
  final double maxPoints;

  const _BarRow({required this.driver, required this.maxPoints});

  @override
  Widget build(BuildContext context) {
    final pts = double.tryParse(driver.points) ?? 0;
    final ratio = maxPoints > 0 ? pts / maxPoints : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(driver.fullName,
                  style: const TextStyle(
                      color: AppTheme.f1White, fontSize: 13)),
              Text('${driver.points} pts',
                  style: const TextStyle(
                      color: AppTheme.f1Red, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: AppTheme.f1Grey,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.f1Red),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}