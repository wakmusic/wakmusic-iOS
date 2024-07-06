//
//  PlaylistViewModel.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import BaseFeature
import Combine
import Foundation
import RxDataSources
import RxRelay
import RxSwift
import Utility

internal typealias PlayListSectionModel = SectionModel<Int, PlaylistItemModel>

final class PlaylistViewModel: ViewModelType {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let closeButtonDidTapEvent: AnyPublisher<Void, Never>
        let editButtonDidTapEvent: AnyPublisher<Void, Never>
        let playlistTableviewCellDidTapEvent: Observable<IndexPath>
        let playlistTableviewCellDidTapInEditModeEvent: Observable<Int>
        let selectAllSongsButtonDidTapEvent: Observable<Bool>
        let addPlaylistButtonDidTapEvent: Observable<Void>
        let removeSongsButtonDidTapEvent: Observable<Void>
        let itemMovedEvent: Observable<(sourceIndex: IndexPath, destinationIndex: IndexPath)>
    }

    struct Output {
        var willClosePlaylist = PassthroughSubject<Void, Never>()
        var editState = CurrentValueSubject<Bool, Never>(false)
        let dataSource: BehaviorRelay<[PlayListSectionModel]> = BehaviorRelay(value: [])
        let selectedSongIds: BehaviorRelay<Set<String>> = BehaviorRelay(value: [])
        let countOfSongs = CurrentValueSubject<Int, Never>(0)
    }

    private let playState = PlayState.shared
    var isEditing = false
    internal var countOfSelectedSongs = 0
    private var subscription = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()

    init() {
        DEBUG_LOG("✅ PlaylistViewModel 생성")
    }

    deinit {
        DEBUG_LOG("❌ PlaylistViewModel deinit")
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
        input.viewWillAppearEvent.subscribe { [weak self] _ in
            guard let self else { return }
            let count = self.playState.playList.count
            output.countOfSongs.send(count)
        }.disposed(by: disposeBag)

        input.closeButtonDidTapEvent.sink { _ in
            output.willClosePlaylist.send()
        }.store(in: &subscription)

        input.editButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            self.isEditing.toggle()
            output.editState.send(self.isEditing)
        }.store(in: &subscription)

        input.playlistTableviewCellDidTapEvent
            .filter { _ in output.editState.value == false }
            .subscribe(onNext: { indexPath in
            })
            .disposed(by: disposeBag)

        input.playlistTableviewCellDidTapInEditModeEvent
            .withLatestFrom(output.dataSource, resultSelector: { tappedIndex, dataSource in
                return dataSource.first?.items[tappedIndex]
            })
            .compactMap { $0 }
            .withLatestFrom(output.selectedSongIds) { selectedPlaylistItem, selectedSongIds in
                var mutableSelectedSongIds = selectedSongIds
                mutableSelectedSongIds.insert(selectedPlaylistItem.id)
                return mutableSelectedSongIds
            }
            .bind(to: output.selectedSongIds)
            .disposed(by: disposeBag)

        input.selectAllSongsButtonDidTapEvent
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .compactMap { flag, dataSource -> [String]? in
                return flag ? dataSource.first?.items.map(\.id) : []
            }
            .map { Set($0) }
            .bind(to: output.selectedSongIds)
            .disposed(by: disposeBag)

        input.addPlaylistButtonDidTapEvent
            .subscribe { _ in
                output.selectedSongIds.accept([])
                output.editState.send(false)
            }.disposed(by: disposeBag)

        input.removeSongsButtonDidTapEvent
            .withLatestFrom(output.selectedSongIds)
            .subscribe(onNext: { [weak self] selectedIds in
                if selectedIds.count == self?.playState.playList.count {
                    self?.playState.playList.removeAll()
                    output.willClosePlaylist.send()
                } else {
                    let removingIndex = self?.playState.playList.list
                        .filter { selectedIds.contains($0.id) }
                        .enumerated()
                        .map(\.offset)
                    self?.playState.playList.remove(indexs: removingIndex ?? [])
                    output.selectedSongIds.accept([])
                }
            }).disposed(by: disposeBag)

        input.itemMovedEvent
            .map { (sourceIndex: $0.row, destIndex: $1.row) }
            .subscribe { (sourceIndex: Int, destIndex: Int) in
                self.playState.playList.reorderPlaylist(from: sourceIndex, to: destIndex)
            }.disposed(by: disposeBag)
    }

    private func bindTableView(output: Output) {
        /*
         VM.dataSource -> PlayState.playlist.list를 바라보는 구조
         playlist.list에 변경이 일어날 때,list 를 dataSource 에 pull
         */

        // playlist.list에 변경이 일어날 때, 변경사항 pull
        playState.playList.listChanged.sink { [weak self] _ in
            self?.pullForOriginalPlaylist(output: output)
        }.store(in: &subscription)

        // cell 선택 시, cell의 isSelected 속성을 변경시키고 dataSource에 전달
        output.selectedSongIds
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .subscribe(onNext: { [weak self] selectedIds, dataSource in
                guard let self else { return }
                let copiedList = self.playState.playList.list
                let newList = copiedList.map { item -> PlaylistItemModel in
                    return PlaylistItemModel(
                        id: item.id,
                        title: item.title,
                        artist: item.artist,
                        isSelected: selectedIds.contains(item.id)
                    )
                }
            }).disposed(by: disposeBag)

        // 편집 종료 시, 셀 선택 초기화
        output.editState
            .dropFirst()
            .filter { $0 == false }
            .sink { [weak self] _ in
                guard let self else { return }
                output.selectedSongIds.accept([])
                // Comment: 편집모드가 완료 된 시점에서 list를 가져와서 listReordered.send > DB 업데이트
                let list = self.playState.playList.list
                self.playState.playList.listReordered.send(list)
            }.store(in: &subscription)
    }

    private func pullForOriginalPlaylist(output: Output) {
        let originalPlaylist = playState.playList.list
        let playlistModelFromOriginal = originalPlaylist.map { item in
            PlaylistItemModel(
                id: item.id,
                title: item.title,
                artist: item.artist,
                isSelected: output.selectedSongIds.value.contains(item.id)
            )
        }

        let localPlaylist = output.dataSource.value.first?.items ?? []

        if playlistModelFromOriginal != localPlaylist {
            output.dataSource.accept([PlayListSectionModel(model: 0, items: playlistModelFromOriginal)])
        }
    }
}
