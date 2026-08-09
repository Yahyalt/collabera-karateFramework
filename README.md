# Collabera Karate Framework

API test automation project built with [Karate](https://github.com/karatelabs/karate) and JUnit 6. Tests target the [GoRest](https://gorest.co.in/) public REST API.

## Prerequisites

Install the following before you start:

| Tool | Version | Notes |
|------|---------|-------|
| **Java JDK** | 21+ | Required by `pom.xml` (`maven.compiler.release=21`) |
| **Apache Maven** | 3.8+ | Used to download dependencies and run tests |
| **Git** | Any recent version | To clone the repository |

Verify your setup:

```bash
java -version
mvn -version
```

## Quick start (from scratch)

### 1. Clone the repository

```bash
git clone <repository-url>
cd karate-framework2
```

### 2. Create a GoRest account and token

1. Open [https://gorest.co.in/](https://gorest.co.in/) and sign up (free).
2. After login, go to your profile / API token page and copy your **Bearer token**.

GoRest requires authentication for write operations (POST, PUT, DELETE). Read-only GET calls may work without a token, but this project is configured to use one for all scenarios.

### 3. Configure environment variables

Copy the example env file and fill in your values:

```bash
cp .env.example .env
```

Edit `.env`:

```env
GOREST_TOKEN=your_gorest_bearer_token_here
GOREST_BASE_URL=https://gorest.co.in/public/v2
```

> **Important:** `.env` is git-ignored. Never commit tokens or secrets to the repository.

These values are loaded at runtime by `karate-config.js` via [java-dotenv](https://github.com/cdimascio/java-dotenv) and exposed to feature files as `baseUrl` and `token`.

### 4. Install dependencies

Maven downloads everything on the first run. You can trigger that explicitly:

```bash
mvn clean test-compile
```

### 5. Run tests

Run all tests:

```bash
mvn test
```

Run a specific test class:

```bash
mvn test -Dtest=ExamplesTest
mvn test -Dtest=TaskCollaberaTest
```

Run a single scenario by tag (example):

```bash
mvn test -Dtest=ExamplesTest -Dkarate.options="--tags @getAllUsers"
```

After a run, open the HTML report:

```
target/karate-reports/karate-summary.html
```

## Project structure

```
karate-framework2/
├── pom.xml                          # Maven config, Karate + JUnit dependencies
├── .env.example                     # Template for required environment variables
├── .env                             # Local secrets (not committed)
└── src/test/java/
    ├── karate-config.js             # Global Karate config (loads .env)
    └── examples/
        ├── ExamplesTest.java        # JUnit runner for trial/users.feature
        ├── TaskCollaberaTest.java   # JUnit runner for task/scenarioOne.feature
        ├── trial/
        │   └── users.feature        # Example: GET all users
        └── task/
            ├── scenarioOne.feature  # Example: create user, then fetch by ID
            └── IdHolder.java        # Shared state between scenarios in one feature
```

### How it fits together

1. **JUnit test class** — Each `*Test.java` file uses `@Karate.Test` to point at one or more `.feature` files.
2. **`karate-config.js`** — Runs before every scenario and returns `baseUrl` and `token` from `.env`.
3. **`.feature` files** — Gherkin-style API tests (Given/When/Then) using Karate syntax.

Example runner:

```java
@Karate.Test
Karate testUsers() {
    return Karate.run("trial/users").relativeTo(getClass());
}
```

Example feature background:

```gherkin
Background:
  * url baseUrl
  * header Authorization = 'Bearer ' + token
```

## Included test suites

| Test class | Feature file | What it does |
|------------|--------------|--------------|
| `ExamplesTest` | `trial/users.feature` | GET `/users` and assert a JSON array response |
| `TaskCollaberaTest` | `task/scenarioOne.feature` | POST a new user, store the ID, then GET that user and verify status |

## Adding your own tests

### Option A: New feature under an existing runner

1. Create `src/test/java/examples/myfolder/mytest.feature`.
2. Point an existing or new JUnit class at it:

```java
package examples;

import io.karatelabs.junit6.Karate;

class MyTest {
    @Karate.Test
    Karate runMyFeature() {
        return Karate.run("myfolder/mytest").relativeTo(getClass());
    }
}
```

### Option B: Minimal feature template

```gherkin
Feature: My API test

  Background:
    * url baseUrl
    * header Authorization = 'Bearer ' + token

  Scenario: Health check
    Given path 'users'
    When method get
    Then status 200
```

Then run:

```bash
mvn test -Dtest=MyTest
```

## Useful Maven commands

| Command | Purpose |
|---------|---------|
| `mvn test` | Run all Karate/JUnit tests |
| `mvn test -Dtest=ExamplesTest` | Run one test class |
| `mvn clean test` | Clean previous build artifacts, then test |
| `mvn test -Dkarate.options="--tags @myTag"` | Filter by Karate tag |

## Troubleshooting

| Problem | Likely cause | Fix |
|---------|--------------|-----|
| `401 Unauthorized` | Missing or invalid `GOREST_TOKEN` | Regenerate token on gorest.co.in and update `.env` |
| `Connection refused` / timeout | Wrong `GOREST_BASE_URL` | Use `https://gorest.co.in/public/v2` (no trailing slash) |
| `.env` values not picked up | File missing or wrong working directory | Ensure `.env` is in the project root; run `mvn` from there |
| Java version errors | JDK older than 21 | Install JDK 21+ and set `JAVA_HOME` |

## Tech stack

- [Karate 2.1.1](https://github.com/karatelabs/karate) — API test DSL
- [JUnit 5 / Jupiter](https://junit.org/junit5/) — Test runner (via `karate-junit6`)
- [java-dotenv 5.2.2](https://github.com/cdimascio/java-dotenv) — Load `.env` in Java/Karate
- [Maven Surefire 3.2.5](https://maven.apache.org/surefire/maven-surefire-plugin/) — Execute tests in CI and locally


