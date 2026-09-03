import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'http://10.0.2.2:3000',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  final Dio _dio;

  Future<List<dynamic>> getList(String path) async {
    final response = await _dio.get(path);
    return response.data as List<dynamic>;
  }
}
