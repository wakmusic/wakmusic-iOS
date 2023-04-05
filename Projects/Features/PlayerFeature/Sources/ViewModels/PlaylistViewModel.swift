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
        let removeSongsButtonDidTapEvent: Observable<Void>
        
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
    }
    
    private func bindTableView(output: Output) {
        // 테이블뷰 -> 뷰모델 dataSource  < --- 동기화 --- > PlayState.playlist.list
        output.dataSource.accept([PlayListSectionModel(model: 0, items: playState.playList.list)])
        
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
}
