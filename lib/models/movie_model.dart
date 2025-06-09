class MovieModel {
  final String title;
  final String posterUrl;
  final String description;
  final double rating;
  final String duration;
  final String genre;
  final String releaseDate;

  MovieModel({
    required this.title,
    required this.posterUrl,
    required this.description,
    required this.rating,
    required this.duration,
    required this.genre,
    required this.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json['title'],
      posterUrl: json['posterUrl'],
      description: json['description'],
      rating: (json['rating'] as num).toDouble(),
      duration: json['duration'],
      genre: json['genre'],
      releaseDate: json['releaseDate'],
    );
  }
}
