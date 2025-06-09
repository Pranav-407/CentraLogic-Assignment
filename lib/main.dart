
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'blocs/favourite/favourite_bloc.dart';
import 'blocs/favourite/favourite_event.dart';
import 'blocs/movie/movie_bloc.dart';
import 'blocs/movie/movie_event.dart';
import 'blocs/watchlist/watchlist_bloc.dart';
import 'blocs/watchlist/watchlist_event.dart';
import 'screens/splash/splash_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDq9Tvtfh6HepUpmz088dhyoGdXz13R7ag",
      appId: "1:1011696242795:android:9fd9876c6293307245612e",
      messagingSenderId: "1011696242795",
      projectId: 'centralogic-c4d4a',
    ),
  );
  runApp(const MovieSearchApp());
}

class MovieSearchApp extends StatelessWidget {
  const MovieSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieBloc>(
          create: (_) => MovieBloc()..add(const LoadMovies()),
        ),
        BlocProvider<WatchlistBloc>(
          create: (_) => WatchlistBloc()..add(const LoadWatchlist()),
        ),
        BlocProvider<FavoriteBloc>(
          create: (_) => FavoriteBloc()..add(LoadFavorites()),
        ),
      ],
      child: MaterialApp(
        builder: (context, child) => ResponsiveBreakpoints.builder(
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          ],
          child: child!,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
