# BakaLite

A lightweight, intuitive and open-source alternative client for [Bakaláři](https://bakalari.cz/), without the ads and tracking found in the official app.

Try it here: [baka.ttomf.cc](https://baka.ttomf.cc).

> [!IMPORTANT]
> **DISCLAIMER**: BakaLite is an unofficial client and is not affiliated with Bakaláři or its developers.

> [!WARNING]
> BakaLite is currently under development. Please report any bugs you find in [Issues](https://github.com/ttomf/bakalite/issues).

## Features

### Modules

- **Komens (Messages)**: received, sent and noticeboard messages with HTML content rendering and attachments
- **Marks**: marks sorted by date or subject, with weights, average and local what-if calculations
- **Homework**: current, after-deadline and closed homework, completion tracking, timeline and attachments
- **Timetable**: actual and permanent timetable, week navigation, current lesson highlighting and FLEXI layout

### More

- **Offline cache**: previously loaded data is cached and available offline
- **Multiple accounts**: switch between accounts or schools
- **Configuration**: set the theme, colors and language, or use the advanced developer screen
- **Web app**: installable PWA with service worker caching
- **Privacy**: no ads, no tracking, no third-party analytics, credentials are stored locally

## Supported platforms

BakaLite is built with [Flutter](https://flutter.dev). The main targets are Android and web, but Linux, iOS, macOS and Windows builds are also possible.

> [!WARNING]
> The web app needs your school server to allow cross-origin requests (CORS).
> If the server does not send a suitable `Access-Control-Allow-Origin` header, the web app won't be able to load data. In that case, use the Android app.

## Usage

### First launch

Enter your school's Bakaláři URL **without `/api`**
(for example `https://school.bakalari.cz/bakaweb`), or search for your school in the list.
School search may not work in the web build because the Bakaláři server does not allow cross-origin requests.
Then fill in your username and password.

> [!TIP]
> If you just want to test the app, or if you don't have a Bakaláři account, use `debug` as the URL, and any username and password.
> The app will use mock data.

## Build from source

Install Flutter stable (with Dart 3.13.4 or newer). Then clone this repo and build the app for any platform you want.

```sh
# Clone repo
git clone https://github.com/ttomf/bakalite
cd bakalite

# Android
flutter build apk --release

# Web (PWA)
flutter build web --wasm --pwa-strategy=none
```

For more platforms, see [Flutter guide](https://docs.flutter.dev/deployment).

## Project structure

```sh
# Platform-specific files
android/
ios/
linux/
macos/
web/
  service_worker.js
windows/

# Code
lib/
  cache/              # platform-specific cache implementations
  lang/               # app localization
  mocks/              # debug data for mock account
  screens/            # app screens
  widgets/            # reusable widgets
  accounts.dart       # account manager
  api.dart            # Bakaláři API client
  app.dart            # main Material App
  config.dart         # configuration manager
  exceptions.dart     # exception and error definitions
  main.dart           # main entry point
  theme.dart          # Material theme setup
  utils.dart          # miscellaneous utils and helper functions
```

## Contributing

Issues and pull requests are welcome. Before submitting a PR, please run:

```sh
dart format lib
flutter analyze
```

Please follow the existing code style and the lints in `analysis_options.yaml` (spaces for indentation, single quotes, const constructors) and add translations for new user-facing strings in `lib/lang/`.

## Acknowledgements

Special thanks to the [Bakaláři API](https://github.com/bakalari-api/bakalari-api-v3) project for its excellent documentation and to everyone who tested BakaLite and shared their feedback.

## License

Copyright (C) 2026 Tom F.

BakaLite is licensed under the GNU General Public License v3.0 or later. See the [LICENSE](./LICENSE) file for details.
