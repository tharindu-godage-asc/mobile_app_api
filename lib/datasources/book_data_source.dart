import '../core/network/api_client.dart';
import '../data/models/book.dart';

class BookDataSource {
  BookDataSource({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<List<Book>> fetchBooks() async {
    final data = await _apiClient.getList('/books');
    return data
        .map((json) => Book.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
