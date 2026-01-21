// Import the test package and Movie class
import 'package:tp3_manchon_ethan/service/movie_service.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  loadData() async { 
    final String jsonString = await rootBundle.loadString('assets/data/movies.json');
    return jsonString;
  }
  group('Movie JSON loading and parsing', () {
    test('Le chargement correct des données depuis le JSON', () async {
      final jsonString = await loadData();
      expect(jsonString.isNotEmpty, true);
    });

    test('Le parsing et la conversion en objets Movie', () async {
      final jsonString = await loadData();
      final List<dynamic> jsonData = json.decode(jsonString);
      final movies = jsonData.map((e) => Movie.fromJson(e)).toList();
      expect(movies.isNotEmpty, true);
      expect(movies.first, isA<Movie>());
    });

    test('Le nombre de films retournés correspond au JSON', () async {
      final jsonString = await loadData();
      final List<dynamic> jsonData = json.decode(jsonString);
      final movies = jsonData.map((e) => Movie.fromJson(e)).toList();
      expect(movies.length, jsonData.length);
    });
  });
}
