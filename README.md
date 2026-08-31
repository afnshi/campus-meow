# CampusMeow

CampusMeow is a small campus community demo built to exercise production-style
project structure, automated checks, repeatable database tests, and containerized
delivery.

## Stack

- Flutter client (MVVM: UI, domain, and data layers)
- Spring Boot API (domain-oriented modules)
- MySQL for accounts and profiles
- MongoDB for posts and comments
- Redis for optional short-lived caching
- Docker Compose for local and test environments

## Repository layout

```text
apps/
  api/              Spring Boot REST API
  flutter_client/   Flutter Android, Windows, and Web client
docs/               Architecture, API, database, and testing notes
scripts/            Shared shell helpers
dist/               Generated APK and JAR artifacts
```

## Local workflow

Requirements: Docker, Java 21, Flutter, and a POSIX shell (WSL on Windows).

```sh
cp .env.example .env
docker compose up -d --build
./lint.sh
./test.sh
./build.sh
```

The API is available at `http://localhost:8080/api/v1`. Database ports are not
published by the default compose file.

## Run the Flutter client

Open the repository root in VS Code, select one of the following launch
configurations, and press F5:

- `CampusMeow - Android`
- `CampusMeow - Windows`
- `CampusMeow - Web`

The client automatically uses `10.0.2.2` on the Android emulator and
`localhost` on Windows and Web. A deployed API can override the automatic
choice without editing source code:

```sh
flutter run --dart-define=API_BASE_URL=https://example.com/api/v1
```

## Test account

Integration tests create their own data and never use the development volumes.
For manual development, register a user through `POST /api/v1/auth/register`.

## Security

Never commit `.env`, credentials, JWT secrets, or SSH private keys. Only public
keys ending in `.pub` may be shared with a server administrator.

## Deployment

Server deployment is intentionally deferred. `deploy.sh` validates the local
release configuration but refuses to deploy until a production compose file and
explicit deployment target are supplied.
