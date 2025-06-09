import 'package:equatable/equatable.dart';

import '../../models/movie_model.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();
}

class LoadWatchlist extends WatchlistEvent {
  const LoadWatchlist();

  @override
  List<Object?> get props => [];
}

class AddToWatchlist extends WatchlistEvent {
  final MovieModel movie;

  const AddToWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}

class RemoveFromWatchlist extends WatchlistEvent {
  final MovieModel movie;

  const RemoveFromWatchlist(this.movie);

  @override
  List<Object?> get props => [movie];
}
