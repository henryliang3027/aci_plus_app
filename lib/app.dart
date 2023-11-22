import 'package:aci_plus_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_page.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/dsim12_repository.dart';
import 'package:aci_plus_app/repositories/dsim18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/dsim18_repository.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.aciDeviceRepository,
    required this.dsim12Repository,
    required this.dsim18Repository,
    required this.dsim18CCorNodeRepository,
    required this.unitRepository,
    required this.gpsRepository,
  });

  final ACIDeviceRepository aciDeviceRepository;
  final Dsim12Repository dsim12Repository;
  final Dsim18Repository dsim18Repository;
  final Dsim18CCorNodeRepository dsim18CCorNodeRepository;
  final UnitRepository unitRepository;
  final GPSRepository gpsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ACIDeviceRepository>(
          create: (context) => aciDeviceRepository,
        ),
        RepositoryProvider<Dsim12Repository>(
          create: (context) => dsim12Repository,
        ),
        RepositoryProvider<Dsim18Repository>(
          create: (context) => dsim18Repository,
        ),
        RepositoryProvider<Dsim18CCorNodeRepository>(
          create: (context) => dsim18CCorNodeRepository,
        ),
        RepositoryProvider<UnitRepository>(
          create: (context) => unitRepository,
        ),
        RepositoryProvider<GPSRepository>(
          create: (context) => gpsRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => HomeBloc(
          aciDeviceRepository: aciDeviceRepository,
          dsim12Repository: dsim12Repository,
          dsim18Repository: dsim18Repository,
          dsim18CCorNodeRepository: dsim18CCorNodeRepository,
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
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('zh'),
        // Locale.fromSubtags(
        //   languageCode: 'zh',
        //   scriptCode: 'Hant',
        // ),
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
          background: Colors.grey[50],
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
          return state.showSplash ? const SplashScreen() : const HomePage();
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
        const SplashView(),
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
