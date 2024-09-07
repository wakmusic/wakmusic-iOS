import BaseFeature
import Foundation
import LogManager
import LyricHighlightingFeatureInterface
import RxRelay
import RxSwift
import SongsDomainInterface
import Utility

public final class LyricHighlightingViewModel: ViewModelType {
    private let model: LyricHighlightingRequiredModel
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
        let didTapActivateButton: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let didTapHighlighting: BehaviorRelay<IndexPath> = BehaviorRelay(value: .init(row: -1, section: 0))
        let didTapSaveButton: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[LyricsEntity.Lyric]> = BehaviorRelay(value: [])
        let isStorable: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let goDecoratingScene: PublishSubject<LyricHighlightingRequiredModel> = PublishSubject()
        let updateInfo: BehaviorRelay<LyricHighlightingRequiredModel> = BehaviorRelay(value: .init(
            songID: "",
            title: "",
            artist: ""
        ))
        let updateProvider: PublishSubject<String> = .init()
        let showToast: PublishSubject<String> = .init()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        let songID: String = self.model.songID

        input.fetchLyric
            .flatMap { [fetchLyricsUseCase] _ -> Observable<LyricsEntity> in
                return fetchLyricsUseCase.execute(id: songID)
                    .asObservable()
                    .catchAndReturn(.init(provider: "", lyrics: []))
                    .do(onNext: { entity in
                        output.updateProvider.onNext(entity.lyrics.isEmpty ? "" : "자막 제공 : \(entity.provider)")
                    })
            }
            .map { $0.lyrics }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.didTapHighlighting
            .withLatestFrom(input.didTapActivateButton) { ($0, $1) }
            .filter { $0.1 }
            .map { $0.0.item }
            .filter { $0 >= 0 }
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .filter { index, entities in
                let currentTotalLineCount: Int = entities.filter { $0.isHighlighting }
                    .map { $0.text.components(separatedBy: "\n").count }
                    .reduce(0, +)
                let nowSelectItemLineCount: Int = entities[index].text
                    .components(separatedBy: "\n").count
                guard entities[index].isHighlighting || (currentTotalLineCount + nowSelectItemLineCount <= 4) else {
                    output.showToast.onNext("가사는 최대 4줄까지 선택 가능합니다.")
                    return false
                }
                return true
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
                title: output.updateInfo.value.title,
                artist: output.updateInfo.value.artist,
                highlightingItems: $0
            ) }
            .bind(to: output.goDecoratingScene)
            .disposed(by: disposeBag)

        output.updateInfo.accept(
            .init(
                songID: model.songID, title: model.title, artist: model.artist
            )
        )

        output.dataSource
            .map { !$0.filter { $0.isHighlighting }.isEmpty }
            .bind(to: output.isStorable)
            .disposed(by: disposeBag)

        return output
    }
}
