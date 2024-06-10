//
//  MainTabBarViewModel.swift
//  MainTabFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NoticeDomainInterface
import RxRelay
import RxSwift
import Utility

public final class MainTabBarViewModel {
    private let fetchNoticeUseCase: FetchNoticeUseCase
    private let disposeBag = DisposeBag()

    public init(
        fetchNoticeUseCase: any FetchNoticeUseCase
    ) {
        self.fetchNoticeUseCase = fetchNoticeUseCase
    }

    public struct Input {
        let fetchNoticePopup: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[FetchNoticeEntity]> = BehaviorRelay(value: [])
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        let igoredNoticeIds: [Int] = Utility.PreferenceManager.ignoredNoticeIDs ?? []
        DEBUG_LOG("igoredNoticeIds: \(igoredNoticeIds)")

        fetchNoticeUseCase.execute(type: .popup)
            .catchAndReturn([])
            .asObservable()
            .map { entities in
                guard !igoredNoticeIds.isEmpty else { return entities }
                return entities.filter { entity in
                    return !igoredNoticeIds.contains(where: { $0 == entity.id })
                }
            }
            .debug("igoredNoticeIds")
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        return output
    }
}
