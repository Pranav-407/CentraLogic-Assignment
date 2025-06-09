import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../blocs/movie/movie_bloc.dart';
import '../../blocs/movie/movie_event.dart';
import '../../blocs/movie/movie_state.dart';
import '../../models/movie_model.dart';
import '../favourites/favourites_screen.dart';
import '../home/home_screen.dart';
import '../movie_detail/movie_detail_screen.dart';
import '../watchlist/watchlist_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    WatchlistScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isLargeScreen = constraints.maxWidth > 800;
          
          if (isLargeScreen) {
            return _buildWebLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      children: [
        // Sidebar
        Container(
          width: 250,
          color: const Color(0xFFFFB000), // Amber color
          child: Column(
            children: [
              SvgPicture.asset("assets/svg/logo.svg",height: 200,),
              // Navigation items
              Expanded(
                child: Column(
                  children: [
                    _buildNavItem(Icons.home, 'Home', 0),
                    _buildNavItem(Icons.video_library, 'Watchlist', 1),
                    _buildNavItem(Icons.bookmark, 'Bookmarks', 2),
                    _buildNavItem(Icons.person, 'Profile', 3),
                    const Spacer(),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Main content
        Expanded(
          child: SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens.map((screen) {
                
                if (screen is HomeScreen) {
                  return HomeScreenContent(isWeb: true);
                } else {
                  return screen;
                }
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens.map((screen) {
                // Pass the mobile layout flag to screens that need it
                if (screen is HomeScreen) {
                  return HomeScreenContent(isWeb: false);
                } else {
                  return screen;
                }
              }).toList(),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.movie_outlined),
                activeIcon: Icon(Icons.movie),
                label: 'Watchlist',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.bookmark),
                icon: Icon(Icons.bookmark_outline),
                label: 'Bookmark',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(Icons.person),
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    bool isSelected = _selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.amber : Colors.black54,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontSize: 14,
          ),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

// Create a separate widget for HomeScreen content that can be used in both layouts
class HomeScreenContent extends StatefulWidget {
  final bool isWeb;
  
  const HomeScreenContent({super.key, required this.isWeb});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  List<MovieModel> _allMovies = [];
  List<MovieModel> _filteredMovies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final String response = await rootBundle.loadString('assets/movies.json');
    final List<dynamic> data = json.decode(response);
    final List<MovieModel> movies =
        data.map((json) => MovieModel.fromJson(json)).toList();
    setState(() {
      _allMovies = movies;
      _filteredMovies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top search bar
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: TextField(
                    onChanged: (query) {
                      context.read<MovieBloc>().add(SearchMovies(query));
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search movie',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.notifications, color: Colors.black),
              ),
              if (widget.isWeb) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ],
            ],
          ),
        ),
        
        // Main scrollable content
        Expanded(
          child: BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              if (state is MovieLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MovieLoaded) {
                if (state.filteredMovies.isEmpty) {
                  return const Center(
                    child: Text(
                      'No movies found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Featured movie card
                          if (state.filteredMovies.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MovieDetailScreen(movie: state.filteredMovies[0]),
                                  ),
                                );
                              },
                              child: Container(
                                height: widget.isWeb ? 300 : 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(state.filteredMovies[0].posterUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.filteredMovies[0].title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: widget.isWeb ? 36 : 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (widget.isWeb) ...[
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () {},
                                                icon: const Icon(Icons.play_arrow, color: Colors.black),
                                                label: const Text(
                                                  'Continue watching',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          
                          const SizedBox(height: 24),
                          
                          // Recommended Movies section header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recommended Movies',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'See All',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                        ]),
                      ),
                    ),
                    
                    // Movie grid using SliverGrid
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.isWeb ? 6 : 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: widget.isWeb ? 0.7 : 0.6,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final movie = state.filteredMovies[index];
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(movie.posterUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.8),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: widget.isWeb ? 14 : 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          movie.genre,
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: widget.isWeb ? 12 : 10,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: state.filteredMovies.length,
                        ),
                      ),
                    ),
                    
                    // Add some bottom padding
                    const SliverPadding(
                      padding: EdgeInsets.only(bottom: 20),
                    ),
                  ],
                );
              } else if (state is MovieError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}