# Budgy (Flutter Frontend)

Student budget tracker Flutter app connected to the Spring Boot backend in `../BN/Budgy`.

## Configure API base URL

By default, the app points to `http://10.0.2.2:8080` (Android emulator). Override at build time:

```bash
flutter run --dart-define=BUDGY_API_BASE_URL=http://localhost:8080
```

Common options:
- Android emulator: `http://10.0.2.2:8080`
- iOS simulator: `http://localhost:8080`
- Physical device on same LAN: `http://<your-machine-ip>:8080`

## Install dependencies

```bash
flutter pub get
```

## Run backend (Spring Boot)

From `../BN/Budgy`:

```bash
./mvnw spring-boot:run
```

The backend expects PostgreSQL per `application.properties`:
- URL: `jdbc:postgresql://localhost:5432/budgy_db`
- User: `postgres`
- Password: `123`

Adjust as needed.

## Run app

```bash
flutter run
```

## Features implemented
- Auth: signup and login (session persisted with `shared_preferences`)
- Splash auth gate: routes to dashboard when logged-in
- Dashboard: fetches incomes/expenses and shows totals

