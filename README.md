# Tookey Mobile Signer

Mobile Signer by Tookey is a user-friendly application designed to bring robust security and convenience to your Web3 operations. From key generation to transaction signing, our mobile signer keeps you in control, emphasizing a self-sovereign approach towards asset management.

## Core Features:

1. Distributed Key Generation from UI: Say goodbye to complex infrastructure setups. Generate your keys effortlessly with the Mobile Signer's intuitive user interface.

2. Full Authority with Signing Process Participation: Keep full control over your keys by actively participating in the signing process from your personal device.

3. Interact with DApps via WalletConnect: Seamlessly interact with DApps supporting WalletConnect protocol. No need to import your keys anywhere. Just scan the QR code and you're good to go.

4. Self-Sovereign with Offline Signing: Load the second part of your key from cold storage and sign transactions offline, maintaining self-sovereignty without the need for Tookey.


## Getting Started

To begin, ensure that you have a working installation of the following items:

-   [Flutter SDK](https://docs.flutter.dev/get-started/install)
-   [Rust language](https://rustup.rs/)
-   Appropriate [Rust targets](https://rust-lang.github.io/rustup/cross-compilation.html) for cross-compiling to your device
-   For Android targets:
    -   Install [cargo-ndk](https://github.com/bbqsrc/cargo-ndk#installing)
    -   Install Android NDK 22, then put its path in one of the `gradle.properties`, e.g.:
-   For MacOS and iOS:
    -   Install [XCode](https://developer.apple.com/xcode/)

```sh
echo "ANDROID_NDK=.." >> ~/.gradle/gradle.properties
```

-   Web is not supported yet.

Then go ahead and run `flutter run`! When you're ready, refer to our documentation
[here](https://fzyzcjy.github.io/flutter_rust_bridge/index.html)
to learn how to write and use binding code.

## Environment variables

.env

```sh
BACKEND_API_URL=https://backend.apps-production.tookey.cloud # or your self-hosted URI
RELAY_URL=https://relay1.apps-production.tookey.cloud # or your self-hosted URI
TELEGRAM_BOT=tookey_bot # or your Telegram Bot handle
```
