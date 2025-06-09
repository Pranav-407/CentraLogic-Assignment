import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();
}

class LoadMovies extends MovieEvent {
  const LoadMovies();

  @override
  List<Object?> get props => [];
}

class SearchMovies extends MovieEvent {
  final String query;

  const SearchMovies(this.query);

  @override
  List<Object?> get props => [query];
}
