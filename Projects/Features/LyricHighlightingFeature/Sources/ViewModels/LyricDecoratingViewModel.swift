import BaseFeature
import Foundation
import LogManager
import LyricDomainInterface
import LyricHighlightingFeatureInterface
import RxRelay
import RxSwift
import SongsDomainInterface
import UIKit
import Utility

final class LyricDecoratingViewModel: ViewModelType {
    private var model: LyricHighlightingRequiredModel = .init(songID: "", title: "", artist: "", highlightingItems: [])
    private let fetchDecoratingBackgroundUseCase: FetchDecoratingBackgroundUseCase
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        model: LyricHighlightingRequiredModel,
        fetchDecoratingBackgroundUseCase: any FetchDecoratingBackgroundUseCase
    ) {
        self.model = model
        self.fetchDecoratingBackgroundUseCase = fetchDecoratingBackgroundUseCase
    }

    public struct Input {
        let fetchBackgroundImage: PublishSubject<Void> = PublishSubject()
        let didTapBackground: PublishSubject<IndexPath> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[DecoratingBackgroundEntity]> = BehaviorRelay(value: [])
        let highlightingItems: BehaviorRelay<String> = BehaviorRelay(value: "")
        let updateSongTitle: BehaviorRelay<String> = BehaviorRelay(value: "")
        let updateArtist: BehaviorRelay<String> = BehaviorRelay(value: "")
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        #warning("TO-DO: catchAndReturn은 []로 수정해야함")
        input.fetchBackgroundImage
            .flatMap { [fetchDecoratingBackgroundUseCase] _ -> Observable<[DecoratingBackgroundEntity]> in
                return fetchDecoratingBackgroundUseCase.execute()
                    .asObservable()
                    .catchAndReturn(
                        [.init(name: "Wm", image: ""),
                         .init(name: "Wg", image: ""),
                         .init(name: "Color1", image: ""),
                         .init(name: "Color2", image: ""),
                         .init(name: "Color3", image: ""),
                         .init(name: "Color4", image: ""),
                         .init(name: "Color5", image: ""),
                         .init(name: "Color6", image: "")
                        ]
                    )
            }
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
