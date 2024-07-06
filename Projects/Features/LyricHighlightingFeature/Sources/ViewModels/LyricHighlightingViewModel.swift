import BaseFeature
import Foundation
import LogManager
import LyricHighlightingFeatureInterface
import RxRelay
import RxSwift
import SongsDomainInterface
import Utility

public final class LyricHighlightingViewModel: ViewModelType {
    private var model: LyricHighlightingRequiredModel = .init(songID: "", title: "", artist: "", highlightingItems: [])
    private let fetchLyricsUseCase: FetchLyricsUseCase
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        model: LyricHighlightingRequiredModel,
        fetchLyricsUseCase: any FetchLyricsUseCase
    ) {
        self.model = model
        self.fetchLyricsUseCase = fetchLyricsUseCase
    }

    public struct Input {
        let fetchLyric: PublishSubject<Void> = PublishSubject()
        let didTapHighlighting: BehaviorRelay<IndexPath> = BehaviorRelay(value: .init(row: -1, section: 0))
        let didTapSaveButton: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[LyricsEntity]> = BehaviorRelay(value: [])
        let isStorable: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let goDecoratingScene: PublishSubject<LyricHighlightingRequiredModel> = PublishSubject()
        let updateSongTitle: BehaviorRelay<String> = BehaviorRelay(value: "")
        let updateArtist: BehaviorRelay<String> = BehaviorRelay(value: "")
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        let songID: String = self.model.songID

        input.fetchLyric
            .flatMap { [fetchLyricsUseCase] _ -> Observable<[LyricsEntity]> in
                return fetchLyricsUseCase.execute(id: songID)
                    .asObservable()
                    .catchAndReturn([])
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.didTapHighlighting
            .map { $0.item }
            .filter { $0 >= 0 }
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .filter { index, entities in
                return entities[index].isHighlighting || entities.filter { $0.isHighlighting }.count < 4
            }
            .map { index, entities in
                var newEntities = entities
                newEntities[index].isHighlighting = !entities[index].isHighlighting
                return newEntities
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.didTapSaveButton
            .withLatestFrom(output.dataSource)
            .filter { !$0.filter { $0.isHighlighting }.isEmpty }
            .map { $0.filter { $0.isHighlighting }.map { $0.text } }
            .map { LyricHighlightingRequiredModel(
                songID: songID,
                title: output.updateSongTitle.value,
                artist: output.updateArtist.value,
                highlightingItems: $0
            ) }
            .do(onNext: { model in
                LogManager.analytics(
                    LyricHighlightingAnalyticsLog.clickLyricHighlightingCompleteButton(id: model.songID)
                )
            })
            .bind(to: output.goDecoratingScene)
            .disposed(by: disposeBag)

        output.updateSongTitle.accept(model.title)
        output.updateArtist.accept(model.artist)

        output.dataSource
            .map { !$0.filter { $0.isHighlighting }.isEmpty }
            .bind(to: output.isStorable)
            .disposed(by: disposeBag)

        return output
    }
}
