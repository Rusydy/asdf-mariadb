# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# Example for this plugin
asdf plugin test mariadb https://github.com/Rusydy/asdf-mariadb.git "mysql --version"
```

Tests are automatically run in GitHub Actions on push and PR.

## Development

1. Install `asdf` tools:

```shell
asdf plugin add shellcheck https://github.com/luizm/asdf-shellcheck.git
asdf plugin add shfmt https://github.com/luizm/asdf-shfmt.git
asdf install
```

2. Develop!

3. Lint & Format:

```shell
./scripts/format.bash
./scripts/lint.bash
```

4. PR changes

## Guidelines

- Follow the existing code style
- Add tests for new functionality
- Update documentation as needed
- Make sure all CI checks pass
- Use conventional commit messages for automatic release management
