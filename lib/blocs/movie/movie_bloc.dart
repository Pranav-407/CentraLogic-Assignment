import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import '../../models/movie_model.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  List<MovieModel> _allMovies = [];

  MovieBloc() : super(MovieInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<SearchMovies>(_onSearchMovies);
  }

  Future<void> _onLoadMovies(LoadMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final jsonString = await rootBundle.loadString('assets/movies.json');
      final List<dynamic> data = json.decode(jsonString);
      _allMovies = data.map((e) => MovieModel.fromJson(e)).toList();
      emit(MovieLoaded(allMovies: _allMovies, filteredMovies: _allMovies));
    } catch (e) {
      emit(MovieError('Failed to load movies'));
    }
  }

  void _onSearchMovies(SearchMovies event, Emitter<MovieState> emit) {
    if (state is MovieLoaded) {
      final filtered = _allMovies
          .where((movie) =>
              movie.title.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(MovieLoaded(allMovies: _allMovies, filteredMovies: filtered));
    }
  }
}
