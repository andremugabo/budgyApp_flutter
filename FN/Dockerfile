FROM ghcr.io/cirruslabs/flutter:3.24.3 AS build  
ARG BUDGY_API_BASE_URL=http://backend:8080  # Default for safety
WORKDIR /app

# Optional: Non-root user to avoid root warning
RUN groupadd -r flutteruser && useradd -r -g flutteruser flutteruser \
    && mkdir -p /app && chown -R flutteruser:flutteruser /app
USER flutteruser

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get
COPY . .
RUN flutter build web --release --dart-define=BUDGY_API_BASE_URL=${BUDGY_API_BASE_URL}

FROM nginx:1.27-alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80