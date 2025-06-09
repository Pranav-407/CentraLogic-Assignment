import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../blocs/favourite/favourite_bloc.dart';
import '../../blocs/favourite/favourite_event.dart';
import '../../blocs/favourite/favourite_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Bookmark",
          style: GoogleFonts.montserrat(
            color: Color.fromRGBO(212, 175, 55, 1),
            fontWeight: FontWeight.w600,
            fontSize: 24
          ),
        ),
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          } else if (state is FavoriteLoaded) {
            if (state.favorites.isEmpty) {
              return const Center(
                child: Text(
                  'No bookmarked movies yet',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.favorites.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final movie = state.favorites[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[800]!, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Movie Poster
                        Container(
                          width: 125,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(movie.posterUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Movie Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Movie Title
                              Text(
                                movie.title,
                                style: GoogleFonts.montserrat(
                                    color: Color.fromRGBO(41, 121, 255, 1),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),

                              // Movie Genre and Year
                              Text(
                                '${movie.duration} • ${movie.genre}',
                                style: GoogleFonts.inter(
                                    color: Color.fromRGBO(217, 217, 217, 1),
                                    fontWeight: FontWeight.w500,
                                     fontStyle: FontStyle.italic,
                                    fontSize: 11),
                              ),
                              const SizedBox(height: 8),
                              
                              // Movie Description
                              Text(
                                movie.description.isNotEmpty
                                    ? movie.description
                                    : 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Viverra dignissim in ac elit. Nisi, et sed ut orci massa.',
                                style: GoogleFonts.roboto(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),

                              Text(
                                'Reviews',
                                style: GoogleFonts.openSans(
                                    color: Color.fromRGBO(74, 138, 196, 1),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12),
                              ),
                              const SizedBox(height: 8),

                              // Rating Stars
                              Row(
                                children: [
                                  // Star Rating
                                  Row(
                                    children: List.generate(5, (starIndex) {
                                      return Icon(
                                        Icons.star,
                                        size: 16,
                                        color: starIndex <
                                                (movie.rating).round()
                                            ? Colors.amber
                                            : Colors.grey[600],
                                      );
                                    }),
                                  ),
                                  const SizedBox(width: 8),

                                  // Rating Number
                                  Text(
                                    '(${movie.rating.toStringAsFixed(1)})',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        //Remove Button
                        Container (
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _showRemoveDialog(context, movie);
                            },
                            child: const Icon(
                              Icons.bookmark,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, movie) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Remove from Bookmarks?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to remove "${movie.title}" from your bookmarks?',
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<FavoriteBloc>().add(RemoveFromFavorites(movie));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed "${movie.title}" from Bookmarks'),
                    backgroundColor: Colors.grey[800],
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text(
                'Remove',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}