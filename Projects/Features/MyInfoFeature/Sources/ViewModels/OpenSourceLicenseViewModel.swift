//
//  OpenSourceLicenseViewModel.swift
//  CommonFeature
//
//  Created by KTH on 2023/05/17.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
@preconcurrency import RxCocoa
@preconcurrency import RxSwift
import Utility

public final class OpenSourceLicenseViewModel: Sendable {
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()

    public struct Input: Sendable {
        let viewDidLoad: PublishSubject<Void> = PublishSubject()
    }
    public struct Output: Sendable {
        let dataSource: BehaviorRelay<[OpenSourceLicense]> = BehaviorRelay(value: [])
    }

    init() {}

    func bind() {
        input.viewDidLoad.bind { [weak self] in
            self?.loadLicense()
        }
        .disposed(by: disposeBag)
    }

    private func loadLicense() {
        Task {
            var dataSource: [OpenSourceLicense] = [
                OpenSourceLicense(
                    title: "Alamofire",
                    description: "The MIT License\nCopyright (c) 2014-2018 Alamofire Software Foundation",
                    link: "https://github.com/Alamofire/Alamofire"
                ),
                OpenSourceLicense(
                    title: "Moya",
                    description: "The MIT License\nCopyright (c) 2014-present Artsy, Ash Furrow",
                    link: "https://github.com/Moya/Moya.git"
                ),
                OpenSourceLicense(
                    title: "Kingfisher",
                    description: "The MIT License\nCopyright (c) 2018 Wei Wang",
                    link: "https://github.com/onevcat/Kingfisher.git"
                ),
                OpenSourceLicense(
                    title: "RxSwift",
                    description: "The MIT License\nCopyright © 2015 Krunoslav Zaher All rights reserved.",
                    link: "https://github.com/ReactiveX/RxSwift.git"
                ),
                OpenSourceLicense(
                    title: "RxGesture",
                    description: "The MIT License\nCopyright © 2016 RxSwiftCommunity.",
                    link: "https://github.com/RxSwiftCommunity/RxGesture.git"
                ),
                OpenSourceLicense(
                    title: "RxDataSources",
                    description: "The MIT License\nCopyright (c) 2017 RxSwift Community",
                    link: "https://github.com/RxSwiftCommunity/RxDataSources.git"
                ),
                OpenSourceLicense(
                    title: "RxKeyboard",
                    description: "The MIT License\nCopyright (c) 2016 Suyeol Jeon (xoul.kr)",
                    link: "https://github.com/RxSwiftCommunity/RxKeyboard.git"
                ),
                OpenSourceLicense(
                    title: "FittedSheets",
                    description: "The MIT License\nCopyright (c) 2018 Gordon Tucker",
                    link: "https://github.com/gordontucker/FittedSheets.git"
                ),
                OpenSourceLicense(
                    title: "Then",
                    description: "The MIT License\nCopyright (c) 2015 Suyeol Jeon (xoul.kr)",
                    link: "https://github.com/devxoul/Then"
                ),
                OpenSourceLicense(
                    title: "SnapKit",
                    description: "The MIT License\nCopyright (c) 2011-Present SnapKit Team",
                    link: "https://github.com/SnapKit/SnapKit.git"
                ),
                OpenSourceLicense(
                    title: "Reachability",
                    description: "The MIT License\nCopyright (c) 2016 Ashley Mills",
                    link: "https://github.com/ashleymills/Reachability.swift"
                ),
                OpenSourceLicense(
                    title: "Lottie-ios",
                    description: "Apache License 2.0\nCopyright 2018 Airbnb, Inc.",
                    link: "https://github.com/airbnb/lottie-ios.git"
                ),
                OpenSourceLicense(
                    title: "Needle",
                    description: "uber/needle is licensed under the Apache License 2.0",
                    link: "https://github.com/uber/needle.git"
                ),
                OpenSourceLicense(
                    title: "Tabman",
                    description: "The MIT License\nCopyright (c) 2022 UI At Six",
                    link: "https://github.com/uias/Tabman.git"
                ),
                OpenSourceLicense(
                    title: "SwiftEntryKit",
                    description: "The MIT License\nCopyright (c) 2018 Daniel Huri",
                    link: "https://github.com/huri000/SwiftEntryKit"
                ),
                OpenSourceLicense(
                    title: "Naveridlogin-sdk-ios",
                    description: "naver/naveridlogin-sdk-ios is licensed under the Apache License 2.0",
                    link: "https://github.com/naver/naveridlogin-sdk-ios"
                ),
                OpenSourceLicense(
                    title: "CryptoSwift",
                    description: "The MIT License\nCopyright (C) 2014-3099 Marcin Krzyżanowski",
                    link: "https://github.com/krzyzanowskim/CryptoSwift.git"
                ),
                OpenSourceLicense(
                    title: "MarqueeLabel",
                    description: "The MIT License\nCopyright (c) 2011-2017 Charles Powell",
                    link: "https://github.com/cbpowell/MarqueeLabel.git"
                ),
                OpenSourceLicense(
                    title: "Firebase-ios-sdk",
                    description: "firebase/firebase-ios-sdk is licensed under the Apache License 2.0",
                    link: "https://github.com/firebase/firebase-ios-sdk.git"
                ),
                OpenSourceLicense(
                    title: "NVActivityIndicatorView",
                    description: "The MIT License\nCopyright (c) 2016 Vinh Nguyen",
                    link: "https://github.com/ninjaprox/NVActivityIndicatorView.git"
                ),
                OpenSourceLicense(
                    title: "RealmSwift",
                    description: "realm/realm-swift is licensed under the Apache License 2.0",
                    link: "https://github.com/realm/realm-swift"
                )
            ].sorted { $0.title < $1.title }

            async let apacheLicenseContent = loadTextFileFromBundle(fileName: "ApacheLicense")
            async let mitLicenseContent = loadTextFileFromBundle(fileName: "MITLicense")
            
            let (
                apacheLicense,
                mitLicense
            ) = try await (
                OpenSourceLicense(
                    type: .license,
                    title: "Apache License 2.0",
                    description: apacheLicenseContent,
                    link: ""
                ),
                OpenSourceLicense(
                    type: .license,
                    title: "MIT License (MIT)",
                    description: mitLicenseContent,
                    link: ""
                )
            )
            
            dataSource.append(apacheLicense)
            dataSource.append(mitLicense)
            self.output.dataSource.accept(dataSource)
        }

        func loadTextFileFromBundle(fileName: String) async throws -> String {
            if let fileURL = MyInfoFeatureResources.bundle.url(forResource: fileName, withExtension: "txt") {
                let contents = try String(contentsOf: fileURL, encoding: .utf8)
                return contents
            } else {
                let error = NSError(
                    domain: "yongbeomkwak.Billboardoo",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "파일을 찾을 수 없습니다."]
                )
                throw error
            }
        }
    }
}

public enum OpenSourceLicenseType {
    case library
    case license
}

public struct OpenSourceLicense {
    public var type: OpenSourceLicenseType = .library
    public let title: String
    public let description: String
    public let link: String
}
