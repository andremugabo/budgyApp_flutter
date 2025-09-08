# Build Flutter web (from mobile codebase)
FROM ghcr.io/cirruslabs/flutter:3.24.3 AS build
ARG BUDGY_API_BASE_URL=http://backend:8080
WORKDIR /app

# Run as root (default)—no chown needed
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .
RUN flutter build web --release --dart-define=BUDGY_API_BASE_URL=${BUDGY_API_BASE_URL}  # Mobile UI compiles to web

# Serve with Nginx (lightweight for web deployment)
FROM nginx:1.27-alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]