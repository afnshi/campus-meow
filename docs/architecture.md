# Architecture

The backend is a modular monolith. Packages are grouped by business capability
(`auth`, `user`, and `forum`) rather than by framework stereotype. Each module
owns its HTTP API, application service, model, and persistence adapter. Shared
security and error handling live in `common`.

The Flutter client follows the official Flutter application architecture:
views and view models form the UI layer, repositories are the source of truth,
and stateless services wrap remote or platform APIs. A domain layer contains
models shared by multiple screens.

MySQL owns transactional user identity and profile data. MongoDB owns forum
documents. MongoDB documents store only the immutable MySQL user identifier;
the API composes a user summary when returning a post.

