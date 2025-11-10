<div align="center">

# asdf-mariadb [![Build](https://github.com/Rusydy/asdf-mariadb/actions/workflows/build.yml/badge.svg)](https://github.com/Rusydy/asdf-mariadb/actions/workflows/build.yml) [![Lint](https://github.com/Rusydy/asdf-mariadb/actions/workflows/lint.yml/badge.svg)](https://github.com/Rusydy/asdf-mariadb/actions/workflows/lint.yml)

[MariaDB](https://mariadb.org/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, `jq`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add mariadb
# or
asdf plugin add mariadb https://github.com/Rusydy/asdf-mariadb.git
```

MariaDB:

```shell
# Show all installable versions
asdf list-all mariadb

# Install specific version
asdf install mariadb latest

# Set a version globally (on your ~/.tool-versions file)
asdf global mariadb latest

# Now MariaDB commands are available
mysql --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/Rusydy/asdf-mariadb/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Rusydy](https://github.com/Rusydy/)
