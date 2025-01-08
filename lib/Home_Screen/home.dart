import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Details_Screen/details.dart';
import '../Search_Screen/search.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> movies = [];
  int _selectedIndex = 0; // Variable to track selected tab

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    final List<dynamic> data = json.decode(response.body);
    setState(() {
      movies = data;
    });
  }

  // Function to handle navigation when BottomNavigationBar item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SearchScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("NETFLIX", style: TextStyle(fontSize: size.width * 0.08, color: Colors.red, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // This removes the back button from the app bar
      ),
      backgroundColor: Colors.black,
      body: movies.isEmpty
          ? Center(child: CircularProgressIndicator()) // Loading indicator while fetching data
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.02),
              // Trending Movies Header
              Text(
                'Trending Movies',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              // Display One Featured Movie Below the NETFLIX Title
              movies.isNotEmpty
                  ? Container(
                margin: EdgeInsets.only(bottom: size.height * 0.02),
                height: size.height * 0.3,
                child: GestureDetector(
                  onTap: () {
                    var featuredMovie = movies[0]['show'];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(movieId: featuredMovie['id']),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(size.width * 0.03),
                        child: Image.network(
                          movies[0]['show']['image'] != null
                              ? movies[0]['show']['image']['medium']
                              : 'https://via.placeholder.com/150',
                          width: double.infinity,
                          height: size.height * 0.22,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      // Movie Name
                      Text(
                        movies[0]['show']['name'] ?? 'No Title',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: size.height * 0.005),
                      // Genres Section
                      Text(
                        'Genres: ${movies[0]['show']['genres'].join(', ')}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: size.width * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : SizedBox.shrink(),
              // Movie list (Horizontal scroll view)
              Container(
                height: size.height * 0.28,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    var movie = movies[index]['show'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailsScreen(movieId: movie['id']),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: size.width * 0.02),
                        width: size.width * 0.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Movie Thumbnail
                            ClipRRect(
                              borderRadius: BorderRadius.circular(size.width * 0.03),
                              child: Image.network(
                                movie['image'] != null
                                    ? movie['image']['medium']
                                    : 'https://via.placeholder.com/150',
                                width: size.width * 0.3,
                                height: size.height * 0.22,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            // Movie Title
                            Text(
                              movie['name'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // All Movies Grid
              Text(
                'All Movies',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: size.width * 0.02,
                  mainAxisSpacing: size.height * 0.01,
                  childAspectRatio: size.width / (size.height * 0.8),
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  var movie = movies[index]['show'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(movieId: movie['id']),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Movie Thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(size.width * 0.03),
                          child: Image.network(
                            movie['image'] != null
                                ? movie['image']['medium']
                                : 'https://via.placeholder.com/150',
                            width: size.width * 0.4,
                            height: size.height * 0.22,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: size.height * 0.005),
                        // Movie Title
                        Text(
                          movie['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: size.height * 0.005),
                        // Short Movie Summary
                        Text(
                          movie['summary'] != null
                              ? movie['summary'].replaceAll(RegExp(r'<[^>]*>'), ' ').substring(0, 60)
                              : 'No summary available',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: size.width * 0.03,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  );
                },
              ),
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
