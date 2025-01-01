import 'package:firebase_core/firebase_core.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:merhaba_app/firebase_options.dart';
import 'package:merhaba_app/providers/create_account_provider.dart';
import 'package:merhaba_app/providers/home_screen_provider.dart';
import 'package:merhaba_app/providers/login_provider.dart';
import 'package:merhaba_app/providers/profile_tab_provider.dart';
import 'package:merhaba_app/screens/authentication/create_account_screen.dart';
import 'package:merhaba_app/screens/authentication/login_screen.dart';
import 'package:merhaba_app/screens/general/home_screen.dart';
import 'package:merhaba_app/screens/general/welcome_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

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
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Merhaba App',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData.dark(),
    //   home: WelcomeScreen(),
    // );

    return FluentApp(
      title: 'Merhaba App',
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData.dark(),
      // home: WelcomeScreen(),
      initialRoute: "/",
      routes: {
        "/": (context) => WelcomeScreen(),
        "/login": (context) => LoginScreen(),
        "/create_account": (context) => CreateAccountScreen(),
        "/home": (context) => HomeScreen(),
      },
    );
  }
}
