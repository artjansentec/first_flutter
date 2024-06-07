import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'MovieDetailsPage.dart';
import 'main.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 1;
  List<Movie> _movies = [];
  List<Movie> _searchResults = [];

  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=55377b36c147ee5f67870358be9cbd79'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Movie> movies = [];
      for (var movie in data['results']) {
        movies.add(Movie.fromJson(movie));
      }
      setState(() {
        _movies = movies;
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=55377b36c147ee5f67870358be9cbd79&query=$query'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Movie> searchResults = [];
      for (var movie in data['results']) {
        searchResults.add(Movie.fromJson(movie));
      }
      setState(() {
        _searchResults = searchResults;
      });
    } else {
      throw Exception('Failed to search movies');
    }
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _searchMovies,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _searchResults.isEmpty ? _movies.length : _searchResults.length,
              itemBuilder: (context, index) {
                final movie = _searchResults.isEmpty ? _movies[index] : _searchResults[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MovieDetailsPage(movie: movie)),
                    );
                  },
                  child: Card(
                    color: Colors.black, // Cor de fundo do card
                    child: Column(
                      children: [
                        Image.network(
                          'https://image.tmdb.org/t/p/w500' + movie.posterPath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                        ListTile(
                          title: Text(
                            movie.title,
                            style: TextStyle(color: Colors.white), // Cor do texto
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Second Page',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}


