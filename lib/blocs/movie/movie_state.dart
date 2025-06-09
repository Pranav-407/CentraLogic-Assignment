import 'package:equatable/equatable.dart';

import '../../models/movie_model.dart';

abstract class MovieState extends Equatable {
  const MovieState();
}

class MovieInitial extends MovieState {
  @override
  List<Object?> get props => [];
}

class MovieLoading extends MovieState {
  @override
  List<Object?> get props => [];
}

class MovieLoaded extends MovieState {
  final List<MovieModel> allMovies;
  final List<MovieModel> filteredMovies;

  const MovieLoaded({required this.allMovies, required this.filteredMovies});

  @override
  List<Object?> get props => [allMovies, filteredMovies];
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object?> get props => [message];
}
