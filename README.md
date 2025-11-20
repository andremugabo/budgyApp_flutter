# Budgy (Flutter Frontend)

Student budget tracker Flutter app connected to the Spring Boot backend in `../BN/Budgy`.

---

## Overview

Budgy helps students track:

- **Income** (sources, types)
- **Expenses** (categories)
- **Savings goals** (target vs current, priority, target date)

The Flutter app talks to the Spring Boot API and persists auth state locally.

---

## Prerequisites

- Flutter SDK `>=3.24.0`
- Dart SDK `>=3.4.0 <4.0.0`
- Java 17+ (for Spring Boot backend)
- PostgreSQL running locally

---

## Configure API base URL

By default, the app points to `http://10.0.2.2:8080` (Android emulator). Override at build time:

```bash
flutter run --dart-define=BUDGY_API_BASE_URL=http://localhost:8080
```

Common options:

- Android emulator: `http://10.0.2.2:8080`
- iOS simulator: `http://localhost:8080`
- Physical device on same LAN: `http://<your-machine-ip>:8080`

You can also set this in your launch configuration or CI using `--dart-define`.

---

## Install dependencies

```bash
flutter pub get
```

---

## Backend (Spring Boot)

From `../BN/Budgy`:

```bash
./mvnw spring-boot:run
```

The backend expects PostgreSQL per `application.properties`:

- URL: `jdbc:postgresql://localhost:5432/budgy_db`
- User: `postgres`
- Password: `123`

Adjust these to match your local setup.

---

## Run the Flutter app

Run with the default API base URL (Android emulator):

```bash
flutter run
```

Or specify a different base URL:

```bash
flutter run --dart-define=BUDGY_API_BASE_URL=http://localhost:8080
```

---

## Assets & images

All app images are loaded from the `assets/images/` folder, which is already declared in `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true

  assets:
    - assets/images/
```

Recommended structure:

- **App icon** (used by `flutter_launcher_icons`)
  - Put the source icon file here, for example:
    - `assets/images/app_logo.png`
  - Configure in `pubspec.yaml` under `flutter_launcher_icons` and run:

    ```bash
    flutter pub run flutter_launcher_icons:main
    ```

- **Splash screen image** (native splash)
  - `flutter_native_splash` is configured to use:

    ```yaml
    flutter_native_splash:
      color: "#ffffff"
      image: assets/images/app_logo.png
    ```

  - Place your splash logo at `assets/images/app_logo.png` (replace with your new image but keep the same path), then regenerate and rebuild:

    ```bash
    flutter pub run flutter_native_splash:create
    flutter clean
    flutter run
    ```

- **UI images / illustrations / profile placeholders**
  - Put any additional images under `assets/images/`, for example:
    - `assets/images/profile.jpg` (used as the default profile avatar)
    - `assets/images/empty_state_income.png`
    - `assets/images/empty_state_expenses.png`
  - Reference them in code with `AssetImage('assets/images/...')`. No extra config is needed as long as they’re inside `assets/images/`.

If you add a **new folder** (e.g. `assets/illustrations/`), remember to include it in `pubspec.yaml`.

---

## Features implemented

- **Auth**
  - Signup and login
  - Session persisted with `shared_preferences`

- **Splash / navigation**
  - Native splash via `flutter_native_splash`
  - Flutter splash/auth gate that routes to dashboard or login based on session

- **Dashboard**
  - Fetches incomes, expenses, and savings from backend
  - Shows totals and recent activity

- **Income / Expenses / Savings**
  - List views with search and empty states
  - Add / edit dialogs with validation
  - Long‑press to delete with confirmation dialogs

- **Profile & Settings**
  - Profile editing (name, email, gender, avatar)
  - Settings screen with theme toggle, language stub, help/about pages

---

## Screenshots

> Note: UI may evolve, but these screenshots show the main flows.

### Swagger

![Swagger](/screenshorts/swaggerapp.png)


![Swagger](/screenshorts/twoswagger.png)

### Dashboard

![Budgy dashboard](/screenshorts/dashboard.png)


### Dark Dashboard


![Budgy dashboard](/screenshorts/darkdashboard.png)

### SplashScreen

![Income list](/screenshots/splashscreen.png)

### Settings & Profile

![Settings screen](screenshots/setting.png)

## Development notes

- This frontend assumes the API contract of the Spring Boot app in `../BN/Budgy`.
- If you change backend routes or JSON fields, update the services and models in `lib/services` and `lib/models` accordingly.

