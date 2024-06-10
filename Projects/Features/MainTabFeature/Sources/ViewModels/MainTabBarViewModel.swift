//
//  MainTabBarViewModel.swift
//  MainTabFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import NoticeDomainInterface
import RxCocoa
import RxSwift
import Utility

public final class MainTabBarViewModel {
    let input = Input()
    let output = Output()
    private let disposeBag = DisposeBag()
    private var fetchNoticeUseCase: FetchNoticeUseCase

    public struct Input {}

    public struct Output {
        let dataSource: BehaviorRelay<[FetchNoticeEntity]> = BehaviorRelay(value: [])
    }

    public init(
        fetchNoticeUseCase: any FetchNoticeUseCase
    ) {
        self.fetchNoticeUseCase = fetchNoticeUseCase

        let igoredNoticeIds: [Int] = Utility.PreferenceManager.ignoredNoticeIDs ?? []
        DEBUG_LOG("igoredNoticeIds: \(igoredNoticeIds)")

        self.fetchNoticeUseCase.execute(type: .popup)
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
    }
}
