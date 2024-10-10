<div align="center">

# asdf-omnictl [![Build](https://github.com/alongwill/asdf-omnictl/actions/workflows/build.yml/badge.svg)](https://github.com/alongwill/asdf-omnictl/actions/workflows/build.yml) [![Lint](https://github.com/alongwill/asdf-omnictl/actions/workflows/lint.yml/badge.svg)](https://github.com/alongwill/asdf-omnictl/actions/workflows/lint.yml)

[omnictl](https://omni.siderolabs.com/reference/cli) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add omnictl
# or
asdf plugin add omnictl https://github.com/alongwill/asdf-omnictl.git
```

omnictl:

```shell
# Show all installable versions
asdf list-all omnictl

# Install specific version
asdf install omnictl latest

# Set a version globally (on your ~/.tool-versions file)
asdf global omnictl latest

# Now omnictl commands are available
omnictl --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/alongwill/asdf-omnictl/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Andrew Longwill](https://github.com/alongwill/)
