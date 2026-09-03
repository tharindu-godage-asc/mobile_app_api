import 'package:flutter/material.dart';

import 'core/network/api_client.dart';
import 'datasources/book_data_source.dart';
import 'presentation/pages/library_page.dart';

void main() {
  final apiClient = ApiClient();
  final datasource = BookDataSource(apiClient: apiClient);


  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LibraryPage(bookDataSource: datasource),
    )
  );
}
