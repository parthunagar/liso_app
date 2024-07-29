import 'dart:async';

import 'package:google_books_repository/google_books_repository.dart';

class GbooksRepository {
  const GbooksRepository(this.cache, this.client);

  final GoogleBooksCache cache;
  final GoogleBooksClient client;

  Future<SearchResult> search(String term) async {
    final cachedResult = cache.get(term);
    if (cachedResult != null) {
      return cachedResult;
    }
    final result = await client.search(term);
    cache.set(term, result);
    return result;
  }
}
