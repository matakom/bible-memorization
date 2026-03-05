# Bible Memorization App

This is an offline-first mobile application designed to help users memorize scripture through interactive games and spaced repetition. It uses a local-first synchronization strategy, meaning the app stays fully functional without an internet connection and syncs data to a central server when back online.

## Architecture

* **Frontend**: Flutter (Dart) with Riverpod for state management and Drift for the SQLite local database.
* **Backend**: NestJS (TypeScript) with TypeORM and PostgreSQL, containerized with Docker.

## Setup and Running

### Server (NestJS)

The backend runs in Docker containers to manage the database and the API logic.

1.  Navigate to the server directory:
    ```bash
    cd nestjs_server
    ```

2.  Environment configuration:
    Ensure you have a `.env` file with your PostgreSQL credentials and Firebase project details.

3.  Start the containers:
    ```bash
    npm run docker:up
    ```

4.  Check logs:
    ```bash
    npm run docker:logs
    ```

### Client (Flutter)

The mobile app requires a one-time code generation step for the database and models.

1.  Navigate to the app directory:
    ```bash
    cd flutter_app
    ```

2.  Install dependencies:
    ```bash
    flutter pub get
    ```

3.  Generate code:
    Rebuild the database and model files:
    ```bash
    just gen-build
    ```

4.  Run the app:
    Start the development build:
    ```bash
    just run
    ```

## Local Development

### Just Commands
The project uses a `justfile` to simplify frequent tasks:
* `just gen-watch`: Automatically rebuilds code when you change models or database tables.
* `just run`: Runs the app in dev mode.
* `just run prod`: Runs the app in release mode.

### Database Inspection
If you need to peek into the local SQLite data while developing:
1.  Go to the **Settings** screen in-app.
2.  Tap **Debug DB** to launch the Drift DB Viewer.
