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

internal typealias PlayListSectionModel = SectionModel<Int, SongEntity>

final class PlaylistViewModel: ViewModelType {
    struct Input {
        let closeButtonDidTapEvent: AnyPublisher<Void, Never>
        let editButtonDidTapEvent: AnyPublisher<Void, Never>
        let repeatButtonDidTapEvent: AnyPublisher<Void, Never>
        let prevButtonDidTapEvent: AnyPublisher<Void, Never>
        let playButtonDidTapEvent: AnyPublisher<Void, Never>
        let nextButtonDidTapEvent: AnyPublisher<Void, Never>
        let shuffleButtonDidTapEvent: AnyPublisher<Void, Never>
        let playlistTableviewCellDidTapEvent: Observable<Int>
        let selectAllSongsButtonDidTapEvent: Observable<Bool>
        let addPlaylistButtonDidTapEvent: Observable<Void>
        let removeSongsButtonDidTapEvent: Observable<Void>
        let itemMovedEvent: Observable<(sourceIndex: IndexPath, destinationIndex: IndexPath)>
        
    }
    struct Output {
        var playerState = CurrentValueSubject<YouTubePlayer.PlaybackState, Never>(.unstarted)
        var willClosePlaylist = PassthroughSubject<Bool, Never>()
        var editState = CurrentValueSubject<Bool, Never>(false)
        var thumbnailImageURL = CurrentValueSubject<String, Never>("")
        var playTimeValue = CurrentValueSubject<Float, Never>(0.0)
        var totalTimeValue = CurrentValueSubject<Float, Never>(0.0)
        var currentSongIndex = CurrentValueSubject<Int, Never>(0)
        var repeatMode = CurrentValueSubject<RepeatMode, Never>(.none)
        var shuffleMode = CurrentValueSubject<ShuffleMode, Never>(.off)
        let dataSource: BehaviorRelay<[PlayListSectionModel]> = BehaviorRelay(value: [])
        let indexOfSelectedSongs: BehaviorRelay<[Int]> = BehaviorRelay(value: [])
        let songEntityOfSelectedSongs: BehaviorRelay<[SongEntity]> = BehaviorRelay(value: [])
    }
    
    private let playState = PlayState.shared
    private var isEditing = false
    internal var countOfSelectedSongs = 0
    private var subscription = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()
    
    init() {
        print("✅ PlaylistViewModel 생성")
    }
    
    deinit {
        print("❌ PlaylistViewModel deinit")
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
            output.willClosePlaylist.send(true)
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
            }.disposed(by: disposeBag)
        
        input.removeSongsButtonDidTapEvent
            .withLatestFrom(output.songEntityOfSelectedSongs){ $1 }
            .withLatestFrom(output.dataSource) { ($0,$1)}
            .map({ (ids:[SongEntity],dataSource:[PlayListDetailSectionModel])  -> [PlayListDetailSectionModel] in
                let remainDataSource = dataSource.first?.items.filter({ (song:SongEntity) in
                    return !ids.contains(song)
                })
                
                output.songEntityOfSelectedSongs.accept([])
                output.indexOfSelectedSongs.accept([])
                
                return [PlayListDetailSectionModel(model: 0, items: remainDataSource ?? [])]
            })
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        input.itemMovedEvent
            .map { (source: $0.row, dest: $1.row) }
            .subscribe(onNext: { [weak self] source, dest in
                guard let self else { return }
                var curr = output.dataSource.value.first?.items ?? []
                let tmp = curr[source]
                
                curr.remove(at:  source)
                curr.insert(tmp, at: dest)
                
                /* 데이터 소스 갱신부 */
                let newModel = [PlayListDetailSectionModel(model: 0, items: curr)]
                output.dataSource.accept(newModel)
                
                /* indexOfSelectedSongs 갱신부 */
                var indexs = output.indexOfSelectedSongs.value // 현재 선택된 인덱스 모음
                let sourceIsSelected: Bool = indexs.contains(where: { $0 == source }) // 선택된 것을 움직 였는지 ?

                //선택된 인덱스 배열 안에 source(시작점)이 있다는 뜻은 선택된 것을 옮긴다는 뜻
                //그러므로 일단 지워준다.
                if sourceIsSelected {
                    let pos = indexs.firstIndex(where: { $0 == source })!
                    indexs.remove(at: pos)
                }
                
                indexs = indexs.map({ i -> Int in
                    // 옮기기 시작한 위치와 도착한 위치가 i를 기준으로 앞일 때 아무 영향 없음
                    if source < i && i > dest { return i }
                    
                    // 옮기기 시작한 위치는 i 앞, 도착한 위치가 i 또는 i 뒤일 경우 i는 앞으로 한 칸 가야함
                    if source < i && i <= dest { return i - 1 }
                    
                    // 옮기기 시작한 위치는 i 뒤, 도착한 위치가 i 또는 i 앞일 경우 i는 뒤로 한칸 가야함
                    // 단 옮겨질 위치가 배열의 끝일 경우는 그대로 있음
                    if i < source && dest <= i { return i + 1 }

                    // 옮기기 시작한 위치는 i 뒤, 도착한 위치가 i 뒤 일 경우 아무 영향 없음
                    if source > i && i < dest { return i }
                    
                    return i
                })
                
                // 선택된 것을 건드렸으므로 dest 인덱스로 갱신하여 넣어준다
                if sourceIsSelected { indexs.append(dest) }
                
                indexs.sort()
                
                self.playState.playList.reorderPlaylist(from: source, to: dest)
                print("⭐️", self.playState.playList.currentPlayIndex)
                
                output.indexOfSelectedSongs.accept(indexs)
            }).disposed(by: disposeBag)
    }
    
    private func bindTableView(output: Output) {
        /*
         테이블뷰가 최초 생성될 때, PlayState.playlist.list 를 dataSource 에 pull
         dataSource에 변경이 일어날 때, dataSource 를 PlayState.playlist.list 에 push 하는 구조
         */
        self.pullForOriginalPlaylist(output: output)
        
        // dataSource에 변경이 일어날 때, 변경사항 push
        output.dataSource.subscribe { [weak self] _ in
            self?.pushToOriginalPlaylist(output: output)
        }.disposed(by: disposeBag)
        
        // cell 선택 시, cell의 isSelected 속성을 변경시키고 dataSource에 전달
        output.indexOfSelectedSongs
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { (selectedSongs, dataSource) in
                let playlist = dataSource.first?.items ?? []
                
                let items = playlist.enumerated().map { (index, item) -> SongEntity in
                    var newItem = item
                    newItem.isSelected = selectedSongs.contains(index)
                    return newItem
                }
                
                return [PlayListDetailSectionModel(model: 0, items: items)]
            }
            .bind(to: output.dataSource)
            .disposed(by: disposeBag)
        
        // cell 선택 시, cell의 index를 해당 곡으로 변경시키고 songEntityOfSelectedSongs에 전달
        output.indexOfSelectedSongs
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { (indexOfSelectedSongs, dataSource) in
                let playlist = dataSource.first?.items ?? []
                
                return indexOfSelectedSongs.map {
                        SongEntity(
                        id: playlist[$0].id,
                        title: playlist[$0].title,
                        artist: playlist[$0].artist,
                        remix: playlist[$0].remix,
                        reaction: playlist[$0].reaction,
                        views: playlist[$0].views,
                        last: playlist[$0].last,
                        date: playlist[$0].date
                    )
                }
            }
            .bind(to: output.songEntityOfSelectedSongs)
            .disposed(by: disposeBag)
        
        // 편집 종료 시, 셀 선택 초기화 및 변경사항 push
        output.editState
            .dropFirst()
            .filter { $0 == false }
            .sink { [weak self] _ in
                guard let self else { return }
                self.pushToOriginalPlaylist(output: output)
                output.indexOfSelectedSongs.accept([])
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
            guard let currentSongIndex = self.playState.playList.uniqueIndex(of: song) else { return }
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
        output.dataSource.accept([PlayListSectionModel(model: 0, items: playState.playList.list)])
    }
    
    private func pushToOriginalPlaylist(output: Output) {
        let localPlaylist = output.dataSource.value.first?.items ?? []
        self.playState.playList.list = localPlaylist
    }
}
