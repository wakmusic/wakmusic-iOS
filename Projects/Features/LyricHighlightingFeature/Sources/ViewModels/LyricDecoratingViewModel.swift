import BaseFeature
import Foundation
import LogManager
import ImageDomainInterface
import LyricHighlightingFeatureInterface
import RxRelay
import RxSwift
import SongsDomainInterface
import UIKit
import Utility

final class LyricDecoratingViewModel: ViewModelType {
    private var model: LyricHighlightingRequiredModel = .init(songID: "", title: "", artist: "", highlightingItems: [])
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
        let updateSongTitle: BehaviorRelay<String> = BehaviorRelay(value: "")
        let updateArtist: BehaviorRelay<String> = BehaviorRelay(value: "")
        let updateDecoratingImage: BehaviorRelay<String> = BehaviorRelay(value: "")
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        #warning("TO-DO: catchAndReturn은 []로 수정해야함")
        input.fetchBackgroundImage
            .flatMap { [fetchLyricDecoratingBackgroundUseCase] _ -> Observable<[LyricDecoratingBackgroundEntity]> in
                return fetchLyricDecoratingBackgroundUseCase.execute()
                    .asObservable()
                    .catchAndReturn(
                        [
                            .init(name: "Wm", url: ""),
                            .init(name: "Wg", url: ""),
                            .init(name: "Color1", url: ""),
                            .init(name: "Color2", url: ""),
                            .init(name: "Color3", url: ""),
                            .init(name: "Color4", url: ""),
                            .init(name: "Color5", url: ""),
                            .init(name: "Color6", url: "")
                        ]
                    )
            }
            .do(onNext: { entities in
                guard !entities.isEmpty else { return }
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
        output.updateSongTitle.accept(model.title)
        output.updateArtist.accept(model.artist)

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
