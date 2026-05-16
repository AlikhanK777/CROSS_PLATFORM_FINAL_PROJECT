import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/models/custom_driver_model.dart';
import 'data/repositories/f1_repository.dart';
import 'bloc/schedule/schedule_bloc.dart';
import 'bloc/standings/standings_bloc.dart';
import 'bloc/drivers/drivers_bloc.dart';
import 'bloc/news/news_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CustomDriverAdapter());
  await Hive.openBox<CustomDriver>('custom_drivers');
  runApp(const F1HubApp());
}

class F1HubApp extends StatelessWidget {
  const F1HubApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = F1Repository();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ScheduleBloc(repository: repo)..add(LoadSchedule()),
        ),
        BlocProvider(
          create: (_) => StandingsBloc(repository: repo)..add(LoadStandings()),
        ),
        BlocProvider(
          create: (_) => DriversBloc(repository: repo)..add(LoadDrivers()),
        ),
        BlocProvider(
          create: (_) => NewsBloc(repository: repo)..add(LoadNews()),
        ),
      ],
      child: MaterialApp.router(
        title: 'F1 Hub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}