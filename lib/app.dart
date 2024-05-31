import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_page.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.aciDeviceRepository,
    required this.dsimRepository,
    required this.amp18Repository,
    required this.amp18CCorNodeRepository,
    required this.unitRepository,
    required this.gpsRepository,
    required this.configRepository,
    required this.firmwareRepository,
  });

  final ACIDeviceRepository aciDeviceRepository;
  final DsimRepository dsimRepository;
  final Amp18Repository amp18Repository;
  final Amp18CCorNodeRepository amp18CCorNodeRepository;
  final UnitRepository unitRepository;
  final GPSRepository gpsRepository;
  final ConfigRepository configRepository;
  final FirmwareRepository firmwareRepository;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ACIDeviceRepository>(
          create: (context) => aciDeviceRepository,
        ),
        RepositoryProvider<DsimRepository>(
          create: (context) => dsimRepository,
        ),
        RepositoryProvider<Amp18Repository>(
          create: (context) => amp18Repository,
        ),
        RepositoryProvider<Amp18CCorNodeRepository>(
          create: (context) => amp18CCorNodeRepository,
        ),
        RepositoryProvider<UnitRepository>(
          create: (context) => unitRepository,
        ),
        RepositoryProvider<GPSRepository>(
          create: (context) => gpsRepository,
        ),
        RepositoryProvider<ConfigRepository>(
          create: (context) => configRepository,
        ),
        RepositoryProvider<FirmwareRepository>(
          create: (context) => firmwareRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => HomeBloc(
          aciDeviceRepository: aciDeviceRepository,
          dsimRepository: dsimRepository,
          amp18Repository: amp18Repository,
          amp18CCorNodeRepository: amp18CCorNodeRepository,
        ),
        child: const _AppView(),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      // locale: const Locale('en'),'
      supportedLocales: const <Locale>[
        Locale('en', 'US'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
        Locale('zh', 'TW'),
      ],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          primary: Colors.indigo,
          onPrimary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          foregroundColor: Colors.white,
          backgroundColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            previous.showSplash != current.showSplash,
        builder: (context, state) {
          if (state.showSplash) {
            return const Stack(
              children: [
                HomePage(),
                SplashScreen(),
              ],
            );
          } else {
            return const HomePage();
          }
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // const SplashView(),
        Image.asset(
          'assets/splash2.gif',
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (frame != null) {
              if (frame == 36) {
                context.read<HomeBloc>().add(const SplashStateChanged());
              }
              return SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: child,
              );
            } else {
              return Container(
                color: Theme.of(context).colorScheme.onPrimary,
              );
            }
          },
        ),
      ],
    );
  }
}
