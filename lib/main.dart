import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merhaba_app/firebase_options.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/providers/app_settings_provider.dart';
import 'package:merhaba_app/providers/create_account_provider.dart';
import 'package:merhaba_app/providers/home_screen_provider.dart';
import 'package:merhaba_app/providers/location_viewer_provider.dart';
import 'package:merhaba_app/providers/login_provider.dart';
import 'package:merhaba_app/providers/new_post_provider.dart';
import 'package:merhaba_app/providers/post_provider.dart';
import 'package:merhaba_app/providers/profile_tab_provider.dart';
import 'package:merhaba_app/providers/timeline_provider.dart';
import 'package:merhaba_app/screens/authentication/create_account_screen.dart';
import 'package:merhaba_app/screens/authentication/login_screen.dart';
import 'package:merhaba_app/screens/general/home_screen.dart';
import 'package:merhaba_app/screens/general/welcome_screen.dart';
import 'package:merhaba_app/screens/location/location_viewer.dart';
import 'package:merhaba_app/screens/posts/post_screen.dart';
import 'package:merhaba_app/screens/tabs/home/new_post_screen.dart';
import 'package:merhaba_app/screens/tabs/profile/app_settings_screen.dart';
import 'package:merhaba_app/utils/globals.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fluent_ui/fluent_ui.dart' as fluent;

final FlutterLocalization localization = FlutterLocalization.instance;
final FlutterSecureStorage secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ),
  iOptions: IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print(e.toString());
  }

  try {
    await Supabase.initialize(
      url: dotenv.env["SUPABASE_URL"].toString(),
      anonKey: dotenv.env["SUPABASE_KEY"].toString(),
    );
  } catch (e) {
    print(e.toString());
  }

  try {
    await FlutterLocalization.instance.ensureInitialized();
  } catch (e) {
    print(e.toString());
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print(e.toString());
  }

  try {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode != null) {
      if (savedThemeMode == AdaptiveThemeMode.light) {
        Globals.theme = "Light";
      } else {
        Globals.theme = "Dark";
      }
    }
  } catch (e) {
    print(e.toString());
  }

  try {
    timeago.setLocaleMessages(
        'ar', timeago.ArMessages()); // Add french messages
  } catch (e) {
    print(e.toString());
  }

  // runApp(const MyApp());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => LoginProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => CreateAccountProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => HomeScreenProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProfileTabProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AppSettingsProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => NewPostProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LocationViewerProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => TimelineProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => PostProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  fluent.Typography typography = const fluent.Typography.raw(
    body: TextStyle(
      fontFamily: "KingsguardCalligraphy",
    ),
    bodyLarge: TextStyle(
      fontFamily: "KingsguardCalligraphy",
    ),
    bodyStrong: TextStyle(
      fontFamily: "KingsguardCalligraphy",
    ),
    caption: TextStyle(
      fontFamily: "KingsguardCalligraphy",
    ),
    display: TextStyle(
      fontFamily: "KingsguardCalligraphy",
    ),
    subtitle: TextStyle(
      fontFamily: "KingsguardCalligraphy",
    ),
    title: TextStyle(
      fontFamily: "KingsguardCalligraphy",
    ),
    titleLarge: TextStyle(
      fontFamily: "KingsguardCalligraphy",
    ),
  );

  @override
  void initState() {
    localization.init(
      mapLocales: [
        const MapLocale('en', AppLocale.EN),
        const MapLocale('ar', AppLocale.AR),
      ],
      initLanguageCode: 'en',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

// the setState function here is a must to add
  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Merhaba App',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData.dark(),
    //   home: WelcomeScreen(),
    // );

    // return FluentApp(
    //   title: 'Merhaba App',
    //   debugShowCheckedModeBanner: false,
    //   theme: FluentThemeData.dark(),
    //   // home: WelcomeScreen(),
    //   initialRoute: "/",
    //   routes: {
    //     "/": (context) => WelcomeScreen(),
    //     "/login": (context) => LoginScreen(),
    //     "/create_account": (context) => CreateAccountScreen(),
    //     "/home": (context) => HomeScreen(),
    //     "/app_settings": (context) => AppSettingsScreen(),
    //   },
    // );

    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData.dark(useMaterial3: true),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => FluentApp(
        title: 'Merhaba App',
        debugShowCheckedModeBanner: false,
        theme: theme == ThemeData.light(useMaterial3: true)
            ? FluentThemeData.light().copyWith(
                // typography: typography,
                )
            : FluentThemeData.dark().copyWith(
                // typography: typography,
                ),
        darkTheme: darkTheme == ThemeData.dark(useMaterial3: true)
            ? FluentThemeData.dark().copyWith(
                // typography: typography,
                )
            : FluentThemeData.light().copyWith(
                // typography: typography,
                ),
        // theme: FluentThemeData.dark(),
        // home: WelcomeScreen(),
        supportedLocales: localization.supportedLocales,
        localizationsDelegates: localization.localizationsDelegates,
        initialRoute: "/",
        routes: {
          "/": (context) => WelcomeScreen(),
          "/login": (context) => LoginScreen(),
          "/create_account": (context) => CreateAccountScreen(),
          "/home": (context) => HomeScreen(),
          "/app_settings": (context) => AppSettingsScreen(),
          "/new_post": (context) => NewPostScreen(),
          "/location_viewer": (context) => LocationViewerScreen(),
          "/view_post": (context) => PostScreen(),
        },
      ),
    );
  }
}
