import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/watchlist/watchlist_bloc.dart';
import '../../blocs/watchlist/watchlist_event.dart';
import '../../blocs/watchlist/watchlist_state.dart';
import '../movie_detail/movie_detail_screen.dart';

class WatchlistScreen extends StatelessWidget {
  static const String routeName = '/watchlist';
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Watchlist",
          style: GoogleFonts.montserrat(
            color: Color.fromRGBO(212, 175, 55, 1),
            fontWeight: FontWeight.w600,
            fontSize: _getAppBarTitleSize(context)
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Main Content
            Expanded(
              child: BlocBuilder<WatchlistBloc, WatchlistState>(
                builder: (context, state) {
                  if (state is WatchlistLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                        strokeWidth: _isWeb(context) ? 3.0 : 2.0,
                      ),
                    );
                  } else if (state is WatchlistLoaded) {
                    if (state.movies.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.movie_outlined,
                              size: _getEmptyStateIconSize(context),
                              color: Colors.grey,
                            ),
                            SizedBox(height: _isWeb(context) ? 24 : 16),
                            Text(
                              'No movies in watchlist',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: _getEmptyStateTitleSize(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: _isWeb(context) ? 12 : 8),
                            Text(
                              'Add movies to your watchlist to see them here',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: _getEmptyStateSubtitleSize(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: _getMaxContentWidth(context),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getHorizontalPadding(context),
                          ),
                          child: _isWeb(context) 
                            ? _buildWebGridView(state.movies, context)
                            : _buildMobileListView(state.movies, context),
                        ),
                      ),
                    );
                  } else if (state is WatchlistError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: _getErrorIconSize(context),
                            color: Colors.red,
                          ),
                          SizedBox(height: _isWeb(context) ? 24 : 16),
                          Text(
                            'Error loading watchlist',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _getErrorTitleSize(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: _isWeb(context) ? 12 : 8),
                          Text(
                            state.message,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: _getErrorMessageSize(context),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: _isWeb(context) ? 20 : 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<WatchlistBloc>().add(LoadWatchlist());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                horizontal: _isWeb(context) ? 32 : 24,
                                vertical: _isWeb(context) ? 16 : 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Retry',
                              style: TextStyle(
                                fontSize: _isWeb(context) ? 16 : 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Something went wrong',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _isWeb(context) ? 18 : 16,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileListView(List movies, BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: _buildMovieCard(movie, context, 230),
        );
      },
    );
  }

  Widget _buildWebGridView(List movies, BuildContext context) {
    final crossAxisCount = _getCrossAxisCount(context);
    
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: _getChildAspectRatio(context),
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _buildMovieCard(movie, context, _getCardHeight(context));
      },
    );
  }

  Widget _buildMovieCard(movie, BuildContext context, double height) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailScreen(movie: movie),
          ),
        );
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(212, 175, 55, 1),
            width: _isWeb(context) ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(_isWeb(context) ? 16 : 12),
          image: DecorationImage(
            image: NetworkImage(movie.posterUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_isWeb(context) ? 16 : 12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Movie Info
              Positioned(
                bottom: _isWeb(context) ? 12 : 8,
                left: _isWeb(context) ? 20 : 16,
                right: _isWeb(context) ? 80 : 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _getMovieTitleSize(context),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: _isWeb(context) ? 6 : 0),
                    Text(
                      '${movie.duration} • ${movie.genre}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: _getMovieSubtitleSize(context),
                      ),
                    ),
                    SizedBox(height: _isWeb(context) ? 4 : 2),
                    // Rating
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: _getStarIconSize(context),
                        ),
                        SizedBox(width: _isWeb(context) ? 6 : 4),
                        Text(
                          movie.rating.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _getRatingTextSize(context),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Remove Button
              Positioned(
                top: _isWeb(context) ? 16 : 12,
                right: _isWeb(context) ? 16 : 12,
                child: GestureDetector(
                  onTap: () {
                    _showRemoveDialog(context, movie);
                  },
                  child: Container(
                    padding: EdgeInsets.all(_isWeb(context) ? 10 : 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(_isWeb(context) ? 24 : 20),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: _getCloseIconSize(context),
                    ),
                  ),
                ),
              ),
              
              // Play Button Overlay
              Center(
                child: Container(
                  padding: EdgeInsets.all(_getPlayButtonPadding(context)),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(_getPlayButtonRadius(context)),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: _getPlayIconSize(context),
                  ),
                ),
              ),
            ],
          ),
        ),
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
            borderRadius: BorderRadius.circular(_isWeb(context) ? 16 : 12),
          ),
          title: Text(
            'Remove from Watchlist?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: _getDialogTitleSize(context),
            ),
          ),
          content: Text(
            'Are you sure you want to remove "${movie.title}" from your watchlist?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: _getDialogContentSize(context),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: _getDialogButtonSize(context),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<WatchlistBloc>().add(RemoveFromWatchlist(movie));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Removed "${movie.title}" from Watchlist',
                      style: TextStyle(
                        fontSize: _getSnackBarTextSize(context),
                      ),
                    ),
                    backgroundColor: Colors.grey[800],
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'Remove',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: _getDialogButtonSize(context),
                ),
              ),
            ),
          ],
        );
      },
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

  // Layout helpers
  int _getCrossAxisCount(BuildContext context) {
    if (_isDesktop(context)) return 4;
    if (_isTablet(context)) return 3;
    return 2;
  }

  double _getChildAspectRatio(BuildContext context) {
    if (_isDesktop(context)) return 0.7;
    if (_isTablet(context)) return 0.75;
    return 0.8;
  }

  double _getMaxContentWidth(BuildContext context) {
    if (_isDesktop(context)) return 1400;
    if (_isTablet(context)) return 1000;
    return double.infinity;
  }

  double _getHorizontalPadding(BuildContext context) {
    if (_isDesktop(context)) return 32.0;
    if (_isTablet(context)) return 24.0;
    return 16.0;
  }

  double _getCardHeight(BuildContext context) {
    if (_isDesktop(context)) return 320;
    if (_isTablet(context)) return 280;
    return 230;
  }

  // Font size helpers
  double _getAppBarTitleSize(BuildContext context) {
    if (_isDesktop(context)) return 28;
    if (_isTablet(context)) return 26;
    return 24;
  }

  double _getEmptyStateIconSize(BuildContext context) {
    if (_isDesktop(context)) return 120;
    if (_isTablet(context)) return 100;
    return 80;
  }

  double _getEmptyStateTitleSize(BuildContext context) {
    if (_isDesktop(context)) return 22;
    if (_isTablet(context)) return 20;
    return 18;
  }

  double _getEmptyStateSubtitleSize(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 15;
    return 14;
  }

  double _getErrorIconSize(BuildContext context) {
    if (_isDesktop(context)) return 80;
    if (_isTablet(context)) return 70;
    return 60;
  }

  double _getErrorTitleSize(BuildContext context) {
    if (_isDesktop(context)) return 22;
    if (_isTablet(context)) return 20;
    return 18;
  }

  double _getErrorMessageSize(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 15;
    return 14;
  }

  double _getMovieTitleSize(BuildContext context) {
    if (_isDesktop(context)) return 24;
    if (_isTablet(context)) return 22;
    return 20;
  }

  double _getMovieSubtitleSize(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 15;
    return 14;
  }

  double _getStarIconSize(BuildContext context) {
    if (_isDesktop(context)) return 20;
    if (_isTablet(context)) return 18;
    return 16;
  }

  double _getRatingTextSize(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 15;
    return 14;
  }

  double _getCloseIconSize(BuildContext context) {
    if (_isDesktop(context)) return 20;
    if (_isTablet(context)) return 18;
    return 16;
  }

  double _getPlayButtonPadding(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 14;
    return 12;
  }

  double _getPlayButtonRadius(BuildContext context) {
    if (_isDesktop(context)) return 40;
    if (_isTablet(context)) return 35;
    return 30;
  }

  double _getPlayIconSize(BuildContext context) {
    if (_isDesktop(context)) return 32;
    if (_isTablet(context)) return 28;
    return 24;
  }

  double _getDialogTitleSize(BuildContext context) {
    if (_isDesktop(context)) return 20;
    if (_isTablet(context)) return 19;
    return 18;
  }

  double _getDialogContentSize(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 15;
    return 14;
  }

  double _getDialogButtonSize(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 15;
    return 14;
  }

  double _getSnackBarTextSize(BuildContext context) {
    if (_isDesktop(context)) return 16;
    if (_isTablet(context)) return 15;
    return 14;
  }
}