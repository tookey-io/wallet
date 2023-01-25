default: gen lint

gen:
    export REPO_DIR="$PWD"; cd /; flutter_rust_bridge_codegen \
        --rust-input "$REPO_DIR/native/src/api.rs" \
        --dart-output "$REPO_DIR/lib/bridge_generated.dart" \
        --c-output "$REPO_DIR/ios/Runner/bridge_generated.h" \
        --c-output "$REPO_DIR/macos/Runner/bridge_generated.h" \
        --llvm-compiler-opts='-I/usr/lib/clang/14.0.6/include/'

lint:
    cd native && cargo fmt && cargo fmt -- --check && cargo clippy -- -Dwarnings && cargo test
    dart format .

clean:
    flutter clean
    cd native && cargo clean


upload-ios:
    xcrun altool --upload-app -f build/ios/ipa/tookey.ipa \
        --type ios \
        --apiKey HT35DVYRL5 \
        --apiIssuer 3d5f49d6-0615-49b2-81e5-7299e022ea1d

# vim:expandtab:sw=4:ts=4
