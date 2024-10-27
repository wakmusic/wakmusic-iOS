import BaseFeature
import Combine
import Foundation
import LogManager
import RxDataSources
import RxRelay
import RxSwift
import Utility

internal typealias PlaylistSectionModel = SectionModel<Int, PlaylistItemModel>

final class PlaylistViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let viewWillDisappearEvent: Observable<Void>
        let closeButtonDidTapEvent: AnyPublisher<Void, Never>
        let editButtonDidTapEvent: AnyPublisher<Void, Never>
        let playlistTableviewCellDidTapEvent: Observable<IndexPath>
        let playlistTableviewCellDidTapInEditModeEvent: Observable<Int>
        let selectAllSongsButtonDidTapEvent: Observable<Bool>
        let addPlaylistButtonDidTapEvent: Observable<Void>
        let removeSongsButtonDidTapEvent: Observable<Void>
        let itemMovedEvent: Observable<(sourceIndex: IndexPath, destinationIndex: IndexPath)>
        let didLongPressedSongEvent: Observable<Int>
        let didTapSwippedRemoveButtonEvent: Observable<Int>
    }

    struct Output {
        enum EditingReloadStrategy {
            case reloadSection
            case reloadAll
        }

        var shouldClosePlaylist = PassthroughSubject<Void, Never>()
        var editState = CurrentValueSubject<(Bool, EditingReloadStrategy), Never>((false, .reloadAll))
        let playlists: BehaviorRelay<[PlaylistItemModel]> = BehaviorRelay(value: [])
        let selectedSongIds: BehaviorRelay<Set<String>> = BehaviorRelay(value: [])
        let countOfSongs = CurrentValueSubject<Int, Never>(0)
    }

    private let playState = PlayState.shared
    var isEditing = false
    internal var countOfSelectedSongs = 0
    private var subscription = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()

    init() {
        LogManager.printDebug("✅ PlaylistViewModel 생성")
    }

    deinit {
        LogManager.printDebug("❌ PlaylistViewModel deinit")
    }

    func transform(from input: Input) -> Output {
        let output = Output()

        bindInput(input: input, output: output)
        bindTableView(output: output)

        output.selectedSongIds
            .map { $0.count }
            .subscribe(onNext: { [weak self] count in
                self?.countOfSelectedSongs = count
            }).disposed(by: disposeBag)

        return output
    }

    private func bindInput(input: Input, output: Output) {
        input.viewWillAppearEvent.subscribe { [playState] _ in
            let currentPlaylist = playState.currentPlaylist
            output.playlists.accept(currentPlaylist.toModel(selectedIds: []))
            output.countOfSongs.send(currentPlaylist.count)
        }.disposed(by: disposeBag)

        input.closeButtonDidTapEvent.sink { _ in
            output.shouldClosePlaylist.send()
        }.store(in: &subscription)

        input.editButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            let log = if !self.isEditing {
                CommonAnalyticsLog.clickEditButton(location: .playlist)
            } else {
                CommonAnalyticsLog.clickEditCompleteButton(location: .playlist)
            }
            LogManager.analytics(log)

            self.isEditing.toggle()
            output.editState.send((self.isEditing, .reloadAll))
        }.store(in: &subscription)

        input.playlistTableviewCellDidTapEvent
            .filter { _ in output.editState.value.0 == false }
            .subscribe(onNext: { indexPath in
            })
            .disposed(by: disposeBag)

        input.playlistTableviewCellDidTapInEditModeEvent
            .withLatestFrom(output.playlists, resultSelector: { tappedIndex, dataSource in
                return dataSource[tappedIndex]
            })
            .withLatestFrom(output.selectedSongIds) { selectedPlaylistItem, selectedSongIds in
                var mutableSelectedSongIds = selectedSongIds
                if mutableSelectedSongIds.contains(selectedPlaylistItem.id) {
                    mutableSelectedSongIds.remove(selectedPlaylistItem.id)
                } else {
                    mutableSelectedSongIds.insert(selectedPlaylistItem.id)
                }
                return mutableSelectedSongIds
            }
            .bind(to: output.selectedSongIds)
            .disposed(by: disposeBag)

        input.selectAllSongsButtonDidTapEvent
            .withLatestFrom(output.playlists) { ($0, $1) }
            .compactMap { flag, dataSource -> [String]? in
                return flag ? dataSource.map(\.id) : []
            }
            .map { Set($0) }
            .bind(to: output.selectedSongIds)
            .disposed(by: disposeBag)

        input.addPlaylistButtonDidTapEvent
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                output.selectedSongIds.accept([])
                output.editState.send((false, .reloadAll))
                owner.isEditing = false
            })
            .disposed(by: disposeBag)

        input.removeSongsButtonDidTapEvent
            .withLatestFrom(output.selectedSongIds)
            .withUnretained(self)
            .subscribe(onNext: { owner, selectedIds in
                if selectedIds.count == output.playlists.value.count {
                    output.playlists.accept([])
                    output.selectedSongIds.accept([])
                    output.editState.send((false, .reloadAll))
                    output.shouldClosePlaylist.send()
                } else {
                    let removedPlaylists = output.playlists.value
                        .filter { !selectedIds.contains($0.id) }
                    output.playlists.accept(removedPlaylists)
                    output.selectedSongIds.accept([])
                }
                owner.isEditing = false
                output.countOfSongs.send(output.playlists.value.count)
            }).disposed(by: disposeBag)

        input.didTapSwippedRemoveButtonEvent
            .bind(with: self, onNext: { owner, index in
                var mutablePlaylist = output.playlists.value
                mutablePlaylist.remove(at: index)
                output.playlists.accept(mutablePlaylist)
                output.countOfSongs.send(mutablePlaylist.count)

                owner.playState.remove(indexs: [index])
            })
            .disposed(by: disposeBag)

        input.itemMovedEvent
            .map { (sourceIndex: $0.row, destIndex: $1.row) }
            .subscribe { (sourceIndex: Int, destIndex: Int) in
                var playlists = output.playlists.value
                let movedData = playlists[sourceIndex]
                playlists.remove(at: sourceIndex)
                playlists.insert(movedData, at: destIndex)
                output.playlists.accept(playlists)
            }.disposed(by: disposeBag)

        input.didLongPressedSongEvent
            .compactMap { output.playlists.value[safe: $0] }
            .bind(with: self) { owner, item in
                guard !owner.isEditing else { return }

                owner.isEditing.toggle()

                var mutableSelectedSongIds = output.selectedSongIds.value
                if mutableSelectedSongIds.contains(item.id) {
                    mutableSelectedSongIds.remove(item.id)
                } else {
                    mutableSelectedSongIds.insert(item.id)
                }

                output.editState.send((owner.isEditing, .reloadSection))
                output.selectedSongIds.accept(mutableSelectedSongIds)
            }
            .disposed(by: disposeBag)
    }

    private func bindTableView(output: Output) {
        /*
         VM.dataSource -> PlayState.playlist.list를 바라보는 구조
         playlist.list에 변경이 일어날 때,list 를 dataSource 에 pull
         */

        // playlist.list에 변경이 일어날 때, 변경사항 pull
        playState.listChangedPublisher.sink { [weak self] _ in
            self?.pullForOriginalPlaylist(output: output)
        }.store(in: &subscription)

        // 편집 종료 시, 셀 선택 초기화
        output.editState
            .dropFirst()
            .filter { $0.0 == false }
            .sink { [playState] _ in
                output.selectedSongIds.accept([])
                playState.update(contentsOf: output.playlists.value.toPlayStateItem())
            }.store(in: &subscription)
    }

    private func pullForOriginalPlaylist(output: Output) {
        let originalPlaylist = playState.currentPlaylist
        let playlistModelFromOriginal = originalPlaylist.map { item in
            PlaylistItemModel(
                id: item.id,
                title: item.title,
                artist: item.artist,
                isSelected: output.selectedSongIds.value.contains(item.id)
            )
        }

        let localPlaylist = output.playlists.value

        if playlistModelFromOriginal != localPlaylist {
            output.playlists.accept(localPlaylist)
        }
    }
}

private extension [BaseFeature.PlaylistItem] {
    func toModel(selectedIds: Set<String>) -> [PlaylistItemModel] {
        self.map { item in
            PlaylistItemModel(
                id: item.id,
                title: item.title,
                artist: item.artist,
                isSelected: selectedIds.contains(item.id)
            )
        }
    }
}

private extension [PlaylistItemModel] {
    func toPlayStateItem() -> [PlaylistItem] {
        self.map { item in
            PlaylistItem(id: item.id, title: item.title, artist: item.artist)
        }
    }
}
