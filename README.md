# ArtemisCloud ActiveMQ Artemis broker container image

## License

See link:[LICENSE](LICENSE) is used to build the image. file.

## How to build

[Cekit](https://docs.cekit.io) is used to build the image.

To build simply run:

```sh
cekit build docker
```

## Pre-commit hooks

We make sure we use pre-commit hooks to ensure the below are followed:

* Coding standards are followed
* Linting passes

```sh
pre-commit run
```
