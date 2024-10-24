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
            .debug(name: .qa),
            .release(name: .release)
        ]
    )
)
#endif

let package = Package(
    name: "WaktaverseMusicPackage",
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.11.0"),
        .package(url: "https://github.com/gordontucker/FittedSheets.git", from: "2.6.1"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git",from: "6.7.1"),
        .package(url: "https://github.com/devxoul/Then", from: "3.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
        .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.2.1"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.5.0"),
        .package(url: "https://github.com/uber/needle.git", from: "0.24.0"),
        .package(url: "https://github.com/uias/Tabman.git", from: "3.2.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", from: "5.0.2"),
        .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard.git", from: "2.0.1"),
        .package(url: "https://github.com/huri000/SwiftEntryKit", from: "2.0.0"),
        .package(url: "https://github.com/naver/naveridlogin-sdk-ios.git", branch: "master"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.8.2"),
        .package(url: "https://github.com/cbpowell/MarqueeLabel.git", from: "4.5.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.25.0"),
        .package(url: "https://github.com/ninjaprox/NVActivityIndicatorView.git", from: "5.2.0"),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", from: "3.2.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "7.5.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "13.3.0"),
        .package(url: "https://github.com/krzysztofzablocki/Inject.git", from: "1.5.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture.git", from: "4.0.4")
    ]
)
