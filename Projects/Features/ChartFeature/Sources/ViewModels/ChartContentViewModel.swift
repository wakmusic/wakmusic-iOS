import BaseFeature
import ChartDomainInterface
import Foundation
import RxRelay
import RxSwift
import SongsDomainInterface
import Utility

public final class ChartContentViewModel: ViewModelType {
    public let type: ChartDateType

    private let disposeBag = DisposeBag()
    private let fetchChartRankingUseCase: FetchChartRankingUseCase
    private let fetchChartUpdateTimeUseCase: FetchChartUpdateTimeUseCase

    public init(
        type: ChartDateType,
        fetchChartRankingUseCase: FetchChartRankingUseCase,
        fetchChartUpdateTimeUseCase: FetchChartUpdateTimeUseCase
    ) {
        self.type = type
        self.fetchChartRankingUseCase = fetchChartRankingUseCase
        self.fetchChartUpdateTimeUseCase = fetchChartUpdateTimeUseCase
    }

    public struct Input {
        var songTapped: PublishSubject<Int> = PublishSubject()
        var allSongSelected: PublishSubject<Bool> = PublishSubject()
        let groupPlayTapped: PublishSubject<PlayEvent> = PublishSubject()
        var refreshPulled: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        var dataSource: BehaviorRelay<[ChartRankingEntity]> = BehaviorRelay(value: [])
        var updateTime: BehaviorRelay<String> = BehaviorRelay(value: "")
        let indexOfSelectedSongs: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
        let songEntityOfSelectedSongs: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
        let groupPlaySongs: PublishSubject<[SongEntity]> = PublishSubject()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        let dataSourceForZip = Observable.zip(
            fetchChartUpdateTimeUseCase
                .execute(type: type)
                .catchAndReturn("팬치들 미안해요 ㅠㅠ 잠시만 기다려주세요") // 이스터에그 🥰
                .asObservable(),
            fetchChartRankingUseCase
                .execute(type: type)
                .debug("fetchChartRankingUseCase")
                .catchAndReturn([])
                .asObservable()
        )

        dataSourceForZip
            .subscribe(onNext: { time, data in
                output.updateTime.accept(time)
                output.dataSource.accept(data)
            })
            .disposed(by: disposeBag)

        input.refreshPulled
            .flatMap { _ -> Observable<(String, [ChartRankingEntity])> in
                return dataSourceForZip
            }
            .subscribe(onNext: { time, data in
                output.updateTime.accept(time)
                output.dataSource.accept(data)
            })
            .disposed(by: disposeBag)

        input.songTapped
            .withLatestFrom(output.indexOfSelectedSongs, resultSelector: { index, selectedSongs -> [Int] in
                if selectedSongs.contains(index) {
                    guard let removeTargetIndex = selectedSongs.firstIndex(where: { $0 == index })
                    else { return selectedSongs }
                    var newSelectedSongs = selectedSongs
                    newSelectedSongs.remove(at: removeTargetIndex)
                    return newSelectedSongs
                } else { return selectedSongs + [index] }
            })
            .map { $0.sorted { $0 < $1 } }
            .bind(to: output.indexOfSelectedSongs)
            .disposed(by: disposeBag)

        input.allSongSelected
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { flag, dataSource -> [Int] in
                return flag ? Array(0 ..< dataSource.count) : []
            }
            .bind(to: output.indexOfSelectedSongs)
            .disposed(by: disposeBag)

        Utility.PreferenceManager.$startPage
            .skip(1)
            .map { _ in [] }
            .bind(to: output.indexOfSelectedSongs)
            .disposed(by: disposeBag)

        output.indexOfSelectedSongs
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { selectedSongs, dataSource in
                var newModel = dataSource
                newModel.indices.forEach { newModel[$0].isSelected = false }
                selectedSongs.forEach { i in
                    newModel[i].isSelected = true
                }
                return newModel
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)

        output.indexOfSelectedSongs
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { indexOfSelectedSongs, dataSource -> [SongEntity] in

                return indexOfSelectedSongs.map {
                    SongEntity(
                        id: dataSource[$0].id,
                        title: dataSource[$0].title,
                        artist: dataSource[$0].artist,
                        remix: "",
                        reaction: "",
                        views: dataSource[$0].views,
                        last: dataSource[$0].last,
                        date: dataSource[$0].date
                    )
                }
            }
            .bind(to: output.songEntityOfSelectedSongs)
            .disposed(by: disposeBag)

        input.groupPlayTapped
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { type, dataSource -> (PlayEvent, [SongEntity]) in
                let songEntities: [SongEntity] = dataSource.map {
                    return SongEntity(
                        id: $0.id,
                        title: $0.title,
                        artist: $0.artist,
                        remix: "",
                        reaction: "",
                        views: $0.views,
                        last: $0.last,
                        date: $0.date
                    )
                }
                return (type, songEntities)
            }
            .map { type, dataSource -> [SongEntity] in
                switch type {
                case .allPlay:
                    return dataSource
                case .shufflePlay:
                    return dataSource.shuffled()
                }
            }
            .bind(to: output.groupPlaySongs)
            .disposed(by: disposeBag)

        return output
    }
}
