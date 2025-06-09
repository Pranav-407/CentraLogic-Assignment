import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/movie_model.dart';
import 'favourite_event.dart';
import 'favourite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  static const _key = 'favorites';

  FavoriteBloc() : super(FavoriteLoading()) {
    on<LoadFavorites>(_onLoad);
    on<AddToFavorites>(_onAdd);
    on<RemoveFromFavorites>(_onRemove);
  }

  Future<void> _onLoad(LoadFavorites event, Emitter emit) async {
    emit(FavoriteLoading());
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_key) ?? [];
    final favorites = stored
        .map((jsonStr) => MovieModel.fromJson(json.decode(jsonStr)))
        .toList();
    emit(FavoriteLoaded(favorites));
  }

  Future<void> _onAdd(AddToFavorites event, Emitter emit) async {
    if (state is FavoriteLoaded) {
      final current = (state as FavoriteLoaded).favorites;
      if (current.any((m) => m.title == event.movie.title)) return;

      final updated = [...current, event.movie];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _key,
        updated.map((m) => json.encode(_toJson(m))).toList(),
      );
      emit(FavoriteLoaded(updated));
    }
  }

  Future<void> _onRemove(RemoveFromFavorites event, Emitter emit) async {
    if (state is FavoriteLoaded) {
      final current = (state as FavoriteLoaded).favorites;
      final updated = current.where((m) => m.title != event.movie.title).toList();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _key,
        updated.map((m) => json.encode(_toJson(m))).toList(),
      );
      emit(FavoriteLoaded(updated));
    }
  }

  Map<String, dynamic> _toJson(MovieModel m) => {
        'title': m.title,
        'posterUrl': m.posterUrl,
        'description': m.description,
        'rating': m.rating,
        'duration': m.duration,
        'genre': m.genre,
        'releaseDate': m.releaseDate,
      };
}
