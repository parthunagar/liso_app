import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:google_books_repository/google_books_repository.dart';

class GoogleBooksClient {
  Map<String, String> headerValues = {
    'Authorization': 'AIzaSyCBtAe5rNWiuv03jhJWfxN6ktYteajLHQs'
  };

  GoogleBooksClient({
    http.Client? httpClient,
    this.baseUrl = "https://www.googleapis.com/books/v1/volumes?q=isbn:",
  }) : this.httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client httpClient;

  Future<SearchResult> search(String term) async {
    print('lets start a search');
    print("$baseUrl$term");
    final response = await httpClient.get(Uri.parse("$baseUrl$term"), headers: headerValues);
    final results = json.decode(response.body);
    //print(results.containsKey('items'));

    if (response.statusCode == 200 && results.containsKey('items')) {
      print('Got a 200 & results');
      return SearchResult.fromJson(results);
    } else if (response.statusCode == 200 && !results.containsKey('items')) {
      print('no results');
      throw NoSearchResult.fromJson(results);
    } else {
      throw SearchResultError.fromJson(results.error);
    }
  }
}
