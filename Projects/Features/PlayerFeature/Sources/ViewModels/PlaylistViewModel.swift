//
//  PlaylistViewModel.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import Combine
import RxSwift
import RxRelay
import RxDataSources
import BaseFeature
import YouTubePlayerKit
import Utility
import CommonFeature
import DomainModule

internal typealias PlayListSectionModel = SectionModel<Int, PlayListItem>

final class PlaylistViewModel: ViewModelType {
    struct Input {
        let closeButtonDidTapEvent: AnyPublisher<Void, Never>
        let editButtonDidTapEvent: AnyPublisher<Void, Never>
        let repeatButtonDidTapEvent: AnyPublisher<Void, Never>
        let prevButtonDidTapEvent: AnyPublisher<Void, Never>
        let playButtonDidTapEvent: AnyPublisher<Void, Never>
        let nextButtonDidTapEvent: AnyPublisher<Void, Never>
        let shuffleButtonDidTapEvent: AnyPublisher<Void, Never>
        let playlistTableviewCellDidTapEvent: Observable<IndexPath>
        let playlistTableviewCellDidTapInEditModeEvent: Observable<Int>
        let selectAllSongsButtonDidTapEvent: Observable<Bool>
        let addPlaylistButtonDidTapEvent: Observable<Void>
        let removeSongsButtonDidTapEvent: Observable<Void>
        let itemMovedEvent: Observable<(sourceIndex: IndexPath, destinationIndex: IndexPath)>
        
    }
    struct Output {
        var playerState = CurrentValueSubject<YouTubePlayer.PlaybackState, Never>(.unstarted)
        var willClosePlaylist = PassthroughSubject<Void, Never>()
        var editState = CurrentValueSubject<Bool, Never>(false)
        var thumbnailImageURL = CurrentValueSubject<String, Never>("")
        var playTimeValue = CurrentValueSubject<Float, Never>(0.0)
        var totalTimeValue = CurrentValueSubject<Float, Never>(0.0)
        var currentSongIndex = CurrentValueSubject<Int, Never>(0)
        var repeatMode = CurrentValueSubject<RepeatMode, Never>(.none)
        var shuffleMode = CurrentValueSubject<ShuffleMode, Never>(.off)
        let dataSource: BehaviorRelay<[PlayListSectionModel]> = BehaviorRelay(value: [])
        let indexOfSelectedSongs: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
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
        bindPlayStateChanged(output: output)
        bindCurrentSongChanged(output: output)
        bindProgress(output: output)
        bindRepeatMode(output: output)
        bindShuffleMode(output: output)
        
        output.indexOfSelectedSongs
            .map { $0.count }
            .subscribe(onNext: { [weak self] count in
                self?.countOfSelectedSongs = count
            }).disposed(by: disposeBag)
        
        return output
    }
    
    private func bindInput(input: Input, output: Output) {
        input.closeButtonDidTapEvent.sink { _ in
            output.willClosePlaylist.send()
        }.store(in: &subscription)
        
        input.editButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            self.isEditing.toggle()
            output.editState.send(self.isEditing)
        }.store(in: &subscription)
        
        input.repeatButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            self.playState.repeatMode.rotate()
        }.store(in: &subscription)
        
        input.prevButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            switch self.playState.shuffleMode {
            case .off:
                self.playState.backward()
            case .on:
                self.playState.shufflePlay()
            }
        }.store(in: &subscription)
        
        input.playButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            let state = self.playState.state
            state == .playing ? self.playState.pause() : self.playState.play()
        }.store(in: &subscription)
        
        input.nextButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            switch self.playState.shuffleMode {
            case .off:
                self.playState.forward()
            case .on:
                self.playState.shufflePlay()
            }
        }.store(in: &subscription)
        
        input.shuffleButtonDidTapEvent.sink { [weak self] _ in
            guard let self else { return }
            self.playState.shuffleMode.toggle()
        }.store(in: &subscription)
        
        input.playlistTableviewCellDidTapEvent
            .filter { _ in output.editState.value == false }
            .subscribe(onNext: { [weak self] indexPath in
                self?.playState.playList.changeCurrentPlayIndex(to: indexPath.row)
                self?.playState.loadInPlaylist(at: indexPath.row)
            })
            .disposed(by: disposeBag)
        
        input.playlistTableviewCellDidTapInEditModeEvent
            .withLatestFrom(output.indexOfSelectedSongs, resultSelector: { (tappedIndex, selectedSongs) -> [Int] in
                if let indexToRemove = selectedSongs.firstIndex(of: tappedIndex) {
                    var newSelectedSongs = selectedSongs
                    newSelectedSongs.remove(at: indexToRemove)
                    return newSelectedSongs
                } else {
                    return selectedSongs + [tappedIndex]
                }
            })
            .map { $0.sorted { $0 < $1 } }
            .bind(to: output.indexOfSelectedSongs)
            .disposed(by: disposeBag)
        
        input.selectAllSongsButtonDidTapEvent
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { (flag, dataSource) -> [Int] in
                return flag ? Array(0..<dataSource.first!.items.count) : []
            }
            .bind(to: output.indexOfSelectedSongs)
            .disposed(by: disposeBag)
        
        input.addPlaylistButtonDidTapEvent
            .subscribe { _ in
                output.indexOfSelectedSongs.accept([])
                output.editState.send(false)
            }.disposed(by: disposeBag)
        
        input.removeSongsButtonDidTapEvent
            .withLatestFrom(output.indexOfSelectedSongs)
            .subscribe(onNext: { [weak self] selectedIndexs in
                if selectedIndexs.count == self?.playState.playList.count {
                    self?.playState.playList.removeAll()
                    self?.playState.switchPlayerMode(to: .close)
                    output.willClosePlaylist.send()
                } else {
                    self?.playState.playList.remove(indexs: selectedIndexs)
                    output.indexOfSelectedSongs.accept([])
                }
            }).disposed(by: disposeBag)
        
        input.itemMovedEvent
            .map { (sourceIndex: $0.row, destIndex: $1.row ) }
            .subscribe { (sourceIndex: Int, destIndex: Int) in
                self.playState.playList.reorderPlaylist(from: sourceIndex, to: destIndex)
            }.disposed(by: disposeBag)
        
        input.itemMovedEvent
            .map { (sourceIndex: $0.row, destIndex: $1.row ) }
            .subscribe { (sourceIndex: Int, destIndex: Int) in
                /* indexOfSelectedSongs 갱신부 */
                var selectedIndexs = output.indexOfSelectedSongs.value // 현재 선택된 인덱스 모음
                let sourceIsSelected: Bool = selectedIndexs.contains(where: { $0 == sourceIndex }) // 선택된 것을 움직 였는지 ?
                
                //선택된 인덱스 배열 안에 source(시작점)이 있다는 뜻은 선택된 것을 옮긴다는 뜻
                //그러므로 일단 지워준다.
                if sourceIsSelected {
                    let pos = selectedIndexs.firstIndex(where: { $0 == sourceIndex })!
                    selectedIndexs.remove(at: pos)
                }
                
                selectedIndexs = selectedIndexs.map({ i -> Int in
                    // 옮기기 시작한 위치와 도착한 위치가 i를 기준으로 앞일 때 아무 영향 없음
                    if sourceIndex < i && i > destIndex { return i }
                    
                    // 옮기기 시작한 위치는 i 앞, 도착한 위치가 i 또는 i 뒤일 경우 i는 앞으로 한 칸 가야함
                    if sourceIndex < i && i <= destIndex { return i - 1 }
                    
                    // 옮기기 시작한 위치는 i 뒤, 도착한 위치가 i 또는 i 앞일 경우 i는 뒤로 한칸 가야함
                    // 단 옮겨질 위치가 배열의 끝일 경우는 그대로 있음
                    if i < sourceIndex && destIndex <= i { return i + 1 }

                    // 옮기기 시작한 위치는 i 뒤, 도착한 위치가 i 뒤 일 경우 아무 영향 없음
                    if sourceIndex > i && i < destIndex { return i }
                    
                    return i
                })
                
                // 선택된 것을 건드렸으므로 dest 인덱스로 갱신하여 넣어준다
                if sourceIsSelected { selectedIndexs.append(destIndex) }
                
                selectedIndexs.sort()
                
                output.indexOfSelectedSongs.accept(selectedIndexs)
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
        output.indexOfSelectedSongs
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .subscribe(onNext: { [weak self] (selectedIndexs, dataSource) in
                guard let self else { return }
                let copiedList = self.playState.playList.list
                let newList = copiedList.enumerated().map { (index, item) -> PlayListItem in
                    var newItem = item
                    newItem.item.isSelected = selectedIndexs.contains(index)
                    return newItem
                }
                self.playState.playList.list = newList
            }).disposed(by: disposeBag)
        
        // 편집 종료 시, 셀 선택 초기화
        output.editState
            .dropFirst()
            .filter { $0 == false }
            .sink { [weak self] _ in
                guard let self else { return }
                output.indexOfSelectedSongs.accept([])
                //Comment: 편집모드가 완료 된 시점에서 list를 가져와서 listReordered.send > DB 업데이트
                let list = self.playState.playList.list
                self.playState.playList.listReordered.send(list)
            }.store(in: &subscription)
    }
    
    private func bindPlayStateChanged(output: Output) {
        playState.$state.sink { state in
            output.playerState.send(state)
        }.store(in: &subscription)
    }
    
    private func bindCurrentSongChanged(output: Output) {
        playState.$currentSong.sink { [weak self] song in
            guard let self else { return }
            guard let song = song else { return }
            let thumbnailURL = Utility.WMImageAPI.fetchYoutubeThumbnail(id: song.id).toString
            output.thumbnailImageURL.send(thumbnailURL)
            guard let currentSongIndex = self.playState.playList.currentPlayIndex else { return }
            output.currentSongIndex.send(currentSongIndex)
        }.store(in: &subscription)
    }
    
    private func bindProgress(output: Output) {
        playState.$progress.sink { progress in
            output.playTimeValue.send(Float(progress.currentProgress))
            output.totalTimeValue.send(Float(progress.endProgress))
        }.store(in: &subscription)
    }
    
    private func bindRepeatMode(output: Output) {
        playState.$repeatMode.sink { repeatMode in
            output.repeatMode.send(repeatMode)
        }.store(in: &subscription)
    }
    
    private func bindShuffleMode(output: Output) {
        playState.$shuffleMode.sink { shuffleMode in
            output.shuffleMode.send(shuffleMode)
        }.store(in: &subscription)
    }
    
    private func pullForOriginalPlaylist(output: Output) {
        let originalPlaylist = playState.playList.list
        let localPlaylist = output.dataSource.value.first?.items ?? []

        if originalPlaylist != localPlaylist {
            output.dataSource.accept([PlayListSectionModel(model: 0, items: originalPlaylist)])
        }
        
    }
    
}
