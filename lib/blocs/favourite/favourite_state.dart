import 'package:equatable/equatable.dart';

import '../../models/movie_model.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();
}

class FavoriteLoading extends FavoriteState {
  @override
  List<Object?> get props => [];
}

class FavoriteLoaded extends FavoriteState {
  final List<MovieModel> favorites;

  const FavoriteLoaded(this.favorites);

  @override
  List<Object?> get props => [favorites];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}
