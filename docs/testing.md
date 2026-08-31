# Testing

`test.sh` creates an isolated Docker Compose project, waits for healthy MySQL and
MongoDB instances, runs backend unit and integration tests, runs Flutter tests,
and always tears down containers and volumes. Tests must never connect to the
development or production database.

Backend unit tests mock repositories. Integration tests call HTTP endpoints and
use real container databases. Flutter unit tests cover serialization and view
models; widget tests cover essential forms and states.

