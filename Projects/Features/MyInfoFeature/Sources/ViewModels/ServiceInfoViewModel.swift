//
//  ServiceInfoViewModel.swift
//  CommonFeature
//
//  Created by KTH on 2023/05/17.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import Kingfisher
import RxCocoa
import RxSwift
import UIKit
import Utility

public final class ServiceInfoViewModel {
    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()

    public struct Input {
        var requestCacheSize: PublishSubject<Void> = PublishSubject()
        var removeCache: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        var dataSource: BehaviorRelay<[ServiceInfoGroup]> = BehaviorRelay(value: [])
        var cacheSizeString: PublishSubject<String> = PublishSubject()
        var showToast: PublishSubject<String> = PublishSubject()
    }

    init() {
        let dataSource: [ServiceInfoGroup] = [
            ServiceInfoGroup(
                identifier: .termsOfUse,
                name: ServiceInfoGroup.Identifier.termsOfUse.rawValue,
                subName: "",
                accessoryType: ServiceInfoGroup.AccessoryType.detail
            ),
            ServiceInfoGroup(
                identifier: .privacy,
                name: ServiceInfoGroup.Identifier.privacy.rawValue,
                subName: "",
                accessoryType: ServiceInfoGroup.AccessoryType.detail
            ),
            ServiceInfoGroup(
                identifier: .openSourceLicense,
                name: ServiceInfoGroup.Identifier.openSourceLicense.rawValue,
                subName: "",
                accessoryType: ServiceInfoGroup.AccessoryType.detail
            ),
            ServiceInfoGroup(
                identifier: .removeCache,
                name: ServiceInfoGroup.Identifier.removeCache.rawValue,
                subName: "",
                accessoryType: ServiceInfoGroup.AccessoryType.detail
            ),
            ServiceInfoGroup(
                identifier: .versionInfomation,
                name: ServiceInfoGroup.Identifier.versionInfomation.rawValue,
                subName: "\(APP_VERSION())",
                accessoryType: ServiceInfoGroup.AccessoryType.onlyTitle
            )
        ]
        output.dataSource.accept(dataSource)

        input.requestCacheSize
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.calculateMemorySize { result in
                    switch result {
                    case let .success(sizeString):
                        owner.output.cacheSizeString.onNext(sizeString)
                    case let .failure(error):
                        DEBUG_LOG(error.localizedDescription)
                    }
                }
            }).disposed(by: disposeBag)

        input.removeCache
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                ImageCache.default.clearDiskCache { () in
                    owner.output.showToast.onNext("캐시 데이터가 삭제되었습니다.")
                }
            }).disposed(by: disposeBag)
    }
}

extension ServiceInfoViewModel {
    private func calculateMemorySize(completionHandler: @escaping (Result<String, Error>) -> Void) {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case let .success(size):
                let sizeString = ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file)
                completionHandler(.success(sizeString))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}

public struct ServiceInfoGroup {
    let identifier: ServiceInfoGroup.Identifier
    let icon: UIImage? = nil
    let name: String
    let subName: String
    let accessoryType: AccessoryType
}

public extension ServiceInfoGroup {
    enum AccessoryType {
        case detail
        case onlyTitle
        case detailTitle
    }

    enum Identifier: String {
        case termsOfUse = "서비스 이용약관"
        case privacy = "개인정보 처리방침"
        case openSourceLicense = "오픈소스 라이선스"
        case removeCache = "캐시 데이터 지우기"
        case versionInfomation = "버전정보"
    }
}
