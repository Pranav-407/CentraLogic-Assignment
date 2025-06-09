import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/favourite/favourite_bloc.dart';
import '../../blocs/favourite/favourite_event.dart';
import '../../blocs/favourite/favourite_state.dart';
import '../../blocs/watchlist/watchlist_bloc.dart';
import '../../blocs/watchlist/watchlist_event.dart';
import '../../blocs/watchlist/watchlist_state.dart';
import '../../models/movie_model.dart';

class MovieDetailScreen extends StatelessWidget {
  
  final MovieModel movie;

  const MovieDetailScreen({super.key, required this.movie});

  String _getReleaseDateText(String releaseDate) {
    try {
      // Parse the release date string to DateTime
      DateTime releaseDateTime = DateTime.parse(releaseDate);
      DateTime now = DateTime.now();

      // Compare with current date
      if (releaseDateTime.isAfter(now)) {
        return 'Releasing on $releaseDate';
      } else {
        return 'Released on $releaseDate';
      }
    } catch (e) {
      // If parsing fails, default to "Releasing on"
      return 'Releasing on $releaseDate';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: Colors.white,
            size: _getIconSize(context),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: _getAppBarTitleSize(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              final isFav = state is FavoriteLoaded &&
                  state.favorites.any((m) => m.title == movie.title);

              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.amber,
                  size: _getIconSize(context),
                ),
                onPressed: () {
                  if (isFav) {
                    context
                        .read<FavoriteBloc>()
                        .add(RemoveFromFavorites(movie));
                  } else {
                    context.read<FavoriteBloc>().add(AddToFavorites(movie));
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFav ? 'Removed from Favorites' : 'Added to Favorites',
                        style: TextStyle(fontSize: _getSnackBarTextSize(context)),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share, 
              color: Colors.white,
              size: _getIconSize(context),
            ),
            onPressed: () {
              // Add share functionality
            },
          ),
        ],
      ),
      body: _isWeb(context) ? _buildWebLayout(context) : _buildMobileLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMoviePoster(context),
          const SizedBox(height: 20),
          _buildMovieInfo(context),
          const SizedBox(height: 32),
          _buildActionButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: _getMaxContentWidth(context)),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(_getContentPadding(context)),
          child: _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Movie poster
        Expanded(
          flex: 2,
          child: _buildMoviePoster(context),
        ),
        SizedBox(width: _getHorizontalSpacing(context)),
        // Right side - Movie info and actions
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMovieInfo(context),
              SizedBox(height: _getVerticalSpacing(context) * 1.5),
              _buildActionButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoviePoster(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _getPosterHeight(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_getBorderRadius(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: _isWeb(context) ? 3 : 2,
            blurRadius: _isWeb(context) ? 12 : 8,
            offset: Offset(0, _isWeb(context) ? 6 : 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_getBorderRadius(context)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[800],
                child: Icon(
                  Icons.image,
                  size: _getErrorIconSize(context),
                  color: Colors.grey,
                ),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Release date positioned at bottom
            Positioned(
              bottom: _getReleaseDateBottomPosition(context),
              left: _getReleaseDateLeftPosition(context),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _getReleaseDateHorizontalPadding(context),
                  vertical: _getReleaseDateVerticalPadding(context),
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(_getReleaseDateBorderRadius(context)),
                ),
                child: Text(
                  _getReleaseDateText(movie.releaseDate),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _getReleaseDateTextSize(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Movie title
        Text(
          movie.title,
          style: GoogleFonts.montserrat(
            color: Color.fromRGBO(41, 121, 255, 1),
            fontWeight: FontWeight.w600,
            fontSize: _getMovieTitleSize(context),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: _getSmallVerticalSpacing(context)),

        Text(
          '${movie.duration} • ${movie.genre}',
          style: GoogleFonts.inter(
            color: Color.fromRGBO(217, 217, 217, 1),
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
            fontSize: _getMovieSubtitleSize(context),
          ),
        ),

        SizedBox(height: _getVerticalSpacing(context)),

        // Description
        Text(
          movie.description,
          style: GoogleFonts.inter(
            color: Color.fromRGBO(217, 217, 217, 1),
            fontWeight: FontWeight.w400,
            fontSize: _getDescriptionSize(context),
            height: 1.5,
          ),
        ),

        SizedBox(height: _getVerticalSpacing(context)),

        Text(
          'Reviews',
          style: GoogleFonts.openSans(
            color: Color.fromRGBO(41, 121, 255, 1),
            fontWeight: FontWeight.w700,
            fontSize: _getReviewTitleSize(context),
          ),
        ),

        SizedBox(height: _getSmallVerticalSpacing(context)),

        // Rating stars
        Row(
          children: [
            ...List.generate(5, (index) {
              return Icon(
                index < movie.rating.floor()
                    ? Icons.star
                    : Icons.star_border,
                color: Colors.amber,
                size: _getStarSize(context),
              );
            }),
            SizedBox(width: _getSmallHorizontalSpacing(context)),
            Text(
              '(${movie.rating})',
              style: TextStyle(
                color: Colors.white,
                fontSize: _getRatingTextSize(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          final isInWatchlist = state is WatchlistLoaded &&
              state.movies.any((m) => m.title == movie.title);

          return ElevatedButton(
            onPressed: isInWatchlist
                ? null
                : () {
                    context
                        .read<WatchlistBloc>()
                        .add(AddToWatchlist(movie));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added to Watchlist',
                          style: TextStyle(fontSize: _getSnackBarTextSize(context)),
                        ),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isInWatchlist ? Colors.grey[700] : Colors.amber,
              foregroundColor: isInWatchlist
                  ? Colors.black // Force black text when disabled
                  : Colors.black,
              disabledBackgroundColor:
                  Colors.grey[700], // Darker grey background
              disabledForegroundColor:
                  Colors.black, // Black text when disabled
              padding: EdgeInsets.symmetric(vertical: _getButtonVerticalPadding(context)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_getBorderRadius(context)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isInWatchlist ? Icons.check_circle : Icons.add,
                  size: _getButtonIconSize(context),
                ),
                SizedBox(width: _getSmallHorizontalSpacing(context)),
                Text(
                  isInWatchlist
                      ? 'Added to Watchlist'
                      : 'Add to Watchlist',
                  style: TextStyle(
                    fontSize: _getButtonTextSize(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper methods for responsive design
  bool _isWeb(BuildContext context) {
    return MediaQuery.of(context).size.width > 768;
  }

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 768 && width <= 1024;
  }

  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > 1024;
  }

  // Layout dimensions
  double _getMaxContentWidth(BuildContext context) {
    if (_isDesktop(context)) return 1200;
    if (_isTablet(context)) return 800;
    return double.infinity;
  }

  double _getContentPadding(BuildContext context) {
    if (_isDesktop(context)) return 32.0;
    if (_isTablet(context)) return 24.0;
    return 16.0;
  }

  double _getPosterHeight(BuildContext context) {
    if (_isDesktop(context)) return 400;
    if (_isTablet(context)) return 300;
    return 200;
  }

  double _getBorderRadius(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 14;
    return 12;
  }

  double _getVerticalSpacing(BuildContext context) {
    if (_isDesktop(context)) return 24;
    if (_isTablet(context)) return 20;
    return 16;
  }

  double _getSmallVerticalSpacing(BuildContext context) {
    if (_isDesktop(context)) return 12;
    if (_isTablet(context)) return 10;
    return 8;
  }

  double _getHorizontalSpacing(BuildContext context) {
    if (_isDesktop(context)) return 48;
    if (_isTablet(context)) return 32;
    return 24;
  }

  double _getSmallHorizontalSpacing(BuildContext context) {
    if (_isDesktop(context)) return 12;
    if (_isTablet(context)) return 10;
    return 8;
  }

  // Typography sizes
  double _getAppBarTitleSize(BuildContext context) {
    if (_isDesktop(context)) return 22;
    if (_isTablet(context)) return 20;
    return 18;
  }

  double _getMovieTitleSize(BuildContext context) {
    if (_isDesktop(context)) return 32;
    if (_isTablet(context)) return 28;
    return 24;
  }

  double _getMovieSubtitleSize(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 15;
    return 13;
  }

  double _getDescriptionSize(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 15;
    return 13;
  }

  double _getReviewTitleSize(BuildContext context) {
    if (_isDesktop(context)) return 24;
    if (_isTablet(context)) return 22;
    return 20;
  }

  double _getRatingTextSize(BuildContext context) {
    if (_isDesktop(context)) return 18;
    if (_isTablet(context)) return 17;
    return 16;
  }

  double _getButtonTextSize(BuildContext context) {
    if (_isDesktop(context)) return 18;
    if (_isTablet(context)) return 17;
    return 16;
  }

  double _getSnackBarTextSize(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 15;
    return 14;
  }

  double _getReleaseDateTextSize(BuildContext context) {
    if (_isDesktop(context)) return 14;
    if (_isTablet(context)) return 13;
    return 12;
  }

  // Icon sizes
  double _getIconSize(BuildContext context) {
    if (_isDesktop(context)) return 28;
    if (_isTablet(context)) return 26;
    return 24;
  }

  double _getStarSize(BuildContext context) {
    if (_isDesktop(context)) return 26;
    if (_isTablet(context)) return 24;
    return 22;
  }

  double _getButtonIconSize(BuildContext context) {
    if (_isDesktop(context)) return 24;
    if (_isTablet(context)) return 22;
    return 20;
  }

  double _getErrorIconSize(BuildContext context) {
    if (_isDesktop(context)) return 120;
    if (_isTablet(context)) return 110;
    return 100;
  }

  // Release date badge positioning and styling
  double _getReleaseDateBottomPosition(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 14;
    return 12;
  }

  double _getReleaseDateLeftPosition(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 14;
    return 12;
  }

  double _getReleaseDateHorizontalPadding(BuildContext context) {
    if (_isDesktop(context)) return 12;
    if (_isTablet(context)) return 10;
    return 8;
  }

  double _getReleaseDateVerticalPadding(BuildContext context) {
    if (_isDesktop(context)) return 6;
    if (_isTablet(context)) return 5;
    return 4;
  }

  double _getReleaseDateBorderRadius(BuildContext context) {
    if (_isDesktop(context)) return 8;
    if (_isTablet(context)) return 7;
    return 6;
  }

  double _getButtonVerticalPadding(BuildContext context) {
    if (_isDesktop(context)) return 20;
    if (_isTablet(context)) return 18;
    return 16;
  }
}