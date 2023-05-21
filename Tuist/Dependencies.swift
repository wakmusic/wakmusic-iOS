import ProjectDescription

let dependencies = Dependencies(
    carthage: nil,
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            .remote(url: "https://github.com/Moya/Moya.git", requirement: .upToNextMajor(from: "15.0.3")),
            .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.6.0")),
            .remote(url: "https://github.com/slackhq/PanModal.git", requirement: .upToNextMajor(from: "1.2.0")),
            .remote(url: "https://github.com/ReactiveX/RxSwift.git",requirement: .upToNextMajor(from: "6.5.0")),
            .remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMajor(from: "2.0.0")),
            .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.0.1")),
            .remote(url: "https://github.com/ashleymills/Reachability.swift", requirement: .upToNextMajor(from: "5.1.0")),
            .remote(url: "https://github.com/airbnb/lottie-ios.git", requirement: .upToNextMajor(from: "4.0.0")),
            .remote(url: "https://github.com/uber/needle.git", requirement: .upToNextMajor(from: "0.19.0")),
            .remote(url: "https://github.com/uias/Tabman.git", requirement: .upToNextMajor(from: "3.0.1")),
            .remote(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", requirement: .upToNextMajor(from: "5.0.0")),
            .remote(url: "https://github.com/RxSwiftCommunity/RxKeyboard.git", requirement: .upToNextMajor(from: "2.0.1")),
            .remote(url: "https://github.com/huri000/SwiftEntryKit", requirement: .upToNextMajor(from: "2.0.0")),
            .remote(url: "https://github.com/kyungkoo/naveridlogin-ios-sp", requirement: .upToNextMajor(from: "4.1.5")),
            .remote(url: "https://github.com/krzyzanowskim/CryptoSwift.git", requirement: .upToNextMajor(from: "1.6.0")),
            .remote(url: "https://github.com/cbpowell/MarqueeLabel.git", requirement: .upToNextMajor(from: "4.3.0")),
            .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "10.7.0")),
            .remote(url: "https://github.com/ninjaprox/NVActivityIndicatorView.git", requirement: .upToNextMajor(from: "5.1.1"))
        ],
        baseSettings: .settings(
            configurations: [
                .debug(name: .debug),
                .release(name: .release)
            ]
        )
    ),
    platforms: [.iOS]
)
