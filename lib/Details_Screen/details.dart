import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Home_Screen/home.dart';
import '../Search_Screen/search.dart';

class DetailsScreen extends StatefulWidget {
  final int movieId;

  DetailsScreen({required this.movieId});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Map<String, dynamic> movieDetails = {}; // Initialize movieDetails as an empty map
  int _selectedIndex = 0; // Variable to track the selected index in the bottom navigation

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/shows/${widget.movieId}'));
    final data = json.decode(response.body);
    setState(() {
      movieDetails = data;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the selected screen
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SearchScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (movieDetails.isEmpty) {
      return Scaffold(backgroundColor: Colors.black,
        appBar: AppBar(title: Text('Movie Details', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),backgroundColor: Colors.black,),
        body: Center(child: CircularProgressIndicator()),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(  // Make the screen scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie image with Cut button on top
              Stack(
                children: [
                  Image.network(movieDetails['image']['original'] ?? 'https://via.placeholder.com/150'),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: Icon(Icons.cancel, color: Colors.black,size: 40,),
                      onPressed: () {
                        // Navigate to the previous screen
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),

           const   SizedBox(height: 20),

              // Buttons Row at the bottom of the image
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // "My List" Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle adding to My List functionality
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text("My List", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  // "Rate" Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle rating functionality
                    },
                    icon: Icon(Icons.thumb_up, color: Colors.white),
                    label: Text("Rate", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  // "Share" Button
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle sharing functionality
                    },
                    icon: Icon(Icons.share, color: Colors.white),
                    label: Text("Share", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),

           const   SizedBox(height: 20),

              // Play Button (Positioned at the bottom)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Play functionality
                    print("Play button pressed");
                  },
                  icon: Icon(Icons.play_arrow, color: Colors.white),
                  label: Text("Play", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 150),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

           const   SizedBox(height: 20),

              // Movie name
              Text(
                movieDetails['name'] ?? 'No Title',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              // Movie summary
              Text(
                movieDetails['summary'] != null
                    ? movieDetails['summary'].replaceAll(RegExp(r'<[^>]*>'), '')
                    : 'No summary available',
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              // Genres
              Text('Genres: ${movieDetails['genres']?.join(', ') ?? 'N/A'}', style: TextStyle(color: Colors.white)),
              SizedBox(height: 10),
              // Language
              Text('Language: ${movieDetails['language'] ?? 'N/A'}', style: TextStyle(color: Colors.white)),
              SizedBox(height: 20),
              // Premiere date
              Text('Premiered: ${movieDetails['premiered'] ?? 'N/A'}', style: TextStyle(color: Colors.white)),
              SizedBox(height: 10),
              // Runtime
              Text('Runtime: ${movieDetails['runtime'] ?? 'N/A'} minutes', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black26.withOpacity(0.5), // Transparent black background
        selectedItemColor: Colors.white, // Selected item color
        unselectedItemColor: Colors.white, // Unselected item color
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
