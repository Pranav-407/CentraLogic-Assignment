import 'package:equatable/equatable.dart';

import '../../models/movie_model.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();
}

class WatchlistLoading extends WatchlistState {
  @override
  List<Object?> get props => [];
}

class WatchlistLoaded extends WatchlistState {
  final List<MovieModel> movies;

  const WatchlistLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}
