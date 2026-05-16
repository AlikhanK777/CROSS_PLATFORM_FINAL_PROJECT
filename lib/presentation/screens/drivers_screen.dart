import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/drivers/drivers_bloc.dart';
import '../../data/models/custom_driver_model.dart';
import '../../core/theme/app_theme.dart';

class DriversScreen extends StatelessWidget {
  const DriversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DriversView();
  }
}

class _DriversView extends StatelessWidget {
  const _DriversView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Drivers')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/drivers/add');
          if (context.mounted) {
            context.read<DriversBloc>().add(LoadDrivers());
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Driver'),
      ),
      body: BlocBuilder<DriversBloc, DriversState>(
        builder: (context, state) {
          if (state is DriversLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppTheme.f1Red));
          }
          if (state is DriversError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.grey)));
          }
          if (state is DriversLoaded) {
            if (state.drivers.isEmpty) {
              return _EmptyState(
                onAdd: () async {
                  await context.push('/drivers/add');
                  if (context.mounted) {
                    context.read<DriversBloc>().add(LoadDrivers());
                  }
                },
              );
            }
            return _DriverList(drivers: state.drivers);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.directions_car, color: Colors.grey, size: 80),
          const SizedBox(height: 16),
          const Text('No drivers yet',
              style: TextStyle(
                  color: AppTheme.f1White,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Add your own F1 driver to track',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Add Driver'),
          ),
        ],
      ),
    );
  }
}

class _DriverList extends StatelessWidget {
  final List<CustomDriver> drivers;
  const _DriverList({required this.drivers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: drivers.length,
      itemBuilder: (context, index) {
        final driver = drivers[index];
        return _DriverCard(driver: driver);
      },
    );
  }
}

class _DriverCard extends StatelessWidget {
  final CustomDriver driver;
  const _DriverCard({required this.driver});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: AppTheme.f1Red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '#${driver.number}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(driver.name,
                          style: const TextStyle(
                              color: AppTheme.f1White,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      Text(driver.team,
                          style: const TextStyle(
                              color: AppTheme.f1Red, fontSize: 13)),
                      Text(driver.nationality,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  color: AppTheme.f1DarkCard,
                  onSelected: (value) async {
                    if (value == 'edit') {
                      await context.push('/drivers/add',
                          extra: {'driver': driver});
                      if (context.mounted) {
                        context.read<DriversBloc>().add(LoadDrivers());
                      }
                    } else if (value == 'delete') {
                      _showDeleteDialog(context, driver);
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                        value: 'edit',
                        child: Row(children: [
                          Icon(Icons.edit, color: Colors.grey, size: 18),
                          SizedBox(width: 8),
                          Text('Edit', style: TextStyle(color: Colors.white))
                        ])),
                    const PopupMenuItem(
                        value: 'delete',
                        child: Row(children: [
                          Icon(Icons.delete, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red))
                        ])),
                  ],
                ),
              ],
            ),
            if (driver.bio != null && driver.bio!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(driver.bio!,
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatChip(label: 'Wins', value: '${driver.wins}'),
                _StatChip(label: 'Podiums', value: '${driver.podiums}'),
                _StatChip(label: 'Poles', value: '${driver.poles}'),
                _StatChip(
                    label: 'Points', value: '${driver.points.toInt()}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, CustomDriver driver) {
    final bloc = context.read<DriversBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppTheme.f1DarkCard,
        title: const Text('Delete Driver',
            style: TextStyle(color: AppTheme.f1White)),
        content: Text('Remove ${driver.name} from your list?',
            style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              bloc.add(DeleteDriver(driver.id));
            },
            child: const Text('Delete',
                style: TextStyle(color: AppTheme.f1Red)),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: AppTheme.f1White,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}