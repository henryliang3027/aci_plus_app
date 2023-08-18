import 'package:dsim_app/home/bloc/home_bloc/home_bloc.dart';
import 'package:dsim_app/home/views/home_page.dart';
import 'package:dsim_app/repositories/dsim_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.dsimRepository,
  });

  final DsimRepository dsimRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DsimRepository>(
          create: (context) => dsimRepository,
        )
      ],
      child: BlocProvider(
        create: (context) => HomeBloc(
          dsimRepository: dsimRepository,
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
      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('es'),
        Locale('zh'),
        Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant'), //to use traditional chinese datepicker
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
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Image.asset(
        'assets/splash.gif',
        fit: BoxFit.fill,
        // errorBuilder: (context, error, stackTrace) {
        //   return Container();
        // },
      ),
    );
  }
}
