import 'package:equatable/equatable.dart';

import '../../models/movie_model.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
}

class LoadFavorites extends FavoriteEvent {
  @override
  List<Object?> get props => [];
}

class AddToFavorites extends FavoriteEvent {
  final MovieModel movie;

  const AddToFavorites(this.movie);

  @override
  List<Object?> get props => [movie];
}

class RemoveFromFavorites extends FavoriteEvent {
  final MovieModel movie;

  const RemoveFromFavorites(this.movie);

  @override
  List<Object?> get props => [movie];
}
