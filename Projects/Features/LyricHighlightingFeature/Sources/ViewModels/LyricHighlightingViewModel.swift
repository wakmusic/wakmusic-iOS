//
//  LyricHighlightingViewModel.swift
//  LyricHighlightingFeature
//
//  Created by KTH on 6/3/24.
//  Copyright © 2024 yongbeomkwak. All rights reserved.
//

import BaseFeature
import Foundation
import LogManager
import RxRelay
import RxSwift
import SongsDomainInterface
import Utility

public final class LyricHighlightingViewModel: ViewModelType {
    private var model: LyricHighlightingSenderModel = .init(songID: "", title: "", artist: "")
    private let fetchLyricsUseCase: FetchLyricsUseCase
    private let disposeBag = DisposeBag()

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init(
        model: LyricHighlightingSenderModel,
        fetchLyricsUseCase: any FetchLyricsUseCase
    ) {
        self.model = model
        self.fetchLyricsUseCase = fetchLyricsUseCase
    }

    public struct Input {
        let fetchLyric: PublishSubject<Void> = PublishSubject()
        let didTapHighlighting: BehaviorRelay<Int> = BehaviorRelay(value: -1)
        let didTapSaveButton: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[LyricsEntity]> = BehaviorRelay(value: [])
        let isStorable: BehaviorRelay<Bool> = BehaviorRelay(value: false)
        let goDecoratingScene: PublishSubject<LyricDecoratingSenderModel> = PublishSubject()
        let songTitle: BehaviorRelay<String> = BehaviorRelay(value: "")
        let artist: BehaviorRelay<String> = BehaviorRelay(value: "")
    }

    public func transform(from input: Input) -> Output {
        let output = Output()
        let id: String = self.model.songID

        input.fetchLyric
            .flatMap { [fetchLyricsUseCase] _ -> Observable<[LyricsEntity]> in
                return fetchLyricsUseCase.execute(id: id)
                    .asObservable()
                    .catchAndReturn(
                        [
                            LyricsEntity(text: "기억나 우리 처음 만난날기억나 우리 처음 만난날기억나 우리 처음 만난날기억나 우리 처음 만난날"),
                            LyricsEntity(text: "내게 오던 너의 그 미소가"),
                            LyricsEntity(text: "마치 날 알고 있던 것처럼"),
                            LyricsEntity(text: "매일 스쳐 지나가던 바람처럼"),
                            LyricsEntity(text: "가끔은 우리 사이가 멀어질까"),
                            LyricsEntity(text: "혼자 남아버리는 상상을 해 oh"),
                            LyricsEntity(text: "이런 나를 잡아줘 우리 처음"),
                            LyricsEntity(text: "만난 날처럼 내가 너를 꼭 찾을 수 있게"),
                            LyricsEntity(text: "늘 꿈에서만 그리던"),
                            LyricsEntity(text: "너와 함께 할 모든 날들이"),
                            LyricsEntity(text: "더 희미해지기 전에"),
                            LyricsEntity(text: "나 시간이 없어"),
                            LyricsEntity(text: "지금 닿을 수는 없는 거리 일지라도"),
                            LyricsEntity(text: "꼭 너와 함께 있다는 기분이 들어"),
                            LyricsEntity(text: "널 주저했던 걸음, 마음.나는"),
                            LyricsEntity(text: "왜 이리 바보 같은 지"),
                            LyricsEntity(text: "자신이 없어"),
                            LyricsEntity(text: "늘 같은 곳을 바라보던 너의 그 눈이 좋아"),
                            LyricsEntity(text: "변한 세상에서 너만은 그대로 있어줘"),
                            LyricsEntity(text: "you're my sunshine"),
                            LyricsEntity(text: "늘 같은 곳을 헤매이던 너와 내 시간 속에"),
                            LyricsEntity(text: "날 잊어버린다 해도"),
                            LyricsEntity(text: "다시 한번 너를 만나러 갈 테니까")
                        ]
                    )
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        input.didTapHighlighting
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
            .bind { items in
                output.goDecoratingScene.onNext(
                    .init(
                        title: output.songTitle.value, artist: output.artist.value, highlightingItems: items
                    )
                )
            }
            .disposed(by: disposeBag)

        output.songTitle.accept(model.title)
        output.artist.accept(model.artist)

        output.dataSource
            .map { !$0.filter { $0.isHighlighting }.isEmpty }
            .bind(to: output.isStorable)
            .disposed(by: disposeBag)

        return output
    }
}
