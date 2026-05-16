import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/standings/standings_bloc.dart';
import '../../data/models/driver_standing_model.dart';
import '../../core/theme/app_theme.dart';

class StandingsScreen extends StatelessWidget {
  const StandingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StandingsView();
  }
}

class _StandingsView extends StatelessWidget {
  const _StandingsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Championship'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: BlocBuilder<StandingsBloc, StandingsState>(
            builder: (context, state) {
              final showDrivers =
                  state is StandingsLoaded ? state.showDrivers : true;
              return Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                decoration: BoxDecoration(
                  color: AppTheme.f1Grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _TabButton(
                        label: 'Drivers',
                        isSelected: showDrivers,
                        onTap: () {
                          if (!showDrivers) {
                            context
                                .read<StandingsBloc>()
                                .add(ToggleStandingsView());
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: _TabButton(
                        label: 'Constructors',
                        isSelected: !showDrivers,
                        onTap: () {
                          if (showDrivers) {
                            context
                                .read<StandingsBloc>()
                                .add(ToggleStandingsView());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: BlocBuilder<StandingsBloc, StandingsState>(
        builder: (context, state) {
          if (state is StandingsLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.f1Red));
          }
          if (state is StandingsError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.grey)));
          }
          if (state is StandingsLoaded) {
            return state.showDrivers
                ? _DriverStandingsList(drivers: state.driverStandings)
                : _ConstructorStandingsList(
                    constructors: state.constructorStandings);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _TabButton(
      {required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.f1Red : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _DriverStandingsList extends StatelessWidget {
  final List<DriverStanding> drivers;
  const _DriverStandingsList({required this.drivers});

  @override
  Widget build(BuildContext context) {
    if (drivers.isEmpty) {
      return const Center(
          child: Text('No data available',
              style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: drivers.length,
      itemBuilder: (context, index) {
        final d = drivers[index];
        final pos = int.tryParse(d.position) ?? 0;
        return _DriverRow(driver: d, index: index, pos: pos);
      },
    );
  }
}

class _DriverRow extends StatelessWidget {
  final DriverStanding driver;
  final int index;
  final int pos;
  const _DriverRow(
      {required this.driver, required this.index, required this.pos});

  Color get _medalColor {
    if (pos == 1) return AppTheme.f1Gold;
    if (pos == 2) return const Color(0xFFC0C0C0);
    if (pos == 3) return const Color(0xFFCD7F32);
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                driver.position,
                style: TextStyle(
                  color: pos <= 3 ? _medalColor : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(driver.fullName,
                      style: const TextStyle(
                          color: AppTheme.f1White,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  Text(driver.constructorName,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${driver.points} pts',
                    style: const TextStyle(
                        color: AppTheme.f1Red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                Text('${driver.wins} wins',
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConstructorStandingsList extends StatelessWidget {
  final List<ConstructorStanding> constructors;
  const _ConstructorStandingsList({required this.constructors});

  @override
  Widget build(BuildContext context) {
    if (constructors.isEmpty) {
      return const Center(
          child: Text('No data available',
              style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: constructors.length,
      itemBuilder: (context, index) {
        final c = constructors[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(c.position,
                      style: const TextStyle(
                          color: AppTheme.f1Red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name,
                          style: const TextStyle(
                              color: AppTheme.f1White,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      Text(c.nationality,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Text('${c.points} pts',
                    style: const TextStyle(
                        color: AppTheme.f1Red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ],
            ),
          ),
        );
      },
    );
  }
}