# Tookey

This repository serves as a template for Flutter projects calling into native Rust
libraries via `flutter_rust_bridge`.

## Getting Started

To begin, ensure that you have a working installation of the following items:

-   [Flutter SDK](https://docs.flutter.dev/get-started/install)
-   [Rust language](https://rustup.rs/)
-   Appropriate [Rust targets](https://rust-lang.github.io/rustup/cross-compilation.html) for cross-compiling to your device
-   For Android targets:
    -   Install [cargo-ndk](https://github.com/bbqsrc/cargo-ndk#installing)
    -   Install Android NDK 22, then put its path in one of the `gradle.properties`, e.g.:

```
echo "ANDROID_NDK=.." >> ~/.gradle/gradle.properties
```

-   Web is not supported yet.

Then go ahead and run `flutter run`! When you're ready, refer to our documentation
[here](https://fzyzcjy.github.io/flutter_rust_bridge/index.html)
to learn how to write and use binding code.

## Environment variables

.env

```
TEST_ENV=true
BACKEND_API_URL=http://localhost:2000
RELAY_URL=http://localhost:8000
TELEGRAM_BOT=tookey_dev_bot
NODE_URL=https://data-seed-prebsc-2-s3.binance.org:8545/
```
