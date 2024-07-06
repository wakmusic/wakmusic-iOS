import BaseFeature
import Foundation
import ImageDomainInterface
import LogManager
import LyricHighlightingFeatureInterface
import RxRelay
import RxSwift
import SongsDomainInterface
import UIKit
import Utility

final class LyricDecoratingViewModel: ViewModelType {
    private let model: LyricHighlightingRequiredModel
    private let fetchLyricDecoratingBackgroundUseCase: FetchLyricDecoratingBackgroundUseCase
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        model: LyricHighlightingRequiredModel,
        fetchLyricDecoratingBackgroundUseCase: any FetchLyricDecoratingBackgroundUseCase
    ) {
        self.model = model
        self.fetchLyricDecoratingBackgroundUseCase = fetchLyricDecoratingBackgroundUseCase
    }

    public struct Input {
        let fetchBackgroundImage: PublishSubject<Void> = PublishSubject()
        let didTapBackground: PublishSubject<IndexPath> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[LyricDecoratingBackgroundEntity]> = BehaviorRelay(value: [])
        let highlightingItems: BehaviorRelay<String> = BehaviorRelay(value: "")
        let updateInfo: BehaviorRelay<LyricHighlightingRequiredModel> = BehaviorRelay(value: .init(
            songID: "",
            title: "",
            artist: ""
        ))
        let updateDecoratingImage: BehaviorRelay<String> = BehaviorRelay(value: "")
        let occurredError: PublishSubject<String> = PublishSubject()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        input.fetchBackgroundImage
            .flatMap { [fetchLyricDecoratingBackgroundUseCase] _ -> Observable<[LyricDecoratingBackgroundEntity]> in
                return fetchLyricDecoratingBackgroundUseCase.execute()
                    .asObservable()
                    .catchAndReturn([])
            }
            .do(onNext: { entities in
                guard !entities.isEmpty else {
                    output.occurredError.onNext("서버에서 문제가 발생하였습니다.\n잠시 후 다시 시도해주세요!")
                    return
                }
                output.updateDecoratingImage.accept(entities[0].url)
            })
            .map { entities in
                guard !entities.isEmpty else { return entities }
                var newEntities = entities
                newEntities[0].isSelected = true
                return newEntities
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        output.highlightingItems
            .accept(model.highlightingItems.joined(separator: "\n"))
        output.updateInfo.accept(
            .init(
                songID: model.songID, title: model.title, artist: model.artist
            )
        )

        input.didTapBackground
            .map { $0.item }
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .do(onNext: { index, entities in
                output.updateDecoratingImage.accept(entities[index].url)
            })
            .map { index, entities in
                var newEntities = entities
                if let i = entities.firstIndex(where: { $0.isSelected }) {
                    newEntities[i].isSelected = false
                }
                newEntities[index].isSelected = true
                return newEntities
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        return output
    }
}
