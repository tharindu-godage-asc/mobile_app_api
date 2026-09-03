# Library API Test — Implementation Notes

## What was missing

The project only had `lib/main.dart` (the default Flutter counter template) plus `dio`
already listed in `pubspec.yaml`. The following files didn't exist and were created to
match the intended folder layout:

```
lib/
├── core/network/api_client.dart
├── data/models/book.dart
├── datasources/book_data_source.dart
├── presentation/pages/library_page.dart
└── main.dart (rewritten)
```

## Why this structure

A light layering split, common in small Flutter apps:

- **core/network** — infrastructure that's reusable regardless of what data it fetches
  (HTTP client setup, base URL, timeouts).
- **data/models** — plain data classes that mirror API responses (`Book`).
- **datasources** — the thing that actually calls the API and turns raw JSON into models.
  Kept separate from `core/network` so a repository/BLoC layer could be added later
  without touching the HTTP client.
- **presentation/pages** — UI only; talks to the data source directly since there's no
  state-management layer in this small test project yet.

## What each file does

- **`api_client.dart`** — Thin wrapper around `Dio`. Owns the base URL and timeouts, and
  exposes a single `getList(path)` helper that returns a JSON array. Kept minimal since
  this is a test/demo project — no interceptors, retry logic, or auth were added because
  nothing in the project needed them.
- **`book.dart`** — `Book` model (`id`, `title`, `description`, `pageCount`, `excerpt`,
  `publishDate`) with a `fromJson` factory. Fields default to empty/zero rather than
  throwing if the API omits them.
- **`book_data_source.dart`** — Calls `ApiClient.getList('/Books')` and maps the raw list
  into `List<Book>`.
- **`library_page.dart`** — `StatefulWidget` that loads books via `FutureBuilder`, shows a
  loading spinner / error / empty state, and supports pull-to-refresh.
- **`main.dart`** — Replaced the counter demo `MyApp`/`MyHomePage` with a `MaterialApp`
  that opens `LibraryPage` directly.

## API choice

No backend was specified, so the data source points at
`https://fakerestapi.azurewebsites.net/api/v1/Books` — a public, no-auth-required fake
REST API commonly used for exactly this kind of test/demo project, and its `Books`
endpoint's shape (`id`, `title`, `description`, `pageCount`, `excerpt`, `publishDate`)
matches the `Book` model above.

**If you have a real/different library API in mind, only `api_client.dart`'s `baseUrl`
and `book.dart`'s field mapping need to change** — the rest of the layers don't assume
anything API-specific.

## Verification

`flutter analyze` was run after adding the files — no issues found.
