import 'package:aci_plus_app/home/bloc/home/home_bloc.dart';
import 'package:aci_plus_app/home/views/home_page.dart';
import 'package:aci_plus_app/repositories/aci_device_repository.dart';
import 'package:aci_plus_app/repositories/code_repository.dart';
import 'package:aci_plus_app/repositories/config_repository.dart';
import 'package:aci_plus_app/repositories/dsim_repository.dart';
import 'package:aci_plus_app/repositories/amp18_ccor_node_repository.dart';
import 'package:aci_plus_app/repositories/amp18_repository.dart';
import 'package:aci_plus_app/repositories/gps_repository.dart';
import 'package:aci_plus_app/repositories/unit_repository.dart';
import 'package:aci_plus_app/repositories/firmware_repository.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.savedAdaptiveThemeMode,
    required this.aciDeviceRepository,
    required this.dsimRepository,
    required this.amp18Repository,
    required this.amp18CCorNodeRepository,
    required this.unitRepository,
    required this.gpsRepository,
    required this.configRepository,
    required this.firmwareRepository,
    required this.codeRepository,
  });

  final AdaptiveThemeMode savedAdaptiveThemeMode;
  final ACIDeviceRepository aciDeviceRepository;
  final DsimRepository dsimRepository;
  final Amp18Repository amp18Repository;
  final Amp18CCorNodeRepository amp18CCorNodeRepository;
  final UnitRepository unitRepository;
  final GPSRepository gpsRepository;
  final ConfigRepository configRepository;
  final FirmwareRepository firmwareRepository;
  final CodeRepository codeRepository;
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
        RepositoryProvider<CodeRepository>(
          create: (context) => codeRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => HomeBloc(
          aciDeviceRepository: aciDeviceRepository,
          dsimRepository: dsimRepository,
          amp18Repository: amp18Repository,
          amp18CCorNodeRepository: amp18CCorNodeRepository,
        ),
        child: _AppView(
          savedAdaptiveThemeMode: savedAdaptiveThemeMode,
        ),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView({
    required this.savedAdaptiveThemeMode,
  });

  final AdaptiveThemeMode savedAdaptiveThemeMode;

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   localizationsDelegates: AppLocalizations.localizationsDelegates,
    //   // locale: const Locale('en'),'
    //   localeResolutionCallback:
    //       (Locale? locale, Iterable<Locale> supportedLocales) {
    //     if (locale == null) {
    //       return supportedLocales.first;
    //     }

    //     // 檢查目前系統語言是否有支援
    //     for (Locale supportedLocale in supportedLocales) {
    //       if (supportedLocale.languageCode == locale.languageCode) {
    //         return supportedLocale;
    //       }
    //     }

    //     //  如果不支援目前系統語言, 則設為預設語言 English (US)
    //     return const Locale('en', 'US');
    //   },
    //   supportedLocales: const <Locale>[
    //     Locale('en', 'US'),
    //     Locale('es', 'ES'),
    //     Locale('fr', 'FR'),
    //     Locale('zh', 'TW'),
    //   ],

    //   theme: CustomTheme().lightTheme,
    //   darkTheme: CustomTheme().darkTheme,
    //   themeMode: ThemeMode.system,
    //   home: BlocBuilder<HomeBloc, HomeState>(
    //     buildWhen: (previous, current) =>
    //         previous.showSplash != current.showSplash,
    //     builder: (context, state) {
    //       if (state.showSplash) {
    //         return const Stack(
    //           children: [
    //             HomePage(),
    //             SplashScreen(),
    //           ],
    //         );
    //       } else {
    //         return const HomePage();
    //       }
    //     },
    //   ),
    // );

    return AdaptiveTheme(
      // debugShowFloatingThemeButton: true,
      light: CustomTheme().lightTheme,
      dark: CustomTheme().darkTheme,
      initial: savedAdaptiveThemeMode,
      builder: (light, dark) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        // locale: const Locale('en'),'
        localeResolutionCallback:
            (Locale? locale, Iterable<Locale> supportedLocales) {
          if (locale == null) {
            return supportedLocales.first;
          }

          // 檢查目前系統語言是否有支援
          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }

          //  如果不支援目前系統語言, 則設為預設語言 English (US)
          return const Locale('en', 'US');
        },
        supportedLocales: const <Locale>[
          Locale('en', 'US'),
          Locale('es', 'ES'),
          Locale('fr', 'FR'),
          Locale('zh', 'TW'),
        ],

        theme: light,
        darkTheme: dark,
        // themeMode: ThemeMode.light,
        // theme: ThemeData(
        //   cardTheme: const CardTheme(
        //     color: Colors.white,
        //   ),
        //   colorScheme: ColorScheme.fromSeed(
        //     brightness: Brightness.light,
        //     seedColor: Colors.indigo,
        //     primary: Colors.indigo,
        //     onPrimary: Colors.white,
        //     secondaryContainer: Colors.white,
        //     surfaceContainerLow: Colors.white, // default Card color
        //     surfaceContainerHighest: Colors.white,
        //     onSurface: Colors.black,
        //   ),
        //   appBarTheme: const AppBarTheme(
        //     iconTheme: IconThemeData(color: Colors.white),
        //     foregroundColor: Colors.white,
        //     backgroundColor: Colors.indigo,
        //   ),
        //   tabBarTheme: const TabBarTheme(
        //     tabAlignment: TabAlignment.start,
        //     unselectedLabelColor: Colors.white,
        //     labelColor: Colors.indigo,
        //     indicatorSize: TabBarIndicatorSize.tab,
        //     indicator: BoxDecoration(
        //       borderRadius: BorderRadius.only(
        //         topLeft: Radius.circular(10),
        //         topRight: Radius.circular(10),
        //       ),
        //       color: Colors.white,
        //     ),
        //     labelPadding: EdgeInsets.symmetric(horizontal: 24.0),
        //     dividerColor: Colors.white,
        //   ),
        //   cardColor: const Color.fromARGB(
        //       255, 167, 191, 219), // card tap color in setting page
        //   // cardColor: const Color.fromARGB(
        //   //     255, 255, 165, 45), // card tap color in setting page
        //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
        //     backgroundColor: Colors.white,
        //     selectedItemColor: Colors.indigo,
        //     unselectedItemColor: Colors.grey.shade700,
        //   ),
        //   elevatedButtonTheme: ElevatedButtonThemeData(
        //     style: ButtonStyle(
        //       elevation: WidgetStateProperty.resolveWith<double?>(
        //           (Set<WidgetState> states) {
        //         return 0.0;
        //       }),
        //       backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        //           (Set<WidgetState> states) {
        //         if (states.contains(WidgetState.disabled)) {
        //           return Colors.grey.shade300; // Disabled background color
        //         }
        //         return Colors.indigo; // Enabled background color
        //       }),
        //       foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        //           (Set<WidgetState> states) {
        //         if (states.contains(WidgetState.disabled)) {
        //           return Colors.grey.shade500; // Disabled text color
        //         }
        //         return Colors.white; // Enabled text color
        //       }),
        //     ),
        //   ),
        //   scaffoldBackgroundColor: Colors.grey.shade50,
        //   dialogBackgroundColor: Colors.grey.shade50,
        //   useMaterial3: true,
        // ),

        // darkTheme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(
        //     brightness: Brightness.dark,
        //     seedColor: Colors.indigo,
        //     primary: Colors.indigo,
        //     onPrimary: Colors.white,
        //     secondaryContainer: const Color(0xFF282A2F),
        //     surfaceContainerLow: const Color(0xFF282A2F), // default Card color
        //     surfaceContainerHighest: const Color(0xFF33353A),
        //     onSurface: Colors.white,
        //   ),
        //   appBarTheme: const AppBarTheme(
        //     iconTheme: IconThemeData(color: Colors.white),
        //     foregroundColor: Colors.white,
        //     backgroundColor: Colors.black,
        //   ),
        //   tabBarTheme: const TabBarTheme(
        //     tabAlignment: TabAlignment.start,
        //     unselectedLabelColor: Colors.white,
        //     labelColor: Colors.white,
        //     indicatorSize: TabBarIndicatorSize.tab,
        //     indicator: BoxDecoration(
        //       borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        //       color: Color(0xFF282A2F),
        //     ),
        //     labelPadding: EdgeInsets.symmetric(horizontal: 24.0),
        //     dividerHeight: 0.0,
        //   ),
        //   cardColor: const Color.fromARGB(
        //       255, 19, 48, 68), // card tap color in setting page
        //   // cardColor:
        //   //     const Color.fromARGB(255, 205, 75, 5), // card tap color in setting page
        //   scaffoldBackgroundColor: const Color(0xFF0C0E13),
        //   elevatedButtonTheme: ElevatedButtonThemeData(
        //     style: ButtonStyle(
        //       backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        //           (Set<WidgetState> states) {
        //         if (states.contains(WidgetState.disabled)) {
        //           return Colors.grey; // Disabled background color
        //         }
        //         return Colors.indigo; // Enabled background color
        //       }),
        //       foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        //           (Set<WidgetState> states) {
        //         if (states.contains(WidgetState.disabled)) {
        //           return Colors.white; // Disabled text color
        //         }
        //         return Colors.white; // Enabled text color
        //       }),
        //     ),
        //   ),
        //   dialogBackgroundColor: const Color(0xFF282A2F),
        //   useMaterial3: true,
        // ),

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

class CustomTheme {
  ThemeData lightTheme = ThemeData(
    cardTheme: const CardTheme(
      color: Colors.white,
    ),
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.indigo,
      primary: Colors.indigo,
      onPrimary: Colors.white,
      secondaryContainer: Colors.white,
      surfaceContainerLow: Colors.white, // default Card color
      surfaceContainerHighest: Colors.white,
      onSurface: Colors.black,
    ),

    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      foregroundColor: Colors.white,
      backgroundColor: Colors.indigo,
    ),
    tabBarTheme: const TabBarTheme(
      tabAlignment: TabAlignment.start,
      unselectedLabelColor: Colors.white,
      labelColor: Colors.indigo,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Colors.white,
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: 24.0),
      dividerColor: Colors.white,
    ),
    cardColor: const Color.fromARGB(
        255, 255, 165, 45), // card tap color in setting page
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.indigo,
      unselectedItemColor: Colors.grey.shade700,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation:
            WidgetStateProperty.resolveWith<double?>((Set<WidgetState> states) {
          return 0.0;
        }),
        backgroundColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.shade300; // Disabled background color
          }
          return Colors.indigo; // Enabled background color
        }),
        foregroundColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.shade500; // Disabled text color
          }
          return Colors.white; // Enabled text color
        }),
      ),
    ),
    scaffoldBackgroundColor: Colors.grey.shade50,
    dialogBackgroundColor: Colors.grey.shade50,
    useMaterial3: true,
  );

  ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.indigo,
      primary: Colors.indigo,
      onPrimary: Colors.white,
      secondaryContainer: const Color(0xFF282A2F),
      surfaceContainerLow: const Color(0xFF282A2F), // default Card color
      surfaceContainerHighest: const Color(0xFF33353A),
      onSurface: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
    ),
    tabBarTheme: const TabBarTheme(
      tabAlignment: TabAlignment.start,
      unselectedLabelColor: Colors.white,
      labelColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        color: Color(0xFF282A2F),
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: 24.0),
      dividerHeight: 0.0,
    ),
    cardColor:
        const Color.fromARGB(255, 205, 75, 5), // card tap color in setting page
    scaffoldBackgroundColor: const Color(0xFF0C0E13),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey; // Disabled background color
          }
          return Colors.indigo; // Enabled background color
        }),
        foregroundColor:
            WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.white; // Disabled text color
          }
          return Colors.white; // Enabled text color
        }),
      ),
    ),
    dialogBackgroundColor: const Color(0xFF282A2F),
    useMaterial3: true,
  );
}
