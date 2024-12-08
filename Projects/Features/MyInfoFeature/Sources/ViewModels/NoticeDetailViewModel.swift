import BaseFeature
import Foundation
import Kingfisher
import LogManager
import NoticeDomainInterface
import RxCocoa
import RxSwift
import Utility

public final class NoticeDetailViewModel {
    private let model: FetchNoticeEntity
    private let disposeBag = DisposeBag()

    deinit {
        DEBUG_LOG("❌ \(Self.self) Deinit")
    }

    public init(model: FetchNoticeEntity) {
        self.model = model
        readNotice(ID: self.model.id)
    }

    public struct Input {
        let fetchNoticeDetail: PublishSubject<Void> = PublishSubject()
        let didTapImage: PublishSubject<IndexPath> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[NoticeDetailSectionModel]> = BehaviorRelay(value: [])
        let imageSizes: BehaviorRelay<[CGSize]> = BehaviorRelay(value: [])
        let goSafariScene: PublishSubject<String> = PublishSubject()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        let sectionModel = [NoticeDetailSectionModel(model: model, items: model.origins)]
        let imageURLs: [URL] = model.origins.map { URL(string: $0.url) }.compactMap { $0 }

        input.fetchNoticeDetail
            .flatMap { [weak self] _ -> Observable<[CGSize]> in
                guard let self = self else { return .never() }
                return imageURLs.isEmpty ?
                    Observable.just([]) :
                    Observable.zip(
                        imageURLs.map { self.downloadImageSize(url: $0) }
                    )
            }
            .bind { imageSizes in
                output.imageSizes.accept(imageSizes)
                output.dataSource.accept(sectionModel)
            }
            .disposed(by: disposeBag)

        input.didTapImage
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { $0.1[$0.0.section].items[$0.0.item] }
            .filter { !$0.link.isEmpty }
            .map { $0.link }
            .bind(to: output.goSafariScene)
            .disposed(by: disposeBag)

        return output
    }
}

private extension NoticeDetailViewModel {
    func readNotice(ID: Int) {
        var newReadNoticeIDs = PreferenceManager.shared.readNoticeIDs ?? []
        guard newReadNoticeIDs.contains(ID) == false else {
            return
        }
        newReadNoticeIDs.append(ID)
        PreferenceManager.shared.readNoticeIDs = newReadNoticeIDs
    }

    func downloadImageSize(url: URL) -> Observable<CGSize> {
        return Observable.create { observer in
            KingfisherManager.shared.retrieveImage(
                with: url
            ) { result in
                switch result {
                case let .success(value):
                    observer.onNext(value.image.size)
                    observer.onCompleted()

                case let .failure(error):
                    LogManager.printDebug(error.localizedDescription)
                    observer.onNext(.zero)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
