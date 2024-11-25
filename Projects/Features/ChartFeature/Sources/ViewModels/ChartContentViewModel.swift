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

    public init(
        type: ChartDateType,
        fetchChartRankingUseCase: FetchChartRankingUseCase
    ) {
        self.type = type
        self.fetchChartRankingUseCase = fetchChartRankingUseCase
    }

    public struct Input {
        let songTapped: PublishSubject<IndexPath> = PublishSubject()
        let allSongSelected: PublishSubject<Bool> = PublishSubject()
        let halfPlayTapped: PublishSubject<HalfPlayType> = PublishSubject()
        let shufflePlayTapped: PublishSubject<Void> = PublishSubject()
        let refreshPulled: PublishSubject<Void> = PublishSubject()
    }

    public struct Output {
        let dataSource: BehaviorRelay<[ChartRankingEntity]> = BehaviorRelay(value: [])
        let updateTime: BehaviorRelay<String> = BehaviorRelay(value: "")
        let indexOfSelectedSongs: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
        let songEntityOfSelectedSongs: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
        let groupPlaySongs: PublishSubject<(playlistTitle: String, songs: [SongEntity])> = PublishSubject()
        let showToast: PublishSubject<String> = PublishSubject()
        let showLogin: PublishSubject<Void> = .init()
    }

    public func transform(from input: Input) -> Output {
        let output = Output()

        let fetchChartRankingUseCase = fetchChartRankingUseCase
            .execute(type: type)
            .debug("fetchChartRankingUseCase")
            .catchAndReturn(.init(updatedAt: "팬치들 미안해요 ㅠㅠ 잠시만 기다려주세요.", songs: []))
            .asObservable()

        fetchChartRankingUseCase
            .subscribe(onNext: { entity in
                output.updateTime.accept(entity.updatedAt)
                output.dataSource.accept(entity.songs)
            })
            .disposed(by: disposeBag)

        input.refreshPulled
            .flatMap { _ -> Observable<ChartEntity> in
                return fetchChartRankingUseCase
            }
            .subscribe(onNext: { entity in
                output.updateTime.accept(entity.updatedAt)
                output.dataSource.accept(entity.songs)
            })
            .disposed(by: disposeBag)

        input.songTapped
            .map { $0.row }
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

        Utility.PreferenceManager.shared.$startPage
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
                        views: dataSource[$0].views,
                        date: dataSource[$0].date
                    )
                }
            }
            .bind(to: output.songEntityOfSelectedSongs)
            .disposed(by: disposeBag)

        input.halfPlayTapped
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .bind(with: self) { owner, tuple in
                let (type, songs) = tuple
                let chartsArray = owner.halfSplitArray(array: songs, type: type)
                let songsArray = owner.toSongEntities(array: chartsArray)
                let title = type.playlistTitleString
                output.groupPlaySongs.onNext((title, songsArray))
            }
            .disposed(by: disposeBag)

        input.shufflePlayTapped
            .withLatestFrom(output.dataSource)
            .map { [weak self] source -> [ChartRankingEntity] in
                self?.shuffledSplitArray(array: source) ?? []
            }
            .map { [weak self] entities -> [SongEntity] in
                self?.toSongEntities(array: entities) ?? []
            }
            .map { ("왁뮤차트 TOP100 랜덤", $0) }
            .bind(to: output.groupPlaySongs)
            .disposed(by: disposeBag)

        return output
    }
}

private extension ChartContentViewModel {
    func halfSplitArray<T>(array: [T], type: HalfPlayType, limit: Int = 50) -> [T] {
        switch type {
        case .front:
            return Array(array.prefix(limit))
        case .back:
            return array.count > limit ? Array(array[limit ..< array.count].prefix(limit)) : []
        }
    }

    func shuffledSplitArray<T>(array: [T], limit: Int = 50) -> [T] {
        let shuffledArray = array.shuffled()
        let result = Array(shuffledArray.prefix(limit))
        return result
    }

    func toSongEntities(array: [ChartRankingEntity]) -> [SongEntity] {
        let songEntities: [SongEntity] = array.map {
            return SongEntity(
                id: $0.id,
                title: $0.title,
                artist: $0.artist,
                views: $0.views,
                date: $0.date
            )
        }
        return songEntities
    }
}
