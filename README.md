## Docker deployment (backend + frontend + Postgres)

Prereqs: Docker and docker-compose.

Build and run:

```bash
docker-compose up -d --build
```

Services:
- Backend (Spring Boot): http://localhost:8080
- Frontend (Flutter web via Nginx): http://localhost:8081
- Postgres: localhost:5432 (db=budgy_db, user=postgres, pass=123)

Environment overrides:
- You can use a `.env` file in the repo root to override variables (examples below).
- Frontend build receives `BUDGY_API_BASE_URL` (default `http://backend:8080`).
- Backend uses `SPRING_DATASOURCE_*` derived from DB vars.

`.env` example:

```
POSTGRES_DB=budgy_db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=123
DB_PORT=5432
BACKEND_PORT=8080
FRONTEND_PORT=8081
BUDGY_API_BASE_URL=http://backend:8080
```

Tear down:

```bash
docker-compose down
```


