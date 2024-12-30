# MultiRuby Docker Image

![Ruby Versions](https://img.shields.io/badge/Ruby-2.3%20to%203.3-blue)

## Overview

This project provides a Docker image based on `ubuntu:24.04` that includes multiple Ruby versions (from **2.3** to **3.3**, inclusive) managed via [RVM (Ruby Version Manager)](https://rvm.io/). For each major Ruby version, only the latest minor version is installed. This setup ensures that all installed Ruby versions can run a Ruby application with a `Gemfile`.

## Features

- **Base Image:** `ubuntu:24.04`
- **Ruby Versions Installed:**
  - Ruby 2.3.8
  - Ruby 2.4.10
  - Ruby 2.5.9
  - Ruby 2.6.10
  - Ruby 2.7.8
  - Ruby 3.0.7
  - Ruby 3.1.6
  - Ruby 3.2.6
  - Ruby 3.3.6
- **Ruby Version Manager:** [RVM](https://rvm.io/)
- **Gem Dependencies:** Managed via `Bundler` with a provided `Gemfile`
- **CI/CD Integration:** GitHub Actions workflow to build and test across all Ruby versions

## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/get-started) installed on your machine.

### Building the Docker Image

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/NuperSu/multi_ruby_docker.git
   cd multi_ruby_docker
   ```

2. **Build the Docker Image:**

   ```bash
   docker build -t multiruby .
   ```

   This command builds the Docker image based on the provided `Dockerfile`, installing all specified Ruby versions using RVM.

### Running the Docker Container

You can run the container with a specific Ruby version by setting the `RUBY_VERSION` environment variable.

```bash
docker run --rm -e RUBY_VERSION=3.3.6 -v $(pwd):/app multiruby rake test
```

**Parameters:**

- `--rm`: Automatically remove the container after it exits.
- `-e RUBY_VERSION=3.3.6`: Sets the Ruby version to use inside the container.
- `-v $(pwd):/app`: Mounts the current directory to `/app` inside the container.
- `multiruby`: The name of the Docker image.
- `rake test`: The command to run inside the container.

### Verifying Ruby Versions

To verify that all Ruby versions are correctly installed and can run the application:

1. **List Installed Ruby Versions:**

   ```bash
   docker run --rm multiruby rvm list
   ```

2. **Run Tests for Each Ruby Version:**

   The provided GitHub Actions workflow automatically builds and tests the Docker image across all specified Ruby versions. However, you can manually run tests for each version as follows:

   ```bash
   RUBY_VERSIONS=(2.3.8 2.4.10 2.5.9 2.6.10 2.7.8 3.0.7 3.1.6 3.2.6 3.3.6)

   for version in "${RUBY_VERSIONS[@]}"; do
     echo "Testing Ruby $version..."
     docker run --rm -e RUBY_VERSION=$version -v $(pwd):/app multiruby rake test
   done
   ```

### Example Project

An example Ruby project is included to demonstrate the functionality. It contains a simple test suite using `minitest`.

- **Gemfile:** Specifies gem dependencies (`rake` and `minitest`).
- **Rakefile:** Defines the default task to run tests.
- **Tests:** Located in the `test/` directory.

To run the tests:

```bash
docker run --rm -e RUBY_VERSION=3.3.6 -v $(pwd):/app multiruby rake test
```

### Continuous Integration

The project uses GitHub Actions for CI/CD to ensure that the Docker image builds and passes tests across all specified Ruby versions.

- **Workflow File:** `.github/workflows/main.yml`
- **CI Pipeline:**
  1. **Checkout Code:** Uses `actions/checkout@v4`.
  2. **Build Docker Image:** Builds the `multiruby` Docker image.
  3. **Test Each Ruby Version:** Runs `rake test` for each Ruby version in the matrix.

### Scripts and Utilities

- **`combine.py`:** A Python script to combine multiple files into one, preserving their relative paths and contents.
- **`entrypoint.sh`:** Entry point script for the Docker container that sets up the Ruby environment and runs the specified command.

## Usage Examples

### Running Tests with a Specific Ruby Version

```bash
docker run --rm -e RUBY_VERSION=2.7.8 -v $(pwd):/app multiruby rake test
```

### Starting an Interactive Console

```bash
docker run --rm -e RUBY_VERSION=3.2.6 -v $(pwd):/app -it multiruby bin/console
```
