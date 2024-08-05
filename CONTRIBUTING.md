# Contributing to docker-keepalived

Thank you for considering contributing to `docker-keepalived`! This document provides guidelines to ensure smooth collaboration.

## Table of Contents

- [Conventional Commits](#conventional-commits)
- [Writing and Modifying Init Scripts](#writing-and-modifying-init-scripts)
- [Running Tests with BATS](#running-tests-with-bats)
- [Submitting Pull Requests](#submitting-pull-requests)

## Conventional Commits

This project follows the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification. Please adhere to the specification when creating commit messages.

### Commit Message Structure
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types
- `feat`: A new feature.
- `fix`: A bug fix.
- `docs`: Documentation only changes.
- `style`: Changes that do not affect the meaning of the code (white-space, formatting, etc.).
- `refactor`: A code change that neither fixes a bug nor adds a feature.
- `perf`: A code change that improves performance.
- `test`: Adding missing tests or correcting existing tests.
- `chore`: Changes to the build process or auxiliary tools and libraries such as documentation generation.

## Writing and Modifying Init Scripts

When adding or modifying init scripts, please ensure the following:
1. **Code Quality**: Follow best practices for Bash scripting.
2. **Error Handling**: Ensure that scripts handle errors gracefully and provide informative error messages.
3. **Testing**: Write tests using BATS (Bash Automated Testing System).

## Running Tests with BATS

We use [BATS](https://github.com/bats-core/bats-core) for testing our Bash scripts. Please follow these steps to write and run tests:

### Installation

Make sure you have BATS installed. You can use the linked submodules:

```
git submodule update --init --recursive
```

Please refer to the [BATS installation guide](https://github.com/bats-core/bats-core#installation).

### Writing Tests

1. Create a new test file in the `tests` directory with a `.bats` extension. For example: `tests/my_script.bats`
2. Write your test cases within the new `.bats` file. Here's a basic example:

    ```bash
    #!/usr/bin/env bats

    @test "description of the test case" {
        run ./path/to/your_script.sh
        [ "$status" -eq 0 ]
        [ "$output" == "expected output" ]
    }
    ```

### Running Tests

To run all tests, execute the following command in the project root:

```
# build the container locally
docker build -t keepalived:test-build .

# run tests using bats
docker run --rm -it --name keepalived-test \
    --cap-add=NET_ADMIN \
    --entrypoint /test/bats/bin/bats \
    -w /test \
    -v "$PWD/test:/test" \
    keepalived:test-build .
```

This will execute all test files in the `test` directory and show the results.

## Submitting Pull Requests

1. **Fork the Repository**: Create a fork of the repository to work on your changes.
2. **Create a Branch**: Create a new branch for your feature or bugfix.
3. **Commit Changes**: Make your changes, commit using [Conventional Commits](#conventional-commits), and push to your fork.
4. **Open a Pull Request**: Open a pull request (PR) to merge your changes into the main repository.
5. **Review Process**: Your PR will be reviewed by the maintainers. Please address any feedback and make necessary changes.
6. **Merge**: Once approved, your PR will be merged.

Thank you for contributing to `docker-keepalived`! We appreciate your efforts in making this project better.
