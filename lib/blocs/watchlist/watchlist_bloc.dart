import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/movie_model.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  static const _key = 'watchlist';

  WatchlistBloc() : super(WatchlistLoading()) {
    on<LoadWatchlist>(_onLoad);
    on<AddToWatchlist>(_onAdd);
    on<RemoveFromWatchlist>(_onRemove);
  }

  Future<void> _onLoad(LoadWatchlist event, Emitter emit) async {
    emit(WatchlistLoading());
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList(_key) ?? [];
    final List<MovieModel> movies =
        saved.map((e) => MovieModel.fromJson(json.decode(e))).toList();
    emit(WatchlistLoaded(movies));
  }

  Future<void> _onAdd(AddToWatchlist event, Emitter emit) async {
    final alreadyExists = (state as WatchlistLoaded)
        .movies
        .any((m) => m.title == event.movie.title);
    if (alreadyExists) return;

    if (state is WatchlistLoaded) {
      final prefs = await SharedPreferences.getInstance();
      final List<MovieModel> updated =
          List.from((state as WatchlistLoaded).movies)..add(event.movie);
      final jsonList = updated.map((e) => json.encode(_movieToMap(e))).toList();
      await prefs.setStringList(_key, jsonList);
      emit(WatchlistLoaded(updated));
    }
  }

  Future<void> _onRemove(RemoveFromWatchlist event, Emitter emit) async {
    if (state is WatchlistLoaded) {
      final prefs = await SharedPreferences.getInstance();
      final updated = List<MovieModel>.from((state as WatchlistLoaded).movies)
        ..removeWhere((m) => m.title == event.movie.title);
      final jsonList = updated.map((e) => json.encode(_movieToMap(e))).toList();
      await prefs.setStringList(_key, jsonList);
      emit(WatchlistLoaded(updated));
    }
  }

  Map<String, dynamic> _movieToMap(MovieModel m) => {
        'title': m.title,
        'posterUrl': m.posterUrl,
        'description': m.description,
        'rating': m.rating,
        'duration': m.duration,
        'genre': m.genre,
        'releaseDate': m.releaseDate,
      };
}
