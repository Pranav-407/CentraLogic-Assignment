import 'package:flutter/material.dart';

import 'movie.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool isBookmarked = false;
  bool isInWatchlist = false;

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)?.settings.arguments as Movie? ??
        Movie(
          title: 'Inception',
          image: 'assets/images/inception.jpg',
          rating: 4.8,
          year: 2010,
          genre: 'Thriller',
        );

    final screenSize = MediaQuery.of(context).size;
    final isWeb = screenSize.width > 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isWeb ? _buildWebLayout(movie) : _buildMobileLayout(movie),
      ),
    );
  }

  Widget _buildWebLayout(Movie movie) {
    return Row(
      children: [
        // Left side - Movie poster
        Container(
          width: 400,
          child: _buildMoviePoster(movie),
        ),
        // Right side - Movie details
        Expanded(
          child: Container(
            padding: EdgeInsets.all(40),
            child: _buildMovieDetails(movie),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(Movie movie) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMoviePoster(movie),
          Container(
            padding: EdgeInsets.all(20),
            child: _buildMovieDetails(movie),
          ),
        ],
      ),
    );
  }

  Widget _buildMoviePoster(Movie movie) {
    return Container(
      height: MediaQuery.of(context).size.width > 800 ? 
        MediaQuery.of(context).size.height : 400,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(movie.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
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
        child: Stack(
          children: [
            // Back button
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            // Action buttons
            Positioned(
              top: 20,
              right: 20,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? Color(0xFFD4AF37) : Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isBookmarked = !isBookmarked;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.share, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            // Play button
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: IconButton(
                  icon: Icon(Icons.play_arrow, color: Colors.black, size: 40),
                  onPressed: () {
                    _showTrailerDialog();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieDetails(Movie movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Movie title and rating
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                movie.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.black, size: 16),
                  SizedBox(width: 4),
                  Text(
                    movie.rating.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        // Movie info
        Row(
          children: [
            Text(
              '${movie.year}',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(width: 20),
            Text(
              movie.genre,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(width: 20),
            Text(
              '2h 28m',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 30),
        // Synopsis
        Text(
          'Synopsis',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'A skilled thief, the absolute best in the dangerous art of extraction, '
          'stealing valuable secrets from deep within the subconscious during the '
          'dream state, when the mind is at its most vulnerable. Cobb\'s rare '
          'ability has made him a coveted player in this treacherous new world...',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        SizedBox(height: 30),
        // Action buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isInWatchlist = !isInWatchlist;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInWatchlist ? Colors.grey[700] : Color(0xFFD4AF37),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  isInWatchlist ? 'Remove from Watchlist' : 'Add to Watchlist',
                  style: TextStyle(
                    color: isInWatchlist ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 15),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD4AF37)),
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: Icon(Icons.download, color: Color(0xFFD4AF37)),
                onPressed: () {},
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        // Cast section
        Text(
          'Cast',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildCastItem(index);
            },
          ),
        ),
        SizedBox(height: 30),
        // Similar movies section
        Text(
          'Similar Movies',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildSimilarMovieCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCastItem(int index) {
    final castNames = ['Leonardo DiCaprio', 'Marion Cotillard', 'Tom Hardy', 'Elliot Page', 'Michael Caine'];
    
    return Container(
      width: 80,
      margin: EdgeInsets.only(right: 15),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[700],
            child: Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            castNames[index % castNames.length],
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarMovieCard(int index) {
    final similarMovies = [
      'The Matrix',
      'Interstellar',
      'Shutter Island',
    ];

    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[800],
            ),
            child: Center(
              child: Icon(
                Icons.movie,
                color: Colors.white54,
                size: 40,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            similarMovies[index],
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showTrailerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Movie Trailer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[900],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            color: Color(0xFFD4AF37),
                            size: 80,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Trailer would play here',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}