import 'dart:io';

import 'package:buffaloes_farm_management/constants/ColorConstants.dart';
import 'package:buffaloes_farm_management/constants/StyleConstants.dart';
import 'package:buffaloes_farm_management/cubit/home/home_cubit.dart';
import 'package:buffaloes_farm_management/pages/farm/farm_info_page.dart';
import 'package:buffaloes_farm_management/pages/loading/authenticate_loading_page.dart';
import 'package:buffaloes_farm_management/pages/home_page.dart';
import 'package:buffaloes_farm_management/pages/authentication/initial_farm_page.dart';
import 'package:buffaloes_farm_management/pages/authentication/login_page.dart';
import 'package:buffaloes_farm_management/pages/loading/main_initial_loading_page.dart';
import 'package:buffaloes_farm_management/pages/menu/farm_page.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'cubit/authentication/authentication_cubit.dart';
import 'cubit/service/service_cubit.dart';
import 'firebase_options.dart';

void main() async{
  Intl.defaultLocale = "th";

  WidgetsFlutterBinding.ensureInitialized();
  initialize();


  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.dark));
  runApp(RootApp());

}

Future<void> initialize() async {
  //await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    //webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );
  runApp(RootApp());
}

class RootApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(providers: [
      BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
      BlocProvider<AuthenticationCubit>(
          create: (context) => AuthenticationCubit()),
      BlocProvider<ServiceCubit>(create: (context) => ServiceCubit()),
    ], child: const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loaded = false;
  Color bgColor = bgButtonColor;
  TextEditingController numberController = TextEditingController();

  String? uid;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      fetchAll();
    });
  }

  Future<void> fetchAll() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        await FlutterDisplayMode.setHighRefreshRate();
      }
    }

    String? uid = await AuthenticationCubit().currentUserUid();

    setState(() {
      loaded = true;
      this.uid = uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      //print(FirebaseAuth.instance.currentUser?.uid);
      print(AuthenticationCubit().currentUserUid());

      context
          .read<AuthenticationCubit>()
          .checking(context, useNavigator: false);

      return MaterialApp(
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale.fromSubtags(languageCode: 'th')
          //Locale('en', 'US'), // English
        ],
        locale: const Locale.fromSubtags(languageCode: 'th'),
        debugShowCheckedModeBanner: false,
        home: uid != null ? FarmInfoPage() : LoginPage(),
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: "Itim",
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MainInitialLoadingPage(),
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: "Itim",
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      );
    }
  }
}
