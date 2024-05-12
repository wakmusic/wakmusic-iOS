// swift-tools-version: 5.9

import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSetting = PackageSettings(
    productTypes: [:],
    baseSettings: .settings(
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ]
    )
)
#endif

let package = Package(
    name: "WaktaverseMusicPackage",
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.6.0"),
        .package(url: "https://github.com/slackhq/PanModal.git", from: "1.2.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git",from: "6.5.0"),
        .package(url: "https://github.com/devxoul/Then", from: "2.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1"),
        .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.1.0"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.0.0"),
        .package(url: "https://github.com/uber/needle.git", from: "0.19.0"),
        .package(url: "https://github.com/uias/Tabman.git", from: "3.0.1"),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", from: "5.0.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard.git", from: "2.0.1"),
        .package(url: "https://github.com/huri000/SwiftEntryKit", from: "2.0.0"),
        .package(url: "https://github.com/kyungkoo/naveridlogin-ios-sp", from: "4.1.5"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.8.0"),
        .package(url: "https://github.com/cbpowell/MarqueeLabel.git", from: "4.3.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.25.0"),
        .package(url: "https://github.com/ninjaprox/NVActivityIndicatorView.git", from: "5.1.1"),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", from: "3.2.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "7.5.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "13.2.1"),
        .package(url: "https://github.com/krzysztofzablocki/Inject.git", from: "1.4.0")
    ]
)
