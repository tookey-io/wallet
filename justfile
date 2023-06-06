default: gen lint

gen:
    flutter pub get
    flutter_rust_bridge_codegen \
        --rust-input native/src/api.rs \
        --dart-output lib/bridge_generated.dart \
        --c-output ios/Runner/bridge_generated.h \
        --dart-decl-output lib/bridge_definitions.dart \
        --wasm
    cp ios/Runner/bridge_generated.h macos/Runner/bridge_generated.h

lint:
    cd native && cargo fmt
    dart format .

clean:
    flutter clean
    cd native && cargo clean
    
serve *args='':
    flutter pub run flutter_rust_bridge:serve {{args}}

upload-ios:
    xcrun altool --upload-app -f build/ios/ipa/tookey.ipa \
        --type ios \
        --apiKey HT35DVYRL5 \
        --apiIssuer 3d5f49d6-0615-49b2-81e5-7299e022ea1d

# vim:expandtab:sw=4:ts=4
