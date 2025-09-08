# Build Flutter web
FROM ghcr.io/cirruslabs/flutter:3.22.2 AS build
WORKDIR /app
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .
RUN flutter build web --release --dart-define=BUDGY_API_BASE_URL=${BUDGY_API_BASE_URL}

# Serve with Nginx
FROM nginx:1.27-alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80



