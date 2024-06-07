import 'package:flutter/material.dart';

// Defina a classe Movie antes de usá-la
class Movie {
  final String title;
  final String overview;
  final String posterPath;

  Movie({
    required this.title,
    required this.overview,
    required this.posterPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
    );
  }
}

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://image.tmdb.org/t/p/w500' + movie.posterPath,
              width: 200,
              height: 300,
            ),
            SizedBox(height: 20),
            Text(
              movie.title,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              movie.overview,
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
