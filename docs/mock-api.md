# Mock API — Implementation Notes

## What changed since `architecture.md`

`architecture.md` describes the original setup, which pointed at the public
`fakerestapi.azurewebsites.net/api/v1/Books` endpoint. The project has since moved to a
local mock server instead:

- **`ApiClient`** (`lib/core/network/api_client.dart`) now uses
  `baseUrl: 'http://10.0.2.2:3000'` — the special address an Android emulator uses to
  reach `localhost` on the host machine.
- **`mock_api/db.json`** holds the mock dataset, served by
  [json-server](https://github.com/typicode/json-server) (`json-server mock_api/db.json`,
  default port 3000).

## Bugs found and fixed

1. **404 loading books** — `BookDataSource.fetchBooks()` requested `/Books` (capital B),
   but json-server derives routes from the `db.json` key, which is lowercase `"books"`.
   json-server routes are case-sensitive, so the mismatched path 404'd. Fixed by
   requesting `/books`.
2. **`type 'String' is not a subtype of type 'int'`** — `Book.fromJson` cast `json['id']`
   directly `as int`, which threw whenever the server returned `id` as a string. Fixed by
   parsing with `int.parse(json['id'].toString())`, which accepts either a numeric or
   string `id`.

## Known gap: schema mismatch

`mock_api/db.json` entries only have `id`, `title`, `author`, `available`. The `Book`
model (see `architecture.md`) expects `description`, `pageCount`, `excerpt`, and
`publishDate` too — these currently fall back to `''`/`0` via `Book.fromJson`'s `??`
defaults, so the UI renders but with blank descriptions and "0p" page counts.

If the mock data should exercise the full `Book` model, add those four fields to each
entry in `mock_api/db.json`. `author` and `available` aren't read by `Book` at all right
now.

## Seed data

`mock_api/db.json` currently has 32 books (`id` 1–32) for pagination/list-rendering
testing.

## Running the mock server

```
json-server mock_api/db.json
```

The Flutter app (on an Android emulator) expects it on port 3000 at `10.0.2.2`. For iOS
simulator or a physical device, `ApiClient`'s `baseUrl` will need to change
(`localhost` for iOS simulator, or the host machine's LAN IP for a physical device).
