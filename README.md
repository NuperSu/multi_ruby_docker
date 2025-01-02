# multi_ruby Docker Image

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
   docker build -t multi_ruby .
   ```

   This command builds the Docker image based on the provided `Dockerfile`, installing all specified Ruby versions using RVM.

### Running the Docker Container

You can run the container with a specific Ruby version by setting the `RUBY_V` environment variable.

```bash
docker run --rm -e RUBY_V=3.3.6 multi_ruby
```

### Verifying Ruby Versions

To verify that all Ruby versions are correctly installed and can run the application:

1. **List Installed Ruby Versions:**

   ```bash
   docker run --rm multi_ruby rvm list
   ```

2. **Run Tests for Each Ruby Version:**

   ```bash
   ./verify.sh
   ```

### Example Project

An example Ruby project with colored **Hello World** text.

- **Gemfile:** Specifies gem dependencie (`colorize`).

To run the tests:

```bash
docker run --rm -e RUBY_V=3.3.6 multi_ruby
```

### Continuous Integration

The project uses GitHub Actions for CI/CD to ensure that the Docker image builds and passes tests across all specified Ruby versions.

- **Workflow File:** `.github/workflows/main.yml`
- **CI Pipeline:**
  1. **Checkout Code:** Uses `actions/checkout@v4`.
  2. **Build Docker Image:** Builds the `multi_ruby` Docker image.
  3. **Test Each Ruby Version:** Runs `app.rb` for each Ruby version in the matrix.
