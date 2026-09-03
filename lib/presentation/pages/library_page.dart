import 'package:flutter/material.dart';

import '../../data/models/book.dart';
import '../../datasources/book_data_source.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key, this.bookDataSource});

  final BookDataSource? bookDataSource;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late final BookDataSource _dataSource =
      widget.bookDataSource ?? BookDataSource();
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = _dataSource.fetchBooks();
  }

  Future<void> _refresh() async {
    setState(() {
      _booksFuture = _dataSource.fetchBooks();
    });
    await _booksFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load books: ${snapshot.error}'));
          }
          final books = snapshot.data ?? const [];
          if (books.isEmpty) {
            return const Center(child: Text('No books found.'));
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.description),
                  trailing: Text('${book.pageCount}p'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
