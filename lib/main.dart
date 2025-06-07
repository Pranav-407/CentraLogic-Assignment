import 'package:flutter/material.dart';
import 'view/splash_screen.dart';
import 'view/welcome_screen.dart';
import 'view/login_screen.dart';
import 'view/create_account_screen.dart';
import 'view/home_screen.dart';
import 'view/movie_details_screen.dart';
import 'view/bookmark_screen.dart';
import 'view/watchlist_screen.dart';
import 'view/search_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/create-account': (context) => CreateAccountScreen(),
        '/home': (context) => HomeScreen(),
        '/details': (context) => MovieDetailsScreen(),
        '/bookmarks': (context) => BookmarkScreen(),
        '/watchlist': (context) => WatchlistScreen(),
        '/search': (context) => SearchScreen(),
      },
    );
  }
}