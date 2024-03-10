//
//  NoticeDetailViewModel.swift
//  StorageFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import NoticeDomainInterface
import Foundation
import Kingfisher
import RxCocoa
import RxSwift
import Utility

public class NoticeDetailViewModel {
    let input = Input()
    let output = Output()
    var disposeBag = DisposeBag()

    deinit {
        DEBUG_LOG("❌ \(Self.self) Deinit")
    }

    public struct Input {
        var fetchNoticeDetail: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        var dataSource: BehaviorRelay<[NoticeDetailSectionModel]> = BehaviorRelay(value: [])
        var imageSizes: BehaviorRelay<[CGSize]> = BehaviorRelay(value: [])
    }

    public init(
        model: FetchNoticeEntity
    ) {
        let sectionModel = [NoticeDetailSectionModel(
            model: model,
            items: model.images
        )]

        let imageURLs: [URL] =
            model.images.map {
                WMImageAPI.fetchNotice(id: $0).toURL
            }
            .compactMap { $0 }

        input.fetchNoticeDetail
            .flatMap { [weak self] _ -> Observable<[CGSize]> in
                guard let self else { return Observable.empty() }
                return imageURLs.isEmpty ? Observable.just([]) : self.downloadImage(urls: imageURLs)
            }
            .subscribe(onNext: { [weak self] imageSizes in
                self?.output.imageSizes.accept(imageSizes)
                self?.output.dataSource.accept(sectionModel)
            })
            .disposed(by: disposeBag)
    }
}

extension NoticeDetailViewModel {
    private func downloadImage(urls: [URL]) -> Observable<[CGSize]> {
        var sizes: [CGSize] = []
        return Observable.create { observer -> Disposable in
            urls.forEach {
                KingfisherManager.shared.retrieveImage(
                    with: $0,
                    completionHandler: { result in
                        switch result {
                        case let .success(value):
                            sizes.append(CGSize(width: value.image.size.width, height: value.image.size.height))
                            if urls.count == sizes.count {
                                observer.onNext(sizes)
                                observer.onCompleted()
                            }
                        case let .failure(error):
                            DEBUG_LOG(error.localizedDescription)
                            sizes.append(.zero)
                            if urls.count == sizes.count {
                                observer.onNext(sizes)
                                observer.onCompleted()
                            }
                        }
                    }
                )
            }
            return Disposables.create {}
        }
    }
}
