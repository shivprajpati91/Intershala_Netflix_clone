import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Details_Screen/details.dart';
import '../Home_Screen/home.dart'; // Import the HomeScreen for navigation

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController _controller = TextEditingController();

  List<dynamic> searchResults = [];
  int _selectedIndex = 1; // Index for the search screen in the bottom navigation bar

  // Function to handle search logic
  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          searchResults = data;
        });
      } else {
        // Handle API errors (e.g., 404, 500, etc.)
        setState(() {
          searchResults = [];
        });
      }
    } catch (e) {
      // Handle any network or parsing errors
      print('Error fetching movies: $e');
      setState(() {
        searchResults = [];
      });
    }
  }

  // Function to handle navigation when bottom nav item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to Home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
    // Else stay on the SearchScreen, no need for extra code as it remains the same
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Large search bar (Netflix-style)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 70),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
              ),
              child: TextField(
                controller: _controller,
                onChanged: searchMovies,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  hintText: 'Search games show...', // Change placeholder text
                  hintStyle: TextStyle(color: Colors.white54),
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.mic, color: Colors.white), // Mic icon for voice search
                    onPressed: () {
                      // Placeholder for voice search action
                      print("Voice search clicked");
                    },
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          // List of search results using ListTile
          Expanded(
            child: searchResults.isEmpty
                ? Center(child: Text('No results found', style: TextStyle(color: Colors.white)))
                : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                var movie = searchResults[index]['show'];
                if (movie == null) {
                  return SizedBox.shrink();
                }
                return ListTile(
                  onTap: () {
                    if (movie['id'] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(movieId: movie['id']),
                        ),
                      );
                    }
                  },
                  contentPadding: EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      movie['image'] != null
                          ? movie['image']['medium']
                          : 'https://via.placeholder.com/150',
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    movie['name'] ?? 'Unknown Title',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        movie['genres']?.join(', ') ?? 'Unknown Genre',
                        style: TextStyle(color: Colors.white70),
                      ),
                      IconButton(
                        icon: Icon(Icons.play_arrow, color: Colors.white),
                        onPressed: () {
                          if (movie['id'] != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailsScreen(movieId: movie['id']),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black26.withOpacity(0.5), // Transparent black background
        selectedItemColor: Colors.white,                 // Selected item color
        unselectedItemColor: Colors.white,              // Unselected item color
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}
