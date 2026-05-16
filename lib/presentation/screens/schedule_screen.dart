import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/schedule/schedule_bloc.dart';
import '../../data/models/race_model.dart';
import '../../core/theme/app_theme.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ScheduleView();
  }
}

class _ScheduleView extends StatelessWidget {
  const _ScheduleView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppTheme.f1Red,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('F1',
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Race Schedule'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<ScheduleBloc>().add(RefreshSchedule()),
          ),
        ],
      ),
      body: BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, state) {
          if (state is ScheduleLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.f1Red));
          }
          if (state is ScheduleError) {
            return _ErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<ScheduleBloc>().add(LoadSchedule()));
          }
          if (state is ScheduleLoaded) {
            return _ScheduleList(state: state);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  final ScheduleLoaded state;
  const _ScheduleList({required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppTheme.f1Red,
      onRefresh: () async =>
          context.read<ScheduleBloc>().add(RefreshSchedule()),
      child: CustomScrollView(
        slivers: [
          if (state.nextRace != null) ...[
            SliverToBoxAdapter(
              child: _NextRaceCard(race: state.nextRace!),
            ),
          ],
          if (state.upcomingRaces.isNotEmpty) ...[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('UPCOMING RACES',
                    style: TextStyle(
                        color: AppTheme.f1Red,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 12)),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _RaceCard(
                    race: state.upcomingRaces[index], isUpcoming: true),
                childCount: state.upcomingRaces.length,
              ),
            ),
          ],
          if (state.pastRaces.isNotEmpty) ...[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('PAST RACES',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 12)),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _RaceCard(
                    race: state.pastRaces[index], isUpcoming: false),
                childCount: state.pastRaces.length,
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

class _NextRaceCard extends StatelessWidget {
  final Race race;
  const _NextRaceCard({required this.race});

  @override
  Widget build(BuildContext context) {
    final duration = race.timeUntilRace;
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.f1Red, Color(0xFF8B0000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.f1Red.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('NEXT RACE',
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(race.raceName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('${race.locality}, ${race.country}',
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 4),
          Text(race.date,
              style: const TextStyle(color: Colors.white60, fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            children: [
              _CountdownBox(value: days, label: 'DAYS'),
              const SizedBox(width: 8),
              _CountdownBox(value: hours, label: 'HRS'),
              const SizedBox(width: 8),
              _CountdownBox(value: minutes, label: 'MIN'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountdownBox extends StatelessWidget {
  final int value;
  final String label;
  const _CountdownBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text('$value',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}

class _RaceCard extends StatelessWidget {
  final Race race;
  final bool isUpcoming;
  const _RaceCard({required this.race, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isUpcoming ? AppTheme.f1Red : AppTheme.f1Grey,
          child: Text(
            race.round,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        title: Text(race.raceName,
            style: TextStyle(
                color: isUpcoming ? AppTheme.f1White : Colors.grey,
                fontWeight: FontWeight.w600)),
        subtitle: Text('${race.locality}, ${race.country}',
            style: const TextStyle(fontSize: 12)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(race.date,
                style: TextStyle(
                    color: isUpcoming ? AppTheme.f1Red : Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, color: Colors.grey, size: 64),
          const SizedBox(height: 16),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}